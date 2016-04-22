//
//  YXDCommonFunction.m
//  Parking_iOS_User
//
//  Created by YangXudong on 15/10/17.
//  Copyright © 2015年 YangXudong. All rights reserved.
//

#import "YXDCommonFunction.h"
#import "NSString+YXDExtension.h"

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

#pragma mark - Local data method

+ (void)setLocalData:(id)data key:(NSString *)key{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (data == nil) {
        [ud removeObjectForKey:key];
    }
    else {
        NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:data];
        [ud setObject:userData forKey:key];
    }
    [ud synchronize];
}

+ (id)getLocalData:(NSString *)key{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([ud objectForKey:key] != NULL) {
        NSData *userData = [ud objectForKey:key];
        return [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    }
    else {
        return nil;
    }
}

+ (void)setLocalValue:(id)value key:(NSString *)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (value == nil) {
        [ud removeObjectForKey:key];
    }
    else {
        [ud setObject:value forKey:key];
    }
    [ud synchronize];
}

+ (void)setLocalInt:(int)value key:(NSString *)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:value forKey:key];
    [ud synchronize];
}

+ (void)setLocalBool:(bool)value key:(NSString *)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:value forKey:key];
    [ud synchronize];
}

+ (id)getLocalValue:(NSString *)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:key];
}

+ (int)getLocalInt:(NSString *)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return (int)[ud integerForKey:key];
}

+ (bool)getLocalBool:(NSString *)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud boolForKey:key];
}

+ (id)getLocalString:(NSString *)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud stringForKey:key];
}

#pragma mark - 读取是否第一次打开 / 存储已经打开

+ (BOOL)isFirstOpen:(NSString *)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return ![ud boolForKey:key];
}

+ (void)setOpened:(NSString *)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:YES forKey:key];
    [ud synchronize];
}

#pragma mark - 加密

/**
 *  将文本加密
 *
 *  @param plainText 带加密文本
 *  @param secretKey 加密秘钥
 *
 *  @return 加密后的文本
 */
+ (NSString *)hmacsha1WithPlainText:(NSString *)plainText secretKey:(NSString *)secretKey {
    return [plainText hmacsha1WithSecretKey:secretKey];
}

@end
