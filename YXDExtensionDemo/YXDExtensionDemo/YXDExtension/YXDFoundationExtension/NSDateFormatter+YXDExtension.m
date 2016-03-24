//
//  NSDateFormatter+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "NSDateFormatter+YXDExtension.h"

@implementation NSDateFormatter (YXDExtension)

+ (NSDateFormatter *)defaultDateFormatter {
    return [self dateFormatterWithFormat:@"yyyy-MM-dd"];
}

+ (NSDateFormatter *)defaultDatetimeFormatter {
    return [self dateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSDateFormatter *)defaultDatetimeWithoutSecondsFormatter {
    return [self dateFormatterWithFormat:@"yyyy-MM-dd HH:mm"];
}

+ (NSDateFormatter *)dateFormatterWithFormat:(NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = dateFormat;
    return dateFormatter;
}

@end
