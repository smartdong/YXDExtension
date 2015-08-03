//
//  UIAlertView+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DismissBlock)(NSInteger buttonIndex);
typedef void (^CancelBlock)();

@interface UIAlertView (YXDExtension)

+ (UIAlertView*) showAlertViewWithTitle:(NSString*)title
                                message:(NSString*)message
                      cancelButtonTitle:(NSString*)cancelButtonTitle
                      otherButtonTitles:(NSArray*)otherButtons
                              onDismiss:(DismissBlock)dismissed
                               onCancel:(CancelBlock)cancelled;

@end
