//
//  UIApplication+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (YXDExtension)

+ (NSString *)appVersion;
+ (NSString *)buildVersion;

+ (void)callPhone:(NSString *)phone;

+ (NSCache *)sharedMemoryCache;
+ (NSCache *)sharedMemoryCacheForKey:(NSString *)key;

+ (void)removeMemoryCacheForKey:(NSString *)key;
+ (void)removeAllMemoryCache;

@end
