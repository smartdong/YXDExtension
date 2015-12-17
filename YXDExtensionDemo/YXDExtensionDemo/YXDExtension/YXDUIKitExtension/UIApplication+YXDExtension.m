//
//  UIApplication+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "UIApplication+YXDExtension.h"
#import "YXDCache.h"

@implementation UIApplication (YXDExtension)

+ (NSString *)appVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSString *)buildVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

+ (void)callPhone:(NSString *)phone {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]]];
}

+ (NSCache *)sharedMemoryCache {
    return [YXDCache sharedMemoryCache];
}

+ (NSCache *)sharedMemoryCacheForKey:(NSString *)key {
    return [YXDCache sharedMemoryCacheForKey:key];
}

+ (void)removeMemoryCacheForKey:(NSString *)key {
    [YXDCache removeMemoryCacheForKey:key];
}

+ (void)removeAllMemoryCache {
    [YXDCache removeAllMemoryCache];
}

@end
