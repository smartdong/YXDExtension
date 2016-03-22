//
//  YXDBaseWebViewController.m
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import "YXDBaseWebViewController.h"
#import "EasyJSWebView.h"
#import "NSString+YXDExtension.h"

#define DEFAULT_BAR_TINT_COLOR  [UIColor colorWithRed:0.0f green:110.0f/255.0f blue:1.0f alpha:1.0f]
#define LOADING_BAR_HEIGHT      2

static const float kInitialProgressValue                = 0.1f;
static const float kBeforeInteractiveMaxProgressValue   = 0.5f;
static const float kAfterInteractiveMaxProgressValue    = 0.9f;

static NSString *kCompleteRPCURL = @"webviewprogress:///complete";  //Unique URL triggered when JavaScript reports page load is complete

static NSString *kJavascriptInterfacesName = @"demo";

@interface YXDBaseWebViewController () <UIWebViewDelegate> {
    struct {
        NSInteger   loadingCount;       //Number of requests concurrently being handled
        NSInteger   maxLoadCount;       //Maximum number of load requests that was reached
        BOOL        interactive;        //Load progress has reached the point where users may interact with the content
        CGFloat     loadingProgress;    //Between 0.0 and 1.0, the load progress of the current page
    } _loadingProgressState;
}

@property (nonatomic, strong) UIView *loadingBarView;

- (void)resetLoadProgress;
- (void)startLoadProgress;
- (void)incrementLoadProgress;
- (void)finishLoadProgress;
- (void)setLoadingProgress:(CGFloat)loadingProgress;
- (void)handleLoadRequestCompletion;

@end

@implementation YXDBaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initWebView];
    
    [self initLoadingBar];
    
    self.webView.scrollView.scrollEnabled = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.url.length && !self.webView.request) {
        [self loadRequest];
    }
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.webView.frame = self.view.bounds;
    
    self.loadingBarView.frame = ({
        CGRect frame = self.loadingBarView.frame;
        frame.origin.y = self.webView.scrollView.contentInset.top;
        frame.origin.x = -CGRectGetWidth(self.loadingBarView.frame) + (CGRectGetWidth(self.view.bounds) * _loadingProgressState.loadingProgress);
        frame;
    });
}

#pragma mark - Init

- (instancetype)initWithUrl:(NSString *)url {
    self = [super init];
    if (self) {
        self.url = url;
        self.showLoadingBar = YES;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)initWebView {
    self.webView = [[EasyJSWebView alloc] initWithFrame:self.view.bounds];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [self addJavascriptInterfaces];
    self.backgroundColor = self.backgroundColor ? : [UIColor whiteColor];
}

- (void)initLoadingBar {
    CGFloat y = self.webView.scrollView.contentInset.top;
    self.loadingBarView = [[UIView alloc] initWithFrame:CGRectMake(0, y,self.view.frame.size.width, LOADING_BAR_HEIGHT)];
    self.loadingBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    if (self.loadingBarTintColor == nil) {
        if (self.navigationController && self.navigationController.view.window.tintColor) {
            self.loadingBarView.backgroundColor = self.navigationController.view.window.tintColor;
        }
        else if (self.view.window.tintColor) {
            self.loadingBarView.backgroundColor = self.view.window.tintColor;
        }
        else {
            self.loadingBarView.backgroundColor = DEFAULT_BAR_TINT_COLOR;
        }
    }
    else {
        self.loadingBarView.backgroundColor = self.loadingBarTintColor;
    }
}

#pragma mark - Method

- (void)loadRequest {
    if (!self.url.length) {
        return;
    }
    
    [self.webView loadRequest:self.url.urlRequest];
}

- (void)addJavascriptInterfaces {
    [self.webView addJavascriptInterfaces:self WithName:kJavascriptInterfacesName];
}

- (void)javascriptMethodName:(NSString *)methodName paramString:(NSString *)paramString {
    if (!methodName.length) {
        return;
    }
    
    NSString *jsString = nil;
    
    if (paramString) {
        jsString = [NSString stringWithFormat:@"%@('%@');",methodName,paramString];
    } else {
        jsString = [NSString stringWithFormat:@"%@();",methodName];
    }
    
    [self.webView stringByEvaluatingJavaScriptFromString:jsString];
}

#pragma mark - 提供给H5调用的方法

- (void)popWebViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Setter

-(void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    self.view.backgroundColor = backgroundColor;
    self.webView.backgroundColor = backgroundColor;
}

- (void)setLoadingBarTintColor:(UIColor *)loadingBarTintColor {
    _loadingBarTintColor = loadingBarTintColor;
    self.loadingBarView.backgroundColor = self.loadingBarTintColor;
}

#pragma mark - Web View Delegate

-(void)webViewDidStartLoad:(UIWebView *)webView {
    _loadingProgressState.loadingCount++;
    _loadingProgressState.maxLoadCount = MAX(_loadingProgressState.maxLoadCount, _loadingProgressState.loadingCount);
    [self startLoadProgress];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [self handleLoadRequestCompletion];
    
    self.navigationItem.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    [self addJavascriptInterfaces];
    
    self.webView.scrollView.scrollEnabled = YES;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self handleLoadRequestCompletion];
    
    self.webView.scrollView.scrollEnabled = YES;
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    //if the URL is the load completed notification from JavaScript
    if ([request.URL.absoluteString isEqualToString:kCompleteRPCURL]) {
        [self finishLoadProgress];
        return NO;
    }
    
    //If the URL contrains a fragement jump (eg an anchor tag), check to see if it relates to the current page, or another
    //If we're merely jumping around the same page, don't perform a new loading bar sequence
    BOOL isFragmentJump = NO;
    if (request.URL.fragment) {
        NSString *nonFragmentURL = [request.URL.absoluteString stringByReplacingOccurrencesOfString:[@"#" stringByAppendingString:request.URL.fragment] withString:@""];
        isFragmentJump = [nonFragmentURL isEqualToString:webView.request.URL.absoluteString];
    }
    
    BOOL isTopLevelNavigation = [request.mainDocumentURL isEqual:request.URL];
    BOOL isHTTP = [request.URL.scheme isEqualToString:@"http"] || [request.URL.scheme isEqualToString:@"https"];
    if (!isFragmentJump && isHTTP && isTopLevelNavigation && (navigationType != UIWebViewNavigationTypeBackForward)) {
        [self resetLoadProgress];
    }
    
    return YES;
}

