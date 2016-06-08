//
//  NSString+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YXDExtension)

- (BOOL)isEmail;
- (BOOL)isPhone;

- (NSDate *)dateFromSeconds;
- (NSDate *)dateFromMilliSeconds;

- (NSString *)rmbString;
+ (NSString *)rmbStringWithFloat:(float)price;

- (NSString *)priceString;
+ (NSString *)priceStringWithFloat:(float)price;

- (NSURL *)URL;
- (NSURLRequest *)URLRequest;

- (NSNumber *)numberValue;

- (NSString *)URLDecode;
- (NSString *)URLEncode;

- (NSString *)toBase64String;
- (NSString *)base64StringToOriginString;

- (id)objectFromJSONString;

- (NSString *)md5;
- (NSString *)hmacsha1WithSecretKey:(NSString *)secretKey;

+ (NSString *)randomStringWithLength:(int)length;

- (BOOL)isChinese;
- (NSString *)firstLetter;

@end
