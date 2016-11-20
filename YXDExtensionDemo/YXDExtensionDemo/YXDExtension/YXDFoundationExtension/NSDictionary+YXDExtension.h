//
//  NSDictionary+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright © 2015年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (YXDExtension)

- (NSData *)JSONData;
- (NSString *)JSONString;

+ (NSDictionary *)dictionaryWithJSONString:(NSString *)JSONString;

//将自己的 key 和 value 排序后拼接成字符串
- (NSString *)sortedKeyValueString;

@end
