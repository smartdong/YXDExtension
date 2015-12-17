//
//  UIApplication+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "UIApplication+YXDExtension.h"
#import <objc/message.h>

static const void *YXDExtensionUIApplicationSharedMemoryCacheMapKey = &YXDExtensionUIApplicationSharedMemoryCacheMapKey;

@interface UIApplication ()

@property (nonatomic, strong) NSMutableDictionary *sharedMemoryCacheMap;

@end

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
    return [self sharedMemoryCacheForKey:@"YXDExtensionUIApplicationSharedMemoryCacheDefaultKey"];
}

+ (NSCache *)sharedMemoryCacheForKey:(NSString *)key {
    NSMutableDictionary *sharedMemoryCacheMap = [UIApplication sharedApplication].sharedMemoryCacheMap;
    if (!sharedMemoryCacheMap) {
        sharedMemoryCacheMap = [NSMutableDictionary dictionary];
        [UIApplication sharedApplication].sharedMemoryCacheMap = sharedMemoryCacheMap;
    }
    
    NSCache *cache = [sharedMemoryCacheMap objectForKey:key];
    if (!cache) {
        cache = [NSCache new];
        [sharedMemoryCacheMap setObject:cache forKey:key];
    }
    return cache;
}

+ (void)removeMemoryCacheForKey:(NSString *)key {
    NSMutableDictionary *sharedMemoryCacheMap = [UIApplication sharedApplication].sharedMemoryCacheMap;
    [sharedMemoryCacheMap removeObjectForKey:key];
}

+ (void)removeAllMemoryCache {
    NSMutableDictionary *sharedMemoryCacheMap = [UIApplication sharedApplication].sharedMemoryCacheMap;
    [sharedMemoryCacheMap removeAllObjects];
}

#pragma mark - Shit

- (void)setSharedMemoryCacheMap:(NSMutableDictionary *)sharedMemoryCacheMap {
    objc_setAssociatedObject(self, YXDExtensionUIApplicationSharedMemoryCacheMapKey, sharedMemoryCacheMap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)sharedMemoryCacheMap {
    return objc_getAssociatedObject(self, YXDExtensionUIApplicationSharedMemoryCacheMapKey);
}

@end
