//
//  NSNull+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNull (YXDExtension)

- (NSNumber *)numberValue;

- (NSString *)stringValue;

- (NSUInteger)length;

- (NSUInteger)count;

@end
