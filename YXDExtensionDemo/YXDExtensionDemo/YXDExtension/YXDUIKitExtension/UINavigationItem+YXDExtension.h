//
//  UINavigationItem+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (YXDExtension)

- (void)setLeftBarItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (void)setLeftBarItemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action;

- (void)setRightBarItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (void)setRightBarItemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action;

@end
