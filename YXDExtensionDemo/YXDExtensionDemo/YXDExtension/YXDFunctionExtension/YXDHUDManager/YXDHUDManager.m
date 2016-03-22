//
//  YXDHUDManager.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "YXDHUDManager.h"

@implementation YXDHUDManager

+ (void)showWithDuration:(CGFloat)duration {
    [self show];
    [self dissmissAfterDuration:duration completion:nil];
}

+ (void)showWithDuration:(CGFloat)duration completion:(dispatch_block_t)completion {
    [self showWithMaskType:SVProgressHUDMaskTypeBlack];
    [self dissmissAfterDuration:duration completion:completion];
}

+ (void)showAndAutoDismissWithTitle:(NSString *)title {
    [self showAndAutoDismissWithTitle:title completion:nil];
}

+ (void)showAndAutoDismissWithTitle:(NSString *)title completion:(dispatch_block_t)completion {
    [self showWithTitle:title duration:[self displayDurationForString:title] completion:completion];
}

+ (void)showWithTitle:(NSString *)title duration:(CGFloat)duration {
    [self showWithStatus:title];
    [self dissmissAfterDuration:duration completion:nil];
}

+ (void)showWithTitle:(NSString *)title duration:(CGFloat)duration completion:(dispatch_block_t)completion {
    [self showWithStatus:title maskType:SVProgressHUDMaskTypeBlack];
    [self dissmissAfterDuration:duration completion:completion];
}

+ (void)showSuccessAndAutoDismissWithTitle:(NSString *)title {
    [self showSuccessAndAutoDismissWithTitle:title completion:nil];
}

+ (void)showSuccessAndAutoDismissWithTitle:(NSString *)title completion:(dispatch_block_t)completion {
    [self showSuccessWithTitle:title duration:[self displayDurationForString:title] completion:completion];
}

+ (void)showSuccessWithTitle:(NSString *)title duration:(CGFloat)duration {
    [self showSuccessWithStatus:title];
    [self dissmissAfterDuration:duration completion:nil];
}

+ (void)showSuccessWithTitle:(NSString *)title duration:(CGFloat)duration completion:(dispatch_block_t)completion {
    [self showSuccessWithStatus:title maskType:SVProgressHUDMaskTypeBlack];
    [self dissmissAfterDuration:duration completion:completion];
}

+ (void)showErrorAndAutoDismissWithTitle:(NSString *)title {
    [self showErrorAndAutoDismissWithTitle:title completion:nil];
}

+ (void)showErrorAndAutoDismissWithTitle:(NSString *)title completion:(dispatch_block_t)completion {
    [self showErrorWithTitle:title duration:[self displayDurationForString:title] completion:completion];
}

+ (void)showErrorWithTitle:(NSString *)title duration:(CGFloat)duration {
    [self showErrorWithStatus:title];
    [self dissmissAfterDuration:duration completion:nil];
}

+ (void)showErrorWithTitle:(NSString *)title duration:(CGFloat)duration completion:(dispatch_block_t)completion {
    [self showErrorWithStatus:title maskType:SVProgressHUDMaskTypeBlack];
    [self dissmissAfterDuration:duration completion:completion];
}

+ (void)dissmissAfterDuration:(CGFloat)duration completion:(dispatch_block_t)completion {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
        if (completion) {
            completion();
        }
    });
}

#pragma mark - Private

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
