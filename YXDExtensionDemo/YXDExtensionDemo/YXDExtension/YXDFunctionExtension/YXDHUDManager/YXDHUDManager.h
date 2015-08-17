//
//  YXDHUDManager.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "SVProgressHUD.h"

@interface YXDHUDManager : SVProgressHUD

+ (void)showWithDuration:(CGFloat)duration;
+ (void)showWithDuration:(CGFloat)duration completion:(dispatch_block_t)completion;

+ (void)showWithTitle:(NSString *)title duration:(CGFloat)duration;
+ (void)showWithTitle:(NSString *)title duration:(CGFloat)duration completion:(dispatch_block_t)completion;

+ (void)showSuccessWithTitle:(NSString *)title duration:(CGFloat)duration;
+ (void)showSuccessWithTitle:(NSString *)title duration:(CGFloat)duration completion:(dispatch_block_t)completion;

+ (void)showErrorWithTitle:(NSString *)title duration:(CGFloat)duration;
+ (void)showErrorWithTitle:(NSString *)title duration:(CGFloat)duration completion:(dispatch_block_t)completion;

@end
