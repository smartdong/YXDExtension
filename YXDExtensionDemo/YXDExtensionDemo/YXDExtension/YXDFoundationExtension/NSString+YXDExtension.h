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

- (id)objectFromJSONString;

+ (BOOL)isEmpty:(NSString *)string;
- (BOOL)isEmail;
- (BOOL)isPhone;
- (BOOL)isChinese;

- (NSNumber *)numberValue;
- (NSString *)stringValue;
- (NSData *)dataValue;

- (NSUInteger)count;

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
- (NSURL *)encodedURL;

- (NSURLRequest *)URLRequest;
- (NSURLRequest *)encodedURLRequest;

- (NSString *)URLDecode;
- (NSString *)URLEncode;

- (NSString *)toBase64String;
- (NSString *)base64StringToOriginString;

- (UIImage *)QRCodeImage;

- (NSString *)md5;
- (NSString *)hmacsha1WithSecretKey:(NSString *)secretKey;

+ (NSString *)randomStringWithLength:(int)length;

- (NSString *)filterHTMLLabels;

- (NSString *)firstLetter;

@end
