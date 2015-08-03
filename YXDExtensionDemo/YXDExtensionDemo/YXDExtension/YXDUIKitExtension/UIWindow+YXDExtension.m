//
//  UIWindow+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "UIWindow+YXDExtension.h"

@implementation UIWindow (YXDExtension)

+ (UIWindow *)appWindow {
    return [[UIApplication sharedApplication].delegate window];
}

+ (UIWindow *)keyWindow {
    return [[UIApplication sharedApplication] keyWindow];
}

+ (UIViewController *)appRootViewController {
    return [[self appWindow] rootViewController];
}

@end
