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

- (NSURL *)urlValue;
- (NSURLRequest *)urlRequestValue;
- (NSNumber *)numberValue;

- (NSString *)md5;

+ (NSString *)randomStringWithLength:(int)length;

- (NSString *)firstLetter;

- (NSString *)toBase64String;
- (NSString *)base64StringToOriginString;

@end
