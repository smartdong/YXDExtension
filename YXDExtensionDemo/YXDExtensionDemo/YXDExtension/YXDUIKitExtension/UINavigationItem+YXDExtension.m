//
//  UINavigationItem+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "UINavigationItem+YXDExtension.h"

@implementation UINavigationItem (YXDExtension)

- (void)setLeftBarItemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    self.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
}

- (void)setLeftBarItemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action {
    self.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStylePlain target:target action:action];
}

- (void)setRightBarItemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
}

- (void)setRightBarItemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action {
    self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStylePlain target:target action:action];
}

@end
