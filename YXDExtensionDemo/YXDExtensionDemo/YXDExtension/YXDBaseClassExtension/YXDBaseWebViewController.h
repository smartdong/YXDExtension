//
//  YXDBaseWebViewController.h
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import "YXDBaseViewController.h"

@class EasyJSWebView;

@interface YXDBaseWebViewController : YXDBaseViewController

@property (nonatomic, strong) EasyJSWebView *webView;

@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) BOOL showLoadingBar;              //Default YES

@property (nonatomic, strong) UIColor *loadingBarTintColor;     //Default colour is iOS system blue

- (instancetype)initWithUrl:(NSString *)url;

//加载 self.url  会在 viewWillAppear 时自动调用
- (void)loadRequest;

//调用 js 方法
- (void)javascriptMethodName:(NSString *)methodName paramString:(NSString *)paramString;

#pragma mark - 提供给H5调用的方法

- (void)popWebViewController;

@end
