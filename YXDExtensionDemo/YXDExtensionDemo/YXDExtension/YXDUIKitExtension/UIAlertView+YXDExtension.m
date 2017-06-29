//
//  UIAlertView+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "UIAlertView+YXDExtension.h"
#import "CustomIOSAlertView.h"

static YXDExtensionAlertViewDismissBlock _dismissBlock;
static YXDExtensionAlertViewCancelBlock _cancelBlock;

@implementation UIAlertView (YXDExtension)

+ (UIAlertView *)showAlertViewWithTitle:(NSString *)title
                                message:(NSString *)message
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                      otherButtonTitles:(NSArray<NSString *> *)otherButtons
                              onDismiss:(YXDExtensionAlertViewDismissBlock)dismissed
                               onCancel:(YXDExtensionAlertViewCancelBlock)cancelled{
    
    _cancelBlock = [cancelled copy];
    _dismissBlock = [dismissed copy];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:[self self]
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:nil];
    
    for(NSString *buttonTitle in otherButtons) {
        [alert addButtonWithTitle:buttonTitle];
    }
    
    [alert show];
    return alert;
}

+ (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger) buttonIndex {
    if(buttonIndex == [alertView cancelButtonIndex]) {
        if (_cancelBlock) {
            _cancelBlock();
        }
    } else {
        if (_dismissBlock) {
            _dismissBlock(buttonIndex - 1); // cancel button is button 0
        }
    }
}

+ (dispatch_block_t)alertCustomView:(UIView *)view {
    CustomIOSAlertView *customAlertView = [CustomIOSAlertView new];
    [customAlertView setButtonTitles:nil];
    [customAlertView setContainerView:view];
    [customAlertView setUseMotionEffects:TRUE];
    [customAlertView show];
    return ^{
        [customAlertView close];
    };
}

@end
