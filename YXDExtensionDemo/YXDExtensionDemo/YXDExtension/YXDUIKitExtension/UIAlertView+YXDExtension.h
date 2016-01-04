//
//  UIAlertView+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^YXDExtensionAlertViewDismissBlock)(NSInteger buttonIndex);
typedef void (^YXDExtensionAlertViewCancelBlock)();

@interface UIAlertView (YXDExtension)

+ (UIAlertView *) showAlertViewWithTitle:(NSString *)title
                                 message:(NSString *)message
                       cancelButtonTitle:(NSString *)cancelButtonTitle
                       otherButtonTitles:(NSArray<NSString *> *)otherButtons
                               onDismiss:(YXDExtensionAlertViewDismissBlock)dismissed
                                onCancel:(YXDExtensionAlertViewCancelBlock)cancelled;

@end
