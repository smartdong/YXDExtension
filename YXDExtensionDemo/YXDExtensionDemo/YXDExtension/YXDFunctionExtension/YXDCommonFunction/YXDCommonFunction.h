//
//  YXDCommonFunction.h
//  Parking_iOS_User
//
//  Created by YangXudong on 15/10/17.
//  Copyright © 2015年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXDCommonFunction : NSObject

+ (NSMutableArray *)objectArrayWithDictionaryArray:(NSArray *)dictionaryArray objectClass:(Class)objectClass;

#pragma mark -
#pragma mark local data method

+ (void) setLocalData:(id)data key:(NSString *)key;
+ (id) getLocalData:(NSString *)key;
+ (void) setLocalValue:(id)value key:(NSString *)key;
+ (void) setLocalInt:(int)value key:(NSString *)key;
+ (void) setLocalBool:(bool)value key:(NSString *)key;
+ (id) getLocalValue:(NSString *)key;
+ (int) getLocalInt:(NSString *)key;
+ (bool) getLocalBool:(NSString *)key;
+ (id) getLocalString:(NSString *)key;

#pragma mark - 读取是否第一次打开 / 存储已经打开

/**
 *  根据key值判断是不是第一次打开
 */
+ (BOOL)isFirstOpen:(NSString *)key;

/**
 *  根据key值设置成已经打开
 */
+ (void)setOpened:(NSString *)key;

#pragma mark - 加密

/**
 *  将文本加密
 *
 *  @param plainText 带加密文本
 *  @param secretKey 加密秘钥
 *
 *  @return 加密后的文本
 */
+ (NSString *)hmacsha1WithPlainText:(NSString *)plainText secretKey:(NSString *)secretKey;

@end
