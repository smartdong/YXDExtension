//
//  NSObject+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "NSObject+YXDExtension.h"
#import <objc/message.h>
#import "NSString+YXDExtension.h"

//https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
//https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html

typedef NS_ENUM(NSInteger, YXDObjectPropertyType) {
    YXDObjectPropertyTypeUnknown,
    YXDObjectPropertyTypeString,
    YXDObjectPropertyTypeNumber,
    YXDObjectPropertyTypeArray,
    YXDObjectPropertyTypeDictionary,
    YXDObjectPropertyTypeClass,
    YXDObjectPropertyTypeBlock,
    YXDObjectPropertyTypeObject,
    YXDObjectPropertyTypeSEL,
    YXDObjectPropertyTypeInteger,
    YXDObjectPropertyTypeFloat,
    YXDObjectPropertyTypeBool,
};

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

#warning 目前效率还是太差,优化方案考虑如下: \
1.缓存 \
2.一些对象可以声明成 __unsafe_unretained \
3.使用高效的数组遍历方法 \
4.优化遍历方案，减少遍历次数 \
5.使用内联函数 \

#warning 4.此处需优化 考虑方式：快速枚举
- (instancetype)voluationWithData:(id)data {
    
    NSArray *propertyList = [self propertyList];
    
    if (!propertyList || !propertyList.count || !data || [data isKindOfClass:[NSNull class]]) {
        return self;
    }
    
    //属性名称直接对应返回值
    for (NSString *propertyName in propertyList) {
        [self voluationWithPropertyName:propertyName value:[data valueForKey:propertyName] arrayObjectClass:nil];
    }
    

    //属性名称对应不同的返回值
    NSDictionary *propertyMapDictionary = [self getPropertyMapDictionary];
    
    if (!propertyMapDictionary) {
        return self;
    }
    
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
    } else if ((propertyClass == [NSArray class]) || (propertyClass == [NSMutableArray class])) {
        
        NSDictionary *propertyMapDictionary = [self getPropertyMapDictionary];
        
        if (!arrayObjectClass && propertyMapDictionary) {
            NSDictionary *propertyDic = [propertyMapDictionary valueForKey:propertyName];
            if (propertyDic && [propertyDic isKindOfClass:[NSDictionary class]] && propertyDic.count) {
                id clazz = propertyDic.allValues.firstObject;
                if ([clazz respondsToSelector:@selector(isSubclassOfClass:)]) {
                    arrayObjectClass = clazz;
                }
            }
        }
        
        if (arrayObjectClass && [value isKindOfClass:[NSArray class]]) {
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:((NSArray *)value).count];
            for (id val in value) {
                if ([val isKindOfClass:[NSNull class]]) {
                    continue;
                }
                
                if ([arrayObjectClass isSubclassOfClass:[NSString class]] && [val isKindOfClass:[NSString class]]) {
                    [arr addObject:val];
                } else if ([arrayObjectClass isSubclassOfClass:[NSNumber class]] && ([val isKindOfClass:[NSString class]] || [val isKindOfClass:[NSNumber class]])) {
                    [arr addObject:@([val doubleValue])];
                } else if ([arrayObjectClass isSubclassOfClass:[NSDictionary class]] && [val isKindOfClass:[NSDictionary class]]) {
                    if ([arrayObjectClass isSubclassOfClass:[NSMutableDictionary class]] && ![val isKindOfClass:[NSMutableDictionary class]]) {
                        [arr addObject:[NSMutableDictionary dictionaryWithDictionary:val]];
                    } else {
                        [arr addObject:val];
                    }
                } else if ([arrayObjectClass isSubclassOfClass:[NSArray class]]) {
                    //这个就不支持了 数组里面套数组有病啊
                } else {
                    [arr addObject:[arrayObjectClass objectWithData:val]];
                }
            }
            
            if (arr.count) {
                propertyValue = arr;
            }
        }
    } else if (propertyClass == [NSDictionary class]) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            propertyValue = value;
        }
    } else if (propertyClass == [NSMutableDictionary class]) {
        if ([value isKindOfClass:[NSMutableDictionary class]]) {
            propertyValue = value;
        } else if ([value isKindOfClass:[NSDictionary class]]) {
            propertyValue = [NSMutableDictionary dictionaryWithDictionary:value];
        }
    } else if (propertyClass) {
//        propertyValue = [propertyClass objectWithData:value];
    }
    
