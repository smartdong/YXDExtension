//
//  NSArray+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright © 2015年 YangXudong. All rights reserved.
//

#import "NSArray+YXDExtension.h"

@implementation NSArray (YXDExtension)

- (NSData *)jsonData {
    return [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
}

- (NSString *)jsonString {
    return [[NSString alloc] initWithData:[self jsonData] encoding:NSUTF8StringEncoding];
}

@end
