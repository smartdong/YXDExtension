//
//  NSArray+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright © 2015年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (YXDExtension)

- (NSUInteger)length;

- (NSData *)JSONData;
- (NSString *)JSONString;

+ (NSArray *)arrayWithJSONString:(NSString *)JSONString;

@end
