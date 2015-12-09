//
//  NSDictionary+YXDExtension.h
//  YXDExtensionDemo
//
//  Created by zjdd on 15/12/5.
//  Copyright © 2015年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (YXDExtension)

- (NSData *)jsonData;
- (NSString *)jsonString;

//将自己的 key 和 value 排序后拼接成字符串
- (NSString *)sortedKeyValueString;

@end