//    if (propertyClass && [propertyValue isKindOfClass:propertyClass]) {
//        [self setValue:propertyValue forKey:propertyName];
//    }
}

#pragma mark -

- (instancetype)initWithCoder:(NSCoder *)coder {
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
#warning 2.此处需优化 考虑方式：缓存、过滤不需要的系统属性
    
    if ([self class] == [NSObject class]) {
        return nil;
    }
    
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
    return [self propertyValuesWithNeedNullValue:NO useMapPropertyKey:NO];
}

- (NSDictionary *)propertyValuesUseMapPropertyKey {
    return [self propertyValuesWithNeedNullValue:NO useMapPropertyKey:YES];
}

- (NSDictionary *)allPropertyValues {
    return [self propertyValuesWithNeedNullValue:YES useMapPropertyKey:NO];
}

- (NSDictionary *)allPropertyValuesUseMapPropertyKey {
    return [self propertyValuesWithNeedNullValue:YES useMapPropertyKey:YES];
}

#warning 3.此处需优化 考虑方式：快速枚举
- (NSDictionary *)propertyValuesWithNeedNullValue:(BOOL)needNullValue useMapPropertyKey:(BOOL)useMapPropertyKey {
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
        
        if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSNull class]]) {
            if (needNullValue || ![value isKindOfClass:[NSNull class]]) {
                [propertyValues setObject:value forKey:valueKey];
            }
        } else if ([value isKindOfClass:[NSArray class]]) {
            NSMutableArray *arr = [NSMutableArray array];
            for (id obj in value) {
                if ([obj isKindOfClass:[NSNull class]]) {
                    if (needNullValue) {
                        [arr addObject:[NSNull null]];
                    }
                    continue;
                }
                
                if ([obj isKindOfClass:[NSString class]]) {
                    [arr addObject:obj];
                } else if ([obj isKindOfClass:[NSNumber class]]) {
                    [arr addObject:obj];
                } else if ([obj isKindOfClass:[NSDictionary class]]) {
                    [arr addObject:obj];
                } else if ([obj isKindOfClass:[NSArray class]]) {
                    //不支持 理由同上
                } else {
                    NSDictionary *pvs = nil;
                    
                    if (needNullValue && useMapPropertyKey) {
                        pvs = [obj allPropertyValuesUseMapPropertyKey];
                    } else if (needNullValue) {
                        pvs = [obj allPropertyValues];
                    } else if (useMapPropertyKey) {
                        pvs = [obj propertyValuesUseMapPropertyKey];
                    } else {
                        pvs = [obj propertyValues];
                    }
                    
                    if (pvs.count) {
                        [arr addObject:pvs];
                    } else if (needNullValue) {
                        [arr addObject:[NSDictionary dictionary]];
                    }
                }
            }
            if (needNullValue || arr.count) {
                [propertyValues setObject:arr forKey:valueKey];
            }
        } else if ([value isKindOfClass:[NSDictionary class]]) {
            [propertyValues setObject:value forKey:valueKey];
        } else {
            NSDictionary *pvs = nil;
            
            if (needNullValue && useMapPropertyKey) {
                pvs = [value allPropertyValuesUseMapPropertyKey];
            } else if (needNullValue) {
                pvs = [value allPropertyValues];
            } else if (useMapPropertyKey) {
                pvs = [value propertyValuesUseMapPropertyKey];
            } else {
                pvs = [value propertyValues];
            }
            
            if (pvs.count) {
                [propertyValues setObject:pvs forKey:valueKey];
            } else if (needNullValue) {
                [propertyValues setObject:[NSNull null] forKey:valueKey];
            }
        }
    }
    
    NSDictionary *propertyMapDictionary = [self getPropertyMapDictionary];
    
    if (useMapPropertyKey && propertyMapDictionary) {
        for (NSString *key in propertyMapDictionary.allKeys) {
            if (![key isKindOfClass:[NSString class]] || !key.length) {
                continue;
            }
            
            NSString *mapPropertyKey = nil;
            
            id value = [propertyMapDictionary valueForKey:key];
            
            if ([value isKindOfClass:[NSString class]]) {
                mapPropertyKey = value;
            } else if ([value isKindOfClass:[NSDictionary class]]) {
                NSString *firstKey = ((NSDictionary *)value).allKeys.firstObject;
                if ([firstKey isKindOfClass:[NSString class]]) {
                    mapPropertyKey = firstKey;
                }
            }
            
            if (!mapPropertyKey.length) {
                continue;
            }
            
            id propertyValue = [propertyValues objectForKey:key];
            
            if (propertyValue) {
                [propertyValues setObject:propertyValue forKey:mapPropertyKey];
                [propertyValues removeObjectForKey:key];
            }
        }
    }
    
    if (propertyValues.count || needNullValue) {
        return propertyValues;
    }
    
    return nil;
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


