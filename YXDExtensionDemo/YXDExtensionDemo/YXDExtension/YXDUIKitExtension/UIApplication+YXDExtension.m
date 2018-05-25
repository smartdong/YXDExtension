//
//  UIApplication+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "UIApplication+YXDExtension.h"
#import "UIImage+YXDExtension.h"

@implementation UIApplication (YXDExtension)

+ (NSDictionary<NSString *, id> *)infoDictionary {
    return [NSBundle mainBundle].infoDictionary;
}

+ (NSString *)bundleIdentifier {
    return [[NSBundle mainBundle] bundleIdentifier];
}

+ (NSString *)appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSString *)buildVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

+ (UIImage *)appIcon {
    return [UIImage appIcon];
}

+ (void)callPhone:(NSString *)phone {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]]];
}

@end
