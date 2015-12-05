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

+ (instancetype)objectWithData:(id)data {
    return [[self new] voluationWithData:data];
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

- (NSDictionary *)propertyMap {
    //子类需要覆盖此方法
    return nil;
}

- (NSArray *)propertyList {
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

- (instancetype)voluationWithData:(id)data {
    NSArray *propertyList = [self propertyList];
    
    if (!propertyList || !propertyList.count || !data || [data isKindOfClass:[NSNull class]]) {
        return self;
    }
    
#warning 待完善
    
    //属性名称直接对应返回值
    for (NSString *propertyName in propertyList) {
        if ([self validPropertyValue:propertyName data:data]) {
            id value = [data valueForKey:propertyName];
            if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
                [self setValue:value forKey:propertyName];
            }
        }
    }
    
    //属性名称对应不同的返回值
    NSDictionary *propertyMapDictionary = [self propertyMap];
    if (propertyMapDictionary && propertyMapDictionary.count) {
        for (NSString *propertyName in propertyMapDictionary) {
            if ([self validPropertyValue:[propertyMapDictionary valueForKey:propertyName] data:data]) {
                [self voluationWithPropertyMap:[self propertyMap] data:data propertyName:propertyName];
            }
        }
    }
    
    return self;
}

//判断data的property是否有效
- (BOOL)validPropertyValue:(id)propertyValue data:(id)data {
    
    NSString *propertyName = nil;
    
    if ([propertyValue isKindOfClass:[NSString class]]) {
        propertyName = propertyValue;
    } else if ([propertyValue isKindOfClass:[NSDictionary class]]) {
        propertyName = ((NSDictionary *)propertyValue).allKeys.firstObject;
    } else {
        return NO;
    }
    
    if (!propertyName || ![propertyName isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if ([data isKindOfClass:[NSDictionary class]]) {
        return ([data valueForKey:propertyName] && ![data isKindOfClass:[NSNull class]]);
    } else {
        return (![data isKindOfClass:[NSNull class]] && [data respondsToSelector:NSSelectorFromString(propertyName)] && ![[data valueForKey:propertyName] isKindOfClass:[NSNull class]]);
    }
    return NO;
}

//根据返回值的类型 自动判断是数组还是对象
- (void)voluationWithPropertyMap:(NSDictionary *)propertyMap data:(id)data propertyName:(NSString *)propertyName {
    if (!data || !propertyName || !propertyMap.count || [data isKindOfClass:[NSNull class]] || ![propertyName isKindOfClass:[NSString class]]) {
        return;
    }
    
    NSString *returnPropertyName = nil;
    
    id mappingValue = [propertyMap valueForKey:propertyName];
    
    if ([mappingValue isKindOfClass:[NSString class]]) {
        returnPropertyName = mappingValue;
    } else if ([mappingValue isKindOfClass:[NSDictionary class]]) {
        returnPropertyName = ((NSDictionary *)mappingValue).allKeys.firstObject;
    } else {
        return;
    }
    
    id dataValue = [data valueForKey:returnPropertyName];
    
    if (!dataValue) {
        return;
    }
    
    if ([dataValue isKindOfClass:[NSString class]]) {
        [self setValue:dataValue forKey:propertyName];
    } else if ([dataValue isKindOfClass:[NSDictionary class]]) {
        Class objClass = [propertyMap valueForKey:propertyName];
        [self setValue:[objClass objectWithData:dataValue] forKey:propertyName];
    } else if ([dataValue isKindOfClass:[NSArray class]]) {
        Class objClass = [propertyMap valueForKey:propertyName];
        NSMutableArray *arr = [NSMutableArray array];
        for (id subData in dataValue) {
            [arr addObject:[objClass objectWithData:subData]];
        }
        [self setValue:arr forKey:propertyName];
    } else {
        [self setValue:dataValue forKey:propertyName];
    }
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

@end
