//
//  UIScrollView+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "UIScrollView+YXDExtension.h"
#import <objc/runtime.h>
#import "MJRefresh.h"

@interface YXDLoadStatusView : UIView

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) YXDLoadStatus loadStatus; //当前的状态

@property (nonatomic, copy) dispatch_block_t pullLoadingBlock;      //下拉刷新的block 如果不设置则表示不需要下拉刷新
@property (nonatomic, copy) dispatch_block_t footerLoadingBlock;    //上提加载的block 如果不设置则表示不需要上提加载 且如果没有设置pullLoadingBlock时无效

@property (nonatomic, strong) NSString *failedStatusTitle;
@property (nonatomic, strong) NSString *emptyStatusTitle;
@property (nonatomic, strong) NSString *failedStatusImageName;
@property (nonatomic, strong) NSString *emptyStatusImageName;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLable;

//仅 YXDLoadStatusEmpty 和 YXDLoadStatusFailed 有效
- (void)setTitle:(NSString *)title imageName:(NSString *)imageName forStatus:(YXDLoadStatus)status;

//不再显示上提加载数据
- (void)noticeFooterNoMoreData;

@end

#define kYXDLoadStatusDefaultTitleColor [UIColor colorWithRed:100/255. green:100/255. blue:100/255. alpha:1]

static NSString *kYXDLoadStatusDefaultFailedTitle = @"加载失败，点击重试";
static NSString *kYXDLoadStatusDefaultEmptyTitle = @"暂无内容";

@implementation YXDLoadStatusView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    
    self.hidden = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicator.hidesWhenStopped = YES;
    
    _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 100)];
    _titleLable.textColor = kYXDLoadStatusDefaultTitleColor;
    _titleLable.textAlignment = NSTextAlignmentCenter;
    _titleLable.backgroundColor = [UIColor clearColor];
    _titleLable.font = [UIFont systemFontOfSize:14];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _imageView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_indicator];
    [self addSubview:_titleLable];
    [self addSubview:_imageView];
    
    _indicator.hidden = YES;
    _titleLable.hidden = YES;
    _imageView.hidden = YES;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloading)];
    [self addGestureRecognizer:tap];
}

- (void)setPullLoadingBlock:(dispatch_block_t)pullLoadingBlock {
    _pullLoadingBlock = pullLoadingBlock;
    if (pullLoadingBlock) {
        __weak typeof(self) weakSelf = self;
        self.scrollView.header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
            [weakSelf.scrollView.footer resetNoMoreData];
            pullLoadingBlock();
        }];
    }
}

- (void)setFooterLoadingBlock:(dispatch_block_t)footerLoadingBlock {
    _footerLoadingBlock = footerLoadingBlock;
    if (footerLoadingBlock) {
        self.scrollView.footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:footerLoadingBlock];
    }
}

- (void)setLoadStatus:(YXDLoadStatus)loadStatus {

    if ((_loadStatus == loadStatus) && (loadStatus == YXDLoadStatusLoading)) {
        return;
    }
    
    _loadStatus = loadStatus;
    
    switch (loadStatus) {
        case YXDLoadStatusLoading:
        {
            if (self.pullLoadingBlock) {
                [self.scrollView.footer resetNoMoreData];
                self.pullLoadingBlock();
            } else {
                self.loadStatus = YXDLoadStatusEmpty;
            }
        }
            break;
        case YXDLoadStatusSuccess:
        case YXDLoadStatusFailed:
        case YXDLoadStatusEmpty:
        {
            [self.scrollView.header endRefreshing];
            if (self.scrollView.footer.state != MJRefreshStateNoMoreData) {
                [self.scrollView.footer endRefreshing];
            }
        }
            break;
    }

    [self layoutImageViewAndTitleLable];
    
    if ([self.scrollView respondsToSelector:@selector(reloadData)]) {
        [(id)self.scrollView reloadData];
    }
}

