//
//  NSArray+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright © 2015年 YangXudong. All rights reserved.
//

#import "NSArray+YXDExtension.h"
#import "NSString+YXDExtension.h"

@implementation NSArray (YXDExtension)

- (NSUInteger)length {
    return self.count;
}

- (NSData *)JSONData {
    return [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
}

- (NSString *)JSONString {
    return [[NSString alloc] initWithData:[self JSONData] encoding:NSUTF8StringEncoding];
}

+ (NSArray *)arrayWithJSONString:(NSString *)JSONString {
    return [JSONString objectFromJSONString];
}

@end
