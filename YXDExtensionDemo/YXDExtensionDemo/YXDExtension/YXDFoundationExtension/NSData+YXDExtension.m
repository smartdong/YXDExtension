//
//  NSData+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright © 2015年 YangXudong. All rights reserved.
//

#import "NSData+YXDExtension.h"

@implementation NSData (YXDExtension)

- (id)objectFromJSONData {
    return [NSJSONSerialization JSONObjectWithData:self options:0 error:nil];
}

@end
