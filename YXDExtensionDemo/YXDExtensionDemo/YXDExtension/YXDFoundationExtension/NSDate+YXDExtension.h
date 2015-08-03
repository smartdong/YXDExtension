//
//  NSDate+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (YXDExtension)

- (NSString *)dateString;
- (NSString *)dateTimeString;

- (NSString *)stringWithDateFormat:(NSString *)format;

+ (NSDate *)dateFromDateString:(NSString *)dateString;
+ (NSDate *)dateFromDatetimeString:(NSString *)dateTimeString;

/**
 *  星座名称
 */
- (NSString *)constellation;

@end
