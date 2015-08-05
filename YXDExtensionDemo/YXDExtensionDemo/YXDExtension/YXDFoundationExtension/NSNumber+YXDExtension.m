//
//  NSNumber+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "NSNumber+YXDExtension.h"

@implementation NSNumber (YXDExtension)

- (NSDate *)dateFromSeconds {
    return [NSDate dateWithTimeIntervalSince1970:self.doubleValue];
}

- (NSDate *)dateFromMilliSeconds {
    return [NSDate dateWithTimeIntervalSince1970:self.doubleValue / 1000];
}

- (NSString *)rmbString {
    return [NSString stringWithFormat:@"￥%@", [self priceString]];
}

+ (NSString *)rmbStringWithFloat:(float)price {
    return [NSString stringWithFormat:@"￥%@", [self priceStringWithFloat:price]];
}

- (NSString *)priceString {
    NSString *result = [NSString stringWithFormat:@"%.2f", self.floatValue];
    
    //如果没有小数 不显示.00
    if ([result hasSuffix:@".00"]) {
        result = [result stringByReplacingOccurrencesOfString:@".00" withString:@""];
    } else if ([result hasSuffix:@"0"]) {
        result = [result stringByReplacingCharactersInRange:NSMakeRange(result.length - 1, 1) withString:@""];
    }
    
    return result;
}

+ (NSString *)priceStringWithFloat:(float)price {
    return [@(price) priceString];
}

@end
