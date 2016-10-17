//
//  NSNumber+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (YXDExtension)

- (NSDate *)dateFromSeconds;
- (NSDate *)dateFromMilliSeconds;

- (NSString *)RMBString;
+ (NSString *)RMBStringWithFloat:(float)price;

- (NSString *)priceString;
+ (NSString *)priceStringWithFloat:(float)price;

- (NSNumber *)numberValue;

@end
