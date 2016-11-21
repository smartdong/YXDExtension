//
//  YXDCommonFunction.h
//  YXDExtensionDemo
//
//  Created by YangXudong on 15/10/17.
//  Copyright © 2015年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXDCommonFunction : NSObject

#pragma mark - User Defaults

+ (void)setUserDefaultsValue:(id)value forKey:(NSString *)key;
+ (void)setUserDefaultsValue:(id)value forKey:(NSString *)key account:(NSString *)account;

+ (id)userDefaultsValueForKey:(NSString *)key;
+ (id)userDefaultsValueForKey:(NSString *)key account:(NSString *)account;

+ (void)setOpened:(NSString *)key;
+ (void)setOpened:(NSString *)key forAccount:(NSString *)account;

+ (BOOL)isFirstOpen:(NSString *)key;
+ (BOOL)isFirstOpen:(NSString *)key forAccount:(NSString *)account;

#pragma mark - Calculate Time Cost

+ (void)calculate:(dispatch_block_t)doSth done:(void(^)(double timeCost))done;

#pragma mark - 加密

+ (NSString *)hmacsha1WithPlainText:(NSString *)plainText secretKey:(NSString *)secretKey;

@end
