//
//  NSNumber+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "NSNumber+YXDExtension.h"
#import "NSString+YXDExtension.h"

@implementation NSNumber (YXDExtension)

- (NSDate *)dateFromSeconds {
    return [NSDate dateWithTimeIntervalSince1970:self.doubleValue];
}

- (NSDate *)dateFromMilliSeconds {
    return [NSDate dateWithTimeIntervalSince1970:self.doubleValue / 1000];
}

- (NSString *)rmbString {
    return self.stringValue.rmbString;
}

+ (NSString *)rmbStringWithFloat:(float)price {
    return @(price).rmbString;
}

- (NSString *)priceString {
    return self.stringValue.priceString;
}

+ (NSString *)priceStringWithFloat:(float)price {
    return @(price).priceString;
}

@end