- (NSString *)jsonString {
    return self.propertyValuesUseMapPropertyKey.jsonString;
}

+ (instancetype)objectWithJSONString:(NSString *)jsonString {
    return [self objectWithData:[jsonString objectFromJSONString]];
}

+ (NSString *)jsonStringFromObjectArray:(NSArray *)objectArray {
    NSMutableArray *arr = [NSMutableArray array];
    for (id obj in objectArray) {
        NSDictionary *pvs = [obj propertyValuesUseMapPropertyKey];
        if (pvs.count) {
            [arr addObject:pvs];
        }
    }
    if (arr.count) {
        return arr.jsonString;
    }
    return nil;
}

+ (NSArray *)objectArrayFromJSONString:(NSString *)jsonString {
    NSArray *arr = [jsonString objectFromJSONString];
    if (!arr.count) {
        return nil;
    }
    NSMutableArray *objectArray = [NSMutableArray array];
    for (NSDictionary *pvs in arr) {
        if (pvs.count) {
            [objectArray addObject:[self objectWithData:pvs]];
        }
    }
    if (objectArray.count) {
        return objectArray;
    }
    return nil;
}

- (NSString *)descriptionWithPropertyValues {
    return [NSString stringWithFormat:@"%@ \n%@",[self description],[self allPropertyValues]];
}

#pragma mark -

//防止意外崩溃 但是这样做就无法在其他类里面再对这种情况进行处理 考虑到极少需要处理这种情况 所以我觉得无所谓 :)
- (id)valueForUndefinedKey:(NSString *)key {
    NSLog(@"%@ -> valueForUndefinedKey : %@",self,key);
    return nil;
}

// 获取 propertyMap
- (NSDictionary *)getPropertyMapDictionary {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    if ([self respondsToSelector:@selector(propertyMap)]) {
        NSDictionary *map = [self performSelector:@selector(propertyMap)];
        if (map && [map isKindOfClass:[NSDictionary class]] && map.count) {
            return map;
        }
    }
    
#pragma clang diagnostic pop
    
    return nil;
}

#warning 待替换为 YXDObjectPropertyType
- (Class)classOfPropertyNamed:(NSString *)propertyName {
#warning 1.此处需优化 考虑方式：缓存
    
    Class propertyClass = nil;
    objc_property_t property = class_getProperty([self class], [propertyName UTF8String]);
    NSString *propertyAttributes = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
    
    NSLog(@"propertyName : %@ , attributes : %@",propertyName,propertyAttributes);
    
    NSArray *splitPropertyAttributes = [propertyAttributes componentsSeparatedByString:@","];
    if (splitPropertyAttributes.count > 0) {
        NSString *encodeType = splitPropertyAttributes[0];
        NSArray *splitEncodeType = [encodeType componentsSeparatedByString:@"\""];
        if (splitEncodeType.count < 2) {
            return nil;
        }
        NSString *className = splitEncodeType[1];
        propertyClass = NSClassFromString(className);
    }
    return propertyClass;
}

@end
