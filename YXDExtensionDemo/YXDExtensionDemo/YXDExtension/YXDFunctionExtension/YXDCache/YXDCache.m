//
//  YXDCache.m
//  YXDExtensionDemo
//
//  Copyright © 2015年 YangXudong. All rights reserved.
//

#import "YXDCache.h"

@implementation YXDCache

+ (NSCache *)sharedMemoryCache {
    static YXDCache *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [YXDCache new];
    });
    return cache;
}

+ (NSCache *)sharedMemoryCacheForKey:(NSString *)key {
    NSCache *cache = [[YXDCache sharedMemoryCache] objectForKey:key];
    if (!cache) {
        cache = [NSCache new];
        [[YXDCache sharedMemoryCache] setObject:cache forKey:key];
    }
    return cache;
}

+ (void)removeMemoryCacheForKey:(NSString *)key {
    [[YXDCache sharedMemoryCache] removeObjectForKey:key];
}

+ (void)removeAllMemoryCache {
    [[YXDCache sharedMemoryCache] removeAllObjects];
}

@end
