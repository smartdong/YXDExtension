//
//  NSDateFormatter+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (YXDExtension)

+ (NSDateFormatter *)defaultDateFormatter;
+ (NSDateFormatter *)defaultDatetimeFormatter;
+ (NSDateFormatter *)dateFormatterWithFormat:(NSString *)dateFormat;

@end
