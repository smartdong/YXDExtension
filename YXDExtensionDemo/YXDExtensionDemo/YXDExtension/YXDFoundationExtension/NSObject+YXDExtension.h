//
//  NSObject+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (YXDExtension)

@property (nonatomic, strong) id userData;

#pragma mark - 新建对象 & 对象赋值

//根据数据创建对象数组
+ (NSMutableArray *)objectArrayWithDictionaryArray:(NSArray<NSDictionary *> *)dictionaryArray;

//根据数据源对象创建新对象
+ (instancetype)objectWithData:(id)data;

//对当前对象进行赋值
- (instancetype)voluationWithData:(id)data;

#pragma mark - 各种列表

//获取当前对象的属性列表
- (NSArray *)propertyList;

//获取当前对象的非空属性列表以及属性值
- (NSDictionary *)propertyValues;

//获取当前对象的非空属性列表以及属性值 其中如果在对象的 propertyMap 中某属性对应不同的 key 则使用 map 中的 key 代替此属性
- (NSDictionary *)propertyValuesUseMapPropertyKey;

//获取当前对象的所有属性列表以及属性值 (如果属性值不存在则为NSNull对象)
- (NSDictionary *)allPropertyValues;

//获取当前对象的所有属性列表以及属性值 (如果属性值不存在则为NSNull对象) 其中如果在对象的 propertyMap 中某属性对应不同的 key 则使用 map 中的 key 代替此属性
- (NSDictionary *)allPropertyValuesUseMapPropertyKey;

//获取当前对象的方法列表
- (NSArray *)methodList;

//获取当前对象的实例变量列表
- (NSArray *)ivarList;

#pragma mark - JSON 互转

//将对象转化成 dictionary 然后再转化成 json
- (NSString *)jsonString;

//通过 jsonstring 转化成对象
+ (instancetype)objectWithJSONString:(NSString *)jsonString;

//将对象数组转化为 jsonstring
+ (NSString *)jsonStringFromObjectArray:(NSArray *)objectArray;

//将 jsonstring 转化为对象数组
+ (NSArray *)objectArrayFromJSONString:(NSString *)jsonString;

#pragma mark - Description

//description 方法 并打印出所有的属性值
- (NSString *)descriptionWithPropertyValues;

#pragma mark - Others

- (void)postNotificationName:(NSString *)notificationName userInfo:(NSDictionary *)userInfo;

@end
