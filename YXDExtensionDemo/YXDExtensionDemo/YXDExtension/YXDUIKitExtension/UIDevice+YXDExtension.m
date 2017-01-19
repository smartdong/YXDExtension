//
//  UIDevice+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright © 2015年 YangXudong. All rights reserved.
//

#import "UIDevice+YXDExtension.h"
#import <sys/utsname.h>

@implementation UIDevice (YXDExtension)

+ (NSString *)name {
    return [UIDevice currentDevice].name;
}

+ (NSString *)model {
    return [UIDevice currentDevice].model;
}

+ (NSString *)localizedModel {
    return [UIDevice currentDevice].localizedModel;
}

+ (NSString *)systemName {
    return [UIDevice currentDevice].systemName;
}

+ (NSString *)systemVersion {
    return [UIDevice currentDevice].systemVersion;
}

+ (NSString *)deviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

+ (void)setOrientation:(UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

@end
