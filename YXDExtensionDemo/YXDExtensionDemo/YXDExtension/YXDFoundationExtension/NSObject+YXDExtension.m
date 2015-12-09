//
//  NSObject+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "NSObject+YXDExtension.h"
#import <objc/message.h>

static const void *YXDExtensionNSObjectUserDataKey = &YXDExtensionNSObjectUserDataKey;

@implementation NSObject (YXDExtension)

- (void)postNotificationName:(NSString *)notificationName userInfo:(NSDictionary *)userInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:userInfo];
}

#pragma mark - 存取部分

- (void)setUserData:(id)userData {
    objc_setAssociatedObject(self, YXDExtensionNSObjectUserDataKey, userData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)userData {
    return objc_getAssociatedObject(self, YXDExtensionNSObjectUserDataKey);
}

#pragma mark - 自动赋值部分

//根据数据创建对象数组
+ (NSMutableArray *)objectArrayWithDictionaryArray:(NSArray<NSDictionary *> *)dictionaryArray {
    if (!dictionaryArray.count) {
        return nil;
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSDictionary *dic in dictionaryArray) {
        [arr addObject:[self objectWithData:dic]];
    }
    
    return arr;
}

+ (instancetype)objectWithData:(id)data {
    return [[self new] voluationWithData:data];
}

- (instancetype)voluationWithData:(id)data {
    NSArray *propertyList = [self propertyList];
    
    if (!propertyList || !propertyList.count || !data || [data isKindOfClass:[NSNull class]]) {
        return self;
    }
    
    //属性名称直接对应返回值
    for (NSString *propertyName in propertyList) {
        [self voluationWithPropertyName:propertyName value:[data valueForKey:propertyName] arrayObjectClass:nil];
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    //属性名称对应不同的返回值
    if (![self respondsToSelector:@selector(propertyMap)]) {
        return self;
    }
    
    NSDictionary *propertyMapDictionary = [self performSelector:@selector(propertyMap)];
    if (!propertyMapDictionary || ![propertyMapDictionary isKindOfClass:[NSDictionary class]] || !propertyMapDictionary.count) {
        return self;
    }
    
#pragma clang diagnostic pop
    
    for (NSString *propertyName in propertyMapDictionary.allKeys) {
        id propertyValue = [propertyMapDictionary valueForKey:propertyName];
        if ([propertyValue isKindOfClass:[NSString class]]) {
            [self voluationWithPropertyName:propertyName value:[data valueForKey:propertyValue] arrayObjectClass:nil];
        } else if ([propertyValue isKindOfClass:[NSDictionary class]]) {
            NSString *str = [((NSDictionary *)propertyValue).allKeys firstObject];
            if (![str isKindOfClass:[NSString class]]) {
                continue;
            }
            id clazz = [propertyValue valueForKey:str];
            if ([clazz respondsToSelector:@selector(isSubclassOfClass:)]) {
                [self voluationWithPropertyName:propertyName value:[data valueForKey:str] arrayObjectClass:clazz];
            }
        }
    }
    
    return self;
}

- (void)voluationWithPropertyName:(NSString *)propertyName value:(id)value arrayObjectClass:(Class)arrayObjectClass {
    if (!value || [value isKindOfClass:[NSNull class]]) {
        return;
    }
    
    id propertyValue = nil;
    
    Class propertyClass = [self classOfPropertyNamed:propertyName];
    
    if (propertyClass == [NSString class]) {
        if ([value isKindOfClass:[NSString class]]) {
            propertyValue = value;
        }
    } else if (propertyClass == [NSNumber class]) {
        if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
            propertyValue = @([value doubleValue]);
        }
    } else if (propertyClass == [NSArray class]) {
        if ([value isKindOfClass:[NSArray class]] && arrayObjectClass) {
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:((NSArray *)value).count];
            for (id val in value) {
                [arr addObject:[arrayObjectClass objectWithData:val]];
            }
            propertyValue = arr;
        }
    } else {
        propertyValue = [propertyClass objectWithData:value];
    }
    
    [self setValue:propertyValue forKey:propertyName];
}

#pragma mark -

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [self init]) {
        NSArray *propertyList = [self propertyList];
        
        if (!propertyList || !propertyList.count) {
            return self;
        }
        
        for (NSString *valueKey in propertyList) {
            [self setValue:[coder decodeObjectForKey:valueKey] forKey:valueKey];
        }
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    NSArray *propertyList = [self propertyList];
    
    if (!propertyList || !propertyList.count) {
        return;
    }
    
    for (NSString *valueKey in propertyList) {
        [coder encodeObject:[self valueForKey:valueKey] forKey:valueKey];
    }
}

#pragma mark -

- (NSArray *)propertyList {
    //待加入缓存
    
    unsigned int count;
    
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        const char *propertyName = property_getName(properties[i]);
        
        [list addObject:[NSString stringWithUTF8String:propertyName]];
    }
    
    free(properties);
    
    if (list.count) {
        return list;
    }
    
    return nil;
}

- (NSDictionary *)propertyValues {
    NSArray *propertyList = [self propertyList];
    
    if (!propertyList || !propertyList.count) {
        return nil;
    }
    
    NSMutableDictionary *propertyValues = [NSMutableDictionary dictionaryWithCapacity:propertyList.count];
    
    for (NSString *valueKey in propertyList) {
        id value = [self valueForKey:valueKey];
        
        if (value && ![value isKindOfClass:[NSNull class]]) {
            [propertyValues setObject:value forKey:valueKey];
        }
    }
    
    if (propertyValues.count) {
        return propertyValues;
    }
    
    return nil;
}

- (NSDictionary *)allPropertyValues {
    NSArray *propertyList = [self propertyList];
    
    if (!propertyList || !propertyList.count) {
        return nil;
    }
    
    NSMutableDictionary *propertyValues = [NSMutableDictionary dictionaryWithCapacity:propertyList.count];
    
    for (NSString *valueKey in propertyList) {
        id value = [self valueForKey:valueKey];
        
        if (!value) {
            value = [NSNull null];
        }
        
        [propertyValues setObject:value forKey:valueKey];
    }
    
    return propertyValues;
}

- (NSArray *)methodList {
    unsigned int count;
    
    Method *methods = class_copyMethodList([self class], &count);
    
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        NSString *methodName = NSStringFromSelector(method_getName(methods[i]));
        [list addObject:methodName];
    }
    
    if (list.count) {
        return list;
    }
    
    return nil;
}

- (NSArray *)ivarList {
    unsigned int count;
    
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        const char *ivarName = ivar_getName(ivars[i]);
        [list addObject:[NSString stringWithUTF8String:ivarName]];
    }
    
    if (list.count) {
        return list;
    }
    
    return nil;
}

- (Class)classOfPropertyNamed:(NSString *)propertyName {
    //待加入缓存
    
    Class propertyClass = nil;
    objc_property_t property = class_getProperty([self class], [propertyName UTF8String]);
    NSString *propertyAttributes = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
    NSArray *splitPropertyAttributes = [propertyAttributes componentsSeparatedByString:@","];
    if (splitPropertyAttributes.count > 0) {
        NSString *encodeType = splitPropertyAttributes[0];
        NSArray *splitEncodeType = [encodeType componentsSeparatedByString:@"\""];
        NSString *className = splitEncodeType[1];
        propertyClass = NSClassFromString(className);
    }
    return propertyClass;
}

@end
