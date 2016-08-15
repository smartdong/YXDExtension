//
//  NSString+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;
@class UIColor;

@interface NSString (YXDExtension)

- (BOOL)isEmail;
- (BOOL)isPhone;

- (NSDate *)dateFromSeconds;
- (NSDate *)dateFromMilliSeconds;

- (NSString *)RMBString;
+ (NSString *)RMBStringWithFloat:(float)price;

- (NSString *)priceString;
+ (NSString *)priceStringWithFloat:(float)price;

- (NSString *)stringToThirdDecimalPlace;

- (NSAttributedString *)attributedWithRMBStringFontSize:(NSUInteger)RMBStringFontSize
                                    priceStringFontSize:(NSUInteger)priceStringFontSize;

- (NSAttributedString *)attributedWithRMBStringFontSize:(NSUInteger)RMBStringFontSize
                                         RMBStringColor:(UIColor *)RMBStringColor
                                    priceStringFontSize:(NSUInteger)priceStringFontSize
                                       priceStringColor:(UIColor *)priceStringColor;

- (NSURL *)URL;
- (NSURLRequest *)URLRequest;

- (NSNumber *)numberValue;

- (NSString *)URLDecode;
- (NSString *)URLEncode;

- (NSString *)toBase64String;
- (NSString *)base64StringToOriginString;

- (UIImage *)QRCodeImage;

- (id)objectFromJSONString;

- (NSString *)md5;
- (NSString *)hmacsha1WithSecretKey:(NSString *)secretKey;

+ (NSString *)randomStringWithLength:(int)length;

- (BOOL)isChinese;
- (NSString *)firstLetter;

@end
