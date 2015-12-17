//
//  YXDCache.h
//  YXDExtensionDemo
//
//  Copyright © 2015年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXDCache : NSCache

+ (NSCache *)sharedMemoryCache;
+ (NSCache *)sharedMemoryCacheForKey:(NSString *)key;

+ (void)removeMemoryCacheForKey:(NSString *)key;
+ (void)removeAllMemoryCache;

@end
