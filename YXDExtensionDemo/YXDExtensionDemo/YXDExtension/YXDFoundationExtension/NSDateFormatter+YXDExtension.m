//
//  NSDateFormatter+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "NSDateFormatter+YXDExtension.h"

@implementation NSDateFormatter (YXDExtension)

+ (NSDateFormatter *)defaultDateFormatter {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return formatter;
}

+ (NSDateFormatter *)defaultDatetimeFormatter {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return formatter;
}

@end
