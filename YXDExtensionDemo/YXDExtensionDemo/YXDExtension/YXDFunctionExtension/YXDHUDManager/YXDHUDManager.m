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

+ (void)showWithTitle:(NSString *)title duration:(CGFloat)duration {
    [self showWithStatus:title];
    [self dissmissAfterDuration:duration completion:nil];
}

+ (void)showWithTitle:(NSString *)title duration:(CGFloat)duration completion:(dispatch_block_t)completion {
    [self showWithStatus:title maskType:SVProgressHUDMaskTypeBlack];
    [self dissmissAfterDuration:duration completion:completion];
}

+ (void)showSuccessWithTitle:(NSString *)title duration:(CGFloat)duration {
    [self showSuccessWithStatus:title];
    [self dissmissAfterDuration:duration completion:nil];
}

+ (void)showSuccessWithTitle:(NSString *)title duration:(CGFloat)duration completion:(dispatch_block_t)completion {
    [self showSuccessWithStatus:title maskType:SVProgressHUDMaskTypeBlack];
    [self dissmissAfterDuration:duration completion:completion];
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

@end
