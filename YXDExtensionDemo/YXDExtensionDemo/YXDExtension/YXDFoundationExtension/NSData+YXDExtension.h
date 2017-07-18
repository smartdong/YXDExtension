//
//  NSData+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright © 2015年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (YXDExtension)

- (NSString *)stringValue;

- (id)objectFromJSONData;
+ (id)objectFromJSONDataForResource:(nullable NSString *)name ofType:(nullable NSString *)ext;

- (NSString *)hexString;

@end
