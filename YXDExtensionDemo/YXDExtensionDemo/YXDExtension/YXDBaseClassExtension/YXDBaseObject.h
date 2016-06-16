//
//  YXDBaseObject.h
//  YXDExtensionDemo
//
//  Copyright © 2015年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXDBaseObject : NSObject

//数据库存储主键
@property (nonatomic, strong) NSNumber *primaryID;

//属性名称和接口返回值名称的对应关系  @{@"属性名称" : @"返回值名称"}
//如果对象属性包含数组  则对应关系为 @{@"属性名称" : @{@"返回值名称" : [xxx class]}}
- (NSDictionary *)propertyMap;

@end
