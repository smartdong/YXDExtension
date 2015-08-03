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

- (NSString *)rmbString;
+ (NSString *)rmbStringWithFloat:(float)price;

- (NSString *)priceString;
+ (NSString *)priceStringWithFloat:(float)price;

@end
