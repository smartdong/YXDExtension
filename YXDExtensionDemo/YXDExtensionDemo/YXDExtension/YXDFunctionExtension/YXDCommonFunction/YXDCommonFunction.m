//
//  YXDCommonFunction.m
//  YXDExtensionDemo
//
//  Created by YangXudong on 15/10/17.
//  Copyright © 2015年 YangXudong. All rights reserved.
//

#import "YXDCommonFunction.h"
#import "NSString+YXDExtension.h"

#define YXDCommonFunctionUserDefaultsKey(key, account) (account?[NSString stringWithFormat:@"%@_%@",key,account]:key)

@implementation YXDCommonFunction

#pragma mark - Print Time Cost

+ (void)printTimeCost:(dispatch_block_t)doSth {
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    if (doSth) {
        doSth();
    }
    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    NSLog(@"Time Cost: %0.3f", end - start);
}

#pragma mark - User Defaults

+ (void)setUserDefaultsValue:(id)value forKey:(NSString *)key {
    [self setUserDefaultsValue:value forKey:key account:nil];
}

+ (void)setUserDefaultsValue:(id)value forKey:(NSString *)key account:(NSString *)account {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (value == nil) {
        [ud removeObjectForKey:YXDCommonFunctionUserDefaultsKey(key, account)];
    }
    else {
        [ud setObject:value forKey:YXDCommonFunctionUserDefaultsKey(key, account)];
    }
    [ud synchronize];
}

+ (id)userDefaultsValueForKey:(NSString *)key {
    return [self userDefaultsValueForKey:key account:nil];
}

+ (id)userDefaultsValueForKey:(NSString *)key account:(NSString *)account {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:YXDCommonFunctionUserDefaultsKey(key, account)];
}

+ (void)setOpened:(NSString *)key {
    [self setOpened:key forAccount:nil];
}

+ (void)setOpened:(NSString *)key forAccount:(NSString *)account {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:YES forKey:YXDCommonFunctionUserDefaultsKey(key, account)];
    [ud synchronize];
}

+ (BOOL)isFirstOpen:(NSString *)key {
    return [self isFirstOpen:key forAccount:nil];
}

+ (BOOL)isFirstOpen:(NSString *)key forAccount:(NSString *)account {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return ![ud boolForKey:YXDCommonFunctionUserDefaultsKey(key, account)];
}

#pragma mark - 加密

+ (NSString *)hmacsha1WithPlainText:(NSString *)plainText secretKey:(NSString *)secretKey {
    return [plainText hmacsha1WithSecretKey:secretKey];
}

@end
