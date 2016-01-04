//
//  UIWindow+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "UIWindow+YXDExtension.h"

@implementation UIWindow (YXDExtension)

+ (UIWindow *)window {
    return [[UIApplication sharedApplication].delegate window];
}

+ (UIViewController *)rootViewController {
    return [[self window] rootViewController];
}

@end