#pragma mark - Page Load Progress Tracking Handlers

- (void)resetLoadProgress {
    memset(&_loadingProgressState, 0, sizeof(_loadingProgressState));
    [self setLoadingProgress:0.0f];
}

- (void)startLoadProgress {
    //If we haven't started loading yet, set the progress to small, but visible value
    if (_loadingProgressState.loadingProgress < kInitialProgressValue) {
        //reset the loading bar
        CGRect frame = self.loadingBarView.frame;
        frame.size.width = CGRectGetWidth(self.view.bounds);
        frame.origin.x = -frame.size.width;
        frame.origin.y = self.webView.scrollView.contentInset.top;
        self.loadingBarView.frame = frame;
        self.loadingBarView.alpha = 1.0f;
        
        //add the loading bar to the view
        if (self.showLoadingBar) {
            [self.view insertSubview:self.loadingBarView aboveSubview:self.webView];
        }
        
        //kickstart the loading progress
        [self setLoadingProgress:kInitialProgressValue];
        
        //show that loading started in the status bar
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
}

- (void)incrementLoadProgress {
    float progress          = _loadingProgressState.loadingProgress;
    float maxProgress       = _loadingProgressState.interactive ? kAfterInteractiveMaxProgressValue : kBeforeInteractiveMaxProgressValue;
    float remainingPercent  = (float)_loadingProgressState.loadingCount / (float)_loadingProgressState.maxLoadCount;
    float increment         = (maxProgress - progress) * remainingPercent;
    progress                = fmin((progress+increment), maxProgress);
    
    [self setLoadingProgress:progress];
}

- (void)finishLoadProgress {
    //hide the activity indicator in the status bar
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    //reset the load progress
    [self setLoadingProgress:1.0f];
    
    //in case it didn't succeed yet, try setting the page title again
    self.navigationItem.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)setLoadingProgress:(CGFloat)loadingProgress {
    // progress should be incremental only
    if (loadingProgress > _loadingProgressState.loadingProgress || loadingProgress == 0) {
        _loadingProgressState.loadingProgress = loadingProgress;
        
        //Update the loading bar progress to match
        if (self.showLoadingBar) {
            CGRect frame = self.loadingBarView.frame;
            frame.origin.x = -CGRectGetWidth(self.loadingBarView.frame) + (CGRectGetWidth(self.view.bounds) * _loadingProgressState.loadingProgress);
            
            [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.loadingBarView.frame = frame;
            } completion:^(BOOL finished) {
                //once loading is complete, fade it out
                if (loadingProgress >= 1.0f - FLT_EPSILON) {
                    [UIView animateWithDuration:0.2f animations:^{
                        self.loadingBarView.alpha = 0.0f;
                    }];
                }
            }];
        }
    }
}

- (void)handleLoadRequestCompletion {
    //decrement the number of concurrent requests
    _loadingProgressState.loadingCount--;
    
    //update the progress bar
    [self incrementLoadProgress];
    
    //Query the webview to see what load state JavaScript perceives it at
    NSString *readyState = [self.webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    
    //interactive means the page has loaded sufficiently to allow user interaction now
    BOOL interactive = [readyState isEqualToString:@"interactive"];
    if (interactive) {
        _loadingProgressState.interactive = YES;
        
        //if we're at the interactive state, attach a Javascript listener to inform us when the page has fully loaded
        NSString *waitForCompleteJS = [NSString stringWithFormat:   @"window.addEventListener('load',function() { "
                                       @"var iframe = document.createElement('iframe');"
                                       @"iframe.style.display = 'none';"
                                       @"iframe.src = '%@';"
                                       @"document.body.appendChild(iframe);"
                                       @"}, false);", kCompleteRPCURL];
        
        [self.webView stringByEvaluatingJavaScriptFromString:waitForCompleteJS];
        
        //see if we can set the proper page title yet
        self.navigationItem.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    
    BOOL complete = [readyState isEqualToString:@"complete"];
    if (complete) {
        [self finishLoadProgress];
    }
}

@end