- (void)layoutImageViewAndTitleLable {
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    center.y -= self.scrollView.contentInset.top;
    
    //先禁止滚动 等成功以后才允许滚动
    self.scrollView.scrollEnabled = NO;
    
    switch (self.loadStatus) {
        case YXDLoadStatusLoading:
        {
            self.indicator.center = center;
            
            self.imageView.hidden = YES;
            self.titleLable.hidden = YES;
            self.indicator.hidden = NO;
            
            [self.indicator startAnimating];
        }
            break;
        case YXDLoadStatusSuccess:
        {
            [self.indicator stopAnimating];
            
            self.imageView.hidden = YES;
            self.titleLable.hidden = YES;
            self.indicator.hidden = YES;
            
            self.scrollView.scrollEnabled = YES;
        }
            break;
        case YXDLoadStatusFailed:
        case YXDLoadStatusEmpty:
        {
            [self.indicator stopAnimating];
            self.indicator.hidden = YES;
            
            NSString *title = nil;
            NSString *imageName = nil;
            
            switch (self.loadStatus) {
                case YXDLoadStatusFailed:
                {
                    imageName = self.failedStatusImageName;
                    title = imageName.length?self.failedStatusTitle:(self.failedStatusTitle.length?self.failedStatusTitle:kYXDLoadStatusDefaultFailedTitle);
                }
                    break;
                case YXDLoadStatusEmpty:
                {
                    imageName = self.emptyStatusImageName;
                    title = imageName.length?self.emptyStatusTitle:(self.emptyStatusTitle.length?self.emptyStatusTitle:kYXDLoadStatusDefaultEmptyTitle);
                }
                    break;
                default:
                    break;
            }
            
            if (imageName.length) {
                UIImage *image = [UIImage imageNamed:imageName];
                self.imageView.image = image;
                self.imageView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
            }
            
            if (title.length) {
                self.titleLable.text = title;
            }
            
            if (title.length && imageName.length) {
                //标题和图片都在
                self.imageView.center = CGPointMake(center.x, center.y - self.titleLable.bounds.size.height / 2);
                self.titleLable.center = CGPointMake(center.x, self.imageView.center.y + self.imageView.bounds.size.height / 2 + self.titleLable.bounds.size.height / 2);
                
                self.imageView.hidden = NO;
                self.titleLable.hidden = NO;
            } else if (imageName.length) {
                //只有图片
                self.imageView.center = center;
                
                self.imageView.hidden = NO;
                self.titleLable.hidden = YES;
            } else {
                //只有标题
                self.titleLable.center = center;
                
                self.imageView.hidden = YES;
                self.titleLable.hidden = NO;
            }
        }
            break;
    }
    
    if (self.loadStatus == YXDLoadStatusSuccess) {
        self.hidden = YES;
    } else {
        self.hidden = NO;
        [self.scrollView bringSubviewToFront:self];
    }
}

- (void)setTitle:(NSString *)title imageName:(NSString *)imageName forStatus:(YXDLoadStatus)status {
    switch (status) {
        case YXDLoadStatusFailed:
        {
            self.failedStatusTitle = title;
            self.failedStatusImageName = imageName;
        }
            break;
        case YXDLoadStatusEmpty:
        {
            self.emptyStatusTitle = title;
            self.emptyStatusImageName = imageName;
        }
            break;
        default:
            break;
    }
}

- (void)noticeFooterNoMoreData {
    [self.scrollView.footer noticeNoMoreData];
}

- (void)reloading {
    if ((self.loadStatus == YXDLoadStatusEmpty) || (self.loadStatus == YXDLoadStatusFailed)) {
        self.loadStatus = YXDLoadStatusLoading;
    }
}

@end


@interface UIScrollView ()

@property (nonatomic, strong, readonly) YXDLoadStatusView *loadStatusView;

@end

@implementation UIScrollView (YXDExtension)

static const void *YXDExtensionLoadStatusViewKey = &YXDExtensionLoadStatusViewKey;

- (void)setLoadStatusView:(YXDLoadStatusView *)loadStatusView {
    objc_setAssociatedObject(self, &YXDExtensionLoadStatusViewKey, loadStatusView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YXDLoadStatusView *)loadStatusView {
    return objc_getAssociatedObject(self, &YXDExtensionLoadStatusViewKey);
}

- (void)triggerLoading {
    self.loadStatusView.loadStatus = YXDLoadStatusLoading;
}

- (void)setStatusSuccess {
    self.loadStatusView.loadStatus = YXDLoadStatusSuccess;
}

- (void)setStatusFail {
    self.loadStatusView.loadStatus = YXDLoadStatusFailed;
}

- (void)setStatusEmpty {
    self.loadStatusView.loadStatus = YXDLoadStatusEmpty;
}

- (void)noticeFooterNoMoreData {
    [self.loadStatusView noticeFooterNoMoreData];
}

- (void)addLoadStatusViewWithPullLoadingBlock:(dispatch_block_t)pullLoadingBlock footerLoadingBlock:(dispatch_block_t)footerLoadingBlock {
    if (self.loadStatusView || !pullLoadingBlock) {
        return;
    }
    
    YXDLoadStatusView *loadStatusView = [[YXDLoadStatusView alloc] initWithFrame:self.bounds];
    loadStatusView.backgroundColor = self.backgroundColor;
    loadStatusView.scrollView = self;
    loadStatusView.pullLoadingBlock = pullLoadingBlock;
    loadStatusView.footerLoadingBlock = footerLoadingBlock;
    self.loadStatusView = loadStatusView;
    [self addSubview:loadStatusView];
}

- (void)setTitle:(NSString *)title imageName:(NSString *)imageName forStatus:(YXDLoadStatus)status {
    [self.loadStatusView setTitle:title imageName:imageName forStatus:status];
}

@end
