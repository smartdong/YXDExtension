//
//  NSObject+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (YXDExtension)

@property (nonatomic, strong) id userData;

- (void)postNotificationName:(NSString *)notificationName userInfo:(NSDictionary *)userInfo;

//根据数据创建对象数组
+ (NSMutableArray *)objectArrayWithDictionaryArray:(NSArray<NSDictionary *> *)dictionaryArray;

//根据数据源对象创建新对象
+ (instancetype)objectWithData:(id)data;

//对当前对象进行赋值
- (instancetype)voluationWithData:(id)data;

//获取当前对象的属性列表
- (NSArray *)propertyList;

//获取当前对象的非空属性列表以及属性值
- (NSDictionary *)propertyValues;

//获取当前对象的所有属性列表以及属性值 (如果属性值不存在则为NSNull对象)
- (NSDictionary *)allPropertyValues;

//获取当前对象的方法列表
- (NSArray *)methodList;

//获取当前对象的实例变量列表
- (NSArray *)ivarList;

@end
