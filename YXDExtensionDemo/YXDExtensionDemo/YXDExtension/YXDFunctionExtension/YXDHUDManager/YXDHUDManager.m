//
//  YXDHUDManager.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "YXDHUDManager.h"

@interface YXDHUDManager ()

@property (nonatomic, strong) NSMutableArray<dispatch_block_t> *completionBlocks;

@end

static CGFloat const kYXDHUDManagerShowDelay = 0.2f;
static SVProgressHUDMaskType const YXDHUDManagerMaskTypeDefault = SVProgressHUDMaskTypeBlack;

@implementation YXDHUDManager

+ (void)showWithDuration:(CGFloat)duration {
    [self showWithDuration:duration completion:nil];
}

+ (void)showWithDuration:(CGFloat)duration completion:(dispatch_block_t)completion {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kYXDHUDManagerShowDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showWithMaskType:YXDHUDManagerMaskTypeDefault];
        [self dissmissAfterDuration:duration completion:completion];
    });
}

+ (void)showAndAutoDismissWithTitle:(NSString *)title {
    [self showAndAutoDismissWithTitle:title completion:nil];
}

+ (void)showAndAutoDismissWithTitle:(NSString *)title completion:(dispatch_block_t)completion {
    [self showWithTitle:title duration:[self displayDurationForString:title] completion:completion];
}

+ (void)showWithTitle:(NSString *)title duration:(CGFloat)duration {
    [self showWithTitle:title duration:duration completion:nil];
}

+ (void)showWithTitle:(NSString *)title duration:(CGFloat)duration completion:(dispatch_block_t)completion {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kYXDHUDManagerShowDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showWithStatus:title maskType:YXDHUDManagerMaskTypeDefault];
        [self dissmissAfterDuration:duration completion:completion];
    });
}

+ (void)showSuccessAndAutoDismissWithTitle:(NSString *)title {
    [self showSuccessAndAutoDismissWithTitle:title completion:nil];
}

+ (void)showSuccessAndAutoDismissWithTitle:(NSString *)title completion:(dispatch_block_t)completion {
    [self showSuccessWithTitle:title duration:[self displayDurationForString:title] completion:completion];
}

+ (void)showSuccessWithTitle:(NSString *)title duration:(CGFloat)duration {
    [self showSuccessWithTitle:title duration:duration completion:nil];
}

+ (void)showSuccessWithTitle:(NSString *)title duration:(CGFloat)duration completion:(dispatch_block_t)completion {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kYXDHUDManagerShowDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showSuccessWithStatus:title maskType:YXDHUDManagerMaskTypeDefault];
        [self dissmissAfterDuration:duration completion:completion];
    });
}

+ (void)showErrorAndAutoDismissWithTitle:(NSString *)title {
    [self showErrorAndAutoDismissWithTitle:title completion:nil];
}

+ (void)showErrorAndAutoDismissWithTitle:(NSString *)title completion:(dispatch_block_t)completion {
    [self showErrorWithTitle:title duration:[self displayDurationForString:title] completion:completion];
}

+ (void)showErrorWithTitle:(NSString *)title duration:(CGFloat)duration {
    [self showErrorWithTitle:title duration:duration completion:nil];
}

+ (void)showErrorWithTitle:(NSString *)title duration:(CGFloat)duration completion:(dispatch_block_t)completion {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kYXDHUDManagerShowDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showErrorWithStatus:title maskType:YXDHUDManagerMaskTypeDefault];
        [self dissmissAfterDuration:duration completion:completion];
    });
}

+ (void)dissmissAfterDuration:(CGFloat)duration completion:(dispatch_block_t)completion {
    if (completion) {
        [[YXDHUDManager sharedManager].completionBlocks addObject:completion];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
}

#pragma mark - Private

- (void)progressHUDDidDisappear {
    if (![YXDHUDManager sharedManager].completionBlocks.count) {
        return;
    }
    
    for (dispatch_block_t completion in [YXDHUDManager sharedManager].completionBlocks) {
        completion();
    }
    
    [[YXDHUDManager sharedManager].completionBlocks removeAllObjects];
}

+ (instancetype)sharedManager {
    static YXDHUDManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [YXDHUDManager new];
        manager.completionBlocks = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:manager selector:@selector(progressHUDDidDisappear) name:SVProgressHUDDidDisappearNotification object:nil];
    });
    return manager;
}

+ (NSTimeInterval)displayDurationForString:(NSString*)string {
    
    NSTimeInterval duration = 0.5 + (string.length * 0.2);
    
    if (duration < 1) {
        duration = 1;
    } else if (duration > 3) {
        duration = 3;
    }
    
    return duration;
}

@end
