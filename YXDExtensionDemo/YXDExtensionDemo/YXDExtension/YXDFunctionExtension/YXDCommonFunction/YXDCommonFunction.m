//
//  YXDCommonFunction.m
//  Parking_iOS_User
//
//  Created by YangXudong on 15/10/17.
//  Copyright © 2015年 YangXudong. All rights reserved.
//

#import "YXDCommonFunction.h"

@implementation YXDCommonFunction

+(NSMutableArray *)objectArrayWithDictionaryArray:(NSArray *)dictionaryArray objectClass:(Class)objectClass {
    if (!dictionaryArray.count || !objectClass) {
        return nil;
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSDictionary *dic in dictionaryArray) {
        [arr addObject:[objectClass objectWithData:dic]];
    }
    
    return arr;
}

#pragma mark -
#pragma mark local data method

+ (void) setLocalData:(id)data key:(NSString *)key{
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

+ (id) getLocalData:(NSString *)key{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([ud objectForKey:key] != NULL) {
        NSData *userData = [ud objectForKey:key];
        return [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    }
    else {
        return nil;
    }
}

+ (void) setLocalValue:(id)value key:(NSString *)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (value == nil) {
        [ud removeObjectForKey:key];
    }
    else {
        [ud setObject:value forKey:key];
    }
    [ud synchronize];
}

+ (void) setLocalInt:(int)value key:(NSString *)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:value forKey:key];
    [ud synchronize];
}

+ (void) setLocalBool:(bool)value key:(NSString *)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:value forKey:key];
    [ud synchronize];
}

+ (id) getLocalValue:(NSString *)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:key];
}

+ (int) getLocalInt:(NSString *)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return (int)[ud integerForKey:key];
}

+ (bool) getLocalBool:(NSString *)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud boolForKey:key];
}

+ (id) getLocalString:(NSString *)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud stringForKey:key];
}

#pragma mark - 读取是否第一次打开 / 存储已经打开

+ (BOOL)isFirstOpen:(NSString *)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return ![ud boolForKey:key];
}

+ (void)isOpened:(NSString *)key {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:YES forKey:key];
    [ud synchronize];
}

@end
