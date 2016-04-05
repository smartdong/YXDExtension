//
//  NSObject+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "NSObject+YXDExtension.h"
#import <objc/message.h>
#import "NSString+YXDExtension.h"

#define force_inline __inline__ __attribute__((always_inline))

//https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
//https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html

typedef NS_ENUM(NSInteger, YXDEncodingType) {
    
    YXDEncodingTypeUnknown,
    
    //下面这些支持自动赋值
    YXDEncodingTypeString,
    YXDEncodingTypeMutableString,
    YXDEncodingTypeArray,
    YXDEncodingTypeMutableArray,
    YXDEncodingTypeDictionary,
    YXDEncodingTypeMutableDictionary,
    YXDEncodingTypeNumber,
    YXDEncodingTypeDate,
    YXDEncodingTypeObject,
    YXDEncodingTypeInt32,
    YXDEncodingTypeUInt32,
    YXDEncodingTypeFloat,
    YXDEncodingTypeDouble,
    YXDEncodingTypeBool,
    YXDEncodingTypeBoolean,
    
    //下面这些不支持自动赋值
    YXDEncodingTypeVoid,
    YXDEncodingTypeInt8 = YXDEncodingTypeBool,
    YXDEncodingTypeUInt8 = YXDEncodingTypeBoolean,
    YXDEncodingTypeInt16,
    YXDEncodingTypeUInt16,
    YXDEncodingTypeInt64,
    YXDEncodingTypeUInt64,
    YXDEncodingTypeLongDouble,
    YXDEncodingTypeClass,
    YXDEncodingTypeSEL,
    YXDEncodingTypeCString,
    YXDEncodingTypePointer,
    YXDEncodingTypeCArray,
    YXDEncodingTypeUnion,
    YXDEncodingTypeStruct,
    YXDEncodingTypeBlock,
};

typedef NS_ENUM(NSInteger, YXDPropertyType) {
    YXDPropertyTypeUnknown      = 0,
    YXDPropertyTypeNonatomic    = 1 << 1,
    YXDPropertyTypeCopy         = 1 << 2,
    YXDPropertyTypeRetain       = 2 << 2,
    YXDPropertyTypeWeak         = 3 << 2,
    YXDPropertyTypeReadonly     = 1 << 3,
    YXDPropertyTypeCustomGetter = 2 << 3,
    YXDPropertyTypeCustomSetter = 3 << 3,
    YXDPropertyTypeDynamic      = 4 << 3,
};

YXDEncodingType YXDGetEncodingType(const char *typeEncoding) {
    char *type = (char *)typeEncoding;
    if (!type) {
        return YXDEncodingTypeUnknown;
    }
    
    size_t len = strlen(type);
    if (len == 0) {
        return YXDEncodingTypeUnknown;
    }

    switch (*type) {
        case 'v': return YXDEncodingTypeVoid;
        case 'B': return YXDEncodingTypeBool;
        case 'c': return YXDEncodingTypeBool;
        case 'C': return YXDEncodingTypeBoolean;
        case 's': return YXDEncodingTypeInt16;
        case 'S': return YXDEncodingTypeUInt16;
        case 'i': return YXDEncodingTypeInt32;
        case 'I': return YXDEncodingTypeUInt32;
        case 'l': return YXDEncodingTypeInt32;
        case 'L': return YXDEncodingTypeUInt32;
        case 'q': return YXDEncodingTypeInt64;
        case 'Q': return YXDEncodingTypeUInt64;
        case 'f': return YXDEncodingTypeFloat;
        case 'd': return YXDEncodingTypeDouble;
        case 'D': return YXDEncodingTypeLongDouble;
        case '#': return YXDEncodingTypeClass;
        case ':': return YXDEncodingTypeSEL;
        case '*': return YXDEncodingTypeCString;
        case '^': return YXDEncodingTypePointer;
        case '[': return YXDEncodingTypeCArray;
        case '(': return YXDEncodingTypeUnion;
        case '{': return YXDEncodingTypeStruct;
        case '@': {
            if (len == 2 && *(type + 1) == '?') {
                return YXDEncodingTypeBlock;
            } else {
                //TODO: 对各种类型判断
                
//                YXDEncodingTypeString,
//                YXDEncodingTypeMutableString,
//                YXDEncodingTypeArray,
//                YXDEncodingTypeMutableArray,
//                YXDEncodingTypeDictionary,
//                YXDEncodingTypeMutableDictionary,
//                YXDEncodingTypeNumber,
//                YXDEncodingTypeDate,
                
                return YXDEncodingTypeObject;
            }
        }
        default: return YXDEncodingTypeUnknown;
    }
    return YXDEncodingTypeUnknown;
}

//根据对象的属性和类型赋值
static force_inline void YXDSetPropertyValue(NSObject *object, NSString *setter, YXDEncodingType encodingType, id value, Class arrayObjectClass) {
    
    if (!object || !setter || !value || [value isKindOfClass:[NSNull class]] || (encodingType == YXDEncodingTypeUnknown)) {
        return;
    }
    
    switch (encodingType) {
        case YXDEncodingTypeString:
        {
            
        }
            break;
        case YXDEncodingTypeMutableString:
        {
            
        }
            break;
        case YXDEncodingTypeArray:
        {
            
        }
            break;
        case YXDEncodingTypeMutableArray:
        {
            
        }
            break;
        case YXDEncodingTypeDictionary:
        {
            
        }
            break;
        case YXDEncodingTypeMutableDictionary:
        {
            
        }
            break;
        case YXDEncodingTypeNumber:
        {
            
        }
            break;
        case YXDEncodingTypeDate:
        {
            
        }
            break;
        case YXDEncodingTypeObject:
        {
            
        }
            break;
        case YXDEncodingTypeInt32:
        {
            
        }
            break;
        case YXDEncodingTypeUInt32:
        {
            
        }
            break;
        case YXDEncodingTypeFloat:
        {
            
        }
            break;
        case YXDEncodingTypeDouble:
        {
            
        }
            break;
        case YXDEncodingTypeBool:
        {
            
        }
            break;
        case YXDEncodingTypeBoolean:
        {
            
        }
            break;
            
        default:
            break;
    }
}

//propertyString                T@"NSString",&,N,V_propertyString
//propertyNumber                T@"NSNumber",&,N,V_propertyNumber
//propertyArray                 T@"NSArray",&,N,V_propertyArray
//propertyDictionary            T@"NSDictionary",&,N,V_propertyDictionary
//propertyClass                 T^#,N,V_propertyClass
//propertyBlock                 T@?,C,N,V_propertyBlock
//propertyObject                T@"NSObject",&,N,V_propertyObject
//propertySEL                   T^:,N,V_propertySEL
//propertyInteger               Ti,N,V_propertyInteger
//propertyFloat                 Tf,N,V_propertyFloat
//propertyBool                  Tc,N,V_propertyBool
//propertyMutableString         T@"NSMutableString",&,N,V_propertyMutableString
//propertyMutableArray          T@"NSMutableArray",&,N,V_propertyMutableArray
//propertyMutableDictionary     T@"NSMutableDictionary",&,N,V_propertyMutableDictionary
//propertyInt                   Ti,N,V_propertyInt
//propertyDouble                Td,N,V_propertyDouble
//propertyBoolean               TC,N,V_propertyBoolean
//propertyViewController        T@"UIViewController",&,N,V_propertyViewController
//propertyDate                  T@"NSDate",&,N,V_propertyDate
//propertyBlockWithArgs         T@?,C,N,V_propertyBlockWithArgs
//propertySize                  T{CGSize=ff},N,V_propertySize

static force_inline NSDictionary* YXDGetPropertyMapDictionary(NSObject *object) {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    if ([object respondsToSelector:@selector(propertyMap)]) {
        NSDictionary *map = [object performSelector:@selector(propertyMap)];
        if (map && [map isKindOfClass:[NSDictionary class]] && map.count) {
            return map;
        }
    }
    
#pragma clang diagnostic pop
    
    return nil;
}

@interface YXDPropertyInfo : NSObject

@property (nonatomic, assign, readonly) objc_property_t property;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *getter;
@property (nonatomic, strong, readonly) NSString *setter;
@property (nonatomic, assign, readonly) YXDEncodingType encodingType;
@property (nonatomic, assign, readonly) YXDPropertyType propertyType;

@property (nonatomic, strong, readwrite) NSString *mapKey;          //propertyMap中定义的服务器返回字段名 如果为nil 则代表服务器返回的就是name
@property (nonatomic, assign, readwrite) Class arrayObjectClass;    //如果属性类型是数组 且propertyMap方法里有对象类型定义 则代表数组内对象的类型 否则为nil

- (instancetype)initWithProperty:(objc_property_t)property;

@end

@implementation YXDPropertyInfo

- (instancetype)initWithProperty:(objc_property_t)property {
    if (!property) return nil;
    self = [self init];
    _property = property;
//    const char *name = property_getName(property);
//    if (name) {
//        _name = [NSString stringWithUTF8String:name];
//    }
//    
//    _propertyType = YXDPropertyTypeUnknown;
//    
//    unsigned int attrCount;
//    objc_property_attribute_t *attrs = property_copyAttributeList(property, &attrCount);
//    for (unsigned int i = 0; i < attrCount; i++) {
//        switch (attrs[i].name[0]) {
//            case 'T': { // Type encoding
//                if (attrs[i].value) {
//
//                    _encodingType = YXDEncodingGetType(attrs[i].value);
    
//                    if (type & YYEncodingTypeObject) {
//                        size_t len = strlen(attrs[i].value);
//                        if (len > 3) {
//                            char name[len - 2];
//                            name[len - 3] = '\0';
//                            memcpy(name, attrs[i].value + 2, len - 3);
//                            _cls = objc_getClass(name);
//                        }
//                    }
//                }
//            } break;
//            case 'R': {
//                _propertyType |= YXDPropertyTypeReadonly;
//            } break;
//            case 'C': {
//                _propertyType |= YXDPropertyTypeCopy;
//            } break;
//            case '&': {
//                _propertyType |= YXDPropertyTypeRetain;
//            } break;
//            case 'N': {
//                _propertyType |= YXDPropertyTypeNonatomic;
//            } break;
//            case 'D': {
//                _propertyType |= YXDPropertyTypeDynamic;
//            } break;
//            case 'W': {
//                _propertyType |= YXDPropertyTypeWeak;
//            } break;
//            case 'G': {
//                _propertyType |= YXDPropertyTypeCustomGetter;
//                if (attrs[i].value) {
//                    _getter = [NSString stringWithUTF8String:attrs[i].value];
//                }
//            } break;
//            case 'S': {
//                _propertyType |= YXDPropertyTypeCustomSetter;
//                if (attrs[i].value) {
//                    _setter = [NSString stringWithUTF8String:attrs[i].value];
//                }
//            } break;
//            default: break;
//        }
//    }
//    if (attrs) {
//        free(attrs);
//        attrs = NULL;
//    }
//    
//    if (_name.length) {
//        if (!_getter) {
//            _getter = _name;
//        }
//        if (!_setter) {
//            _setter = [NSString stringWithFormat:@"set%@%@:", [_name substringToIndex:1].uppercaseString, [_name substringFromIndex:1]];
//        }
//    }
    return self;
}

@end

@interface YXDClassInfo : NSObject

@property (nonatomic, assign, readonly) Class cls;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSDictionary<NSString *, YXDPropertyInfo *> *propertyInfos;     //对象属性信息
@property (nonatomic, strong, readonly) NSDictionary<NSString *, id> *propertyMap;

+ (instancetype)classInfoWithClass:(Class)cls;
+ (instancetype)classInfoWithClassName:(NSString *)className;

@end

@implementation YXDClassInfo

- (instancetype)initWithClass:(Class)cls {
    if (!cls) return nil;
    self = [super init];
    _cls = cls;
    _name = NSStringFromClass(cls);
    [self initInfos];
    
    return self;
}

- (void)initInfos {
    _propertyInfos = nil;
    
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(self.cls, &propertyCount);
    if (properties) {
        NSMutableDictionary *propertyInfos = [NSMutableDictionary new];
        _propertyInfos = propertyInfos;
        for (unsigned int i = 0; i < propertyCount; i++) {
            YXDPropertyInfo *info = [[YXDPropertyInfo alloc] initWithProperty:properties[i]];
            if (info.name) {
                propertyInfos[info.name] = info;
            }
        }
        free(properties);
    }
    
    _propertyMap = YXDGetPropertyMapDictionary([_cls new]);
    
    if (!_propertyInfos.count || !_propertyMap.count) {
        return;
    }
    
    [_propertyMap enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        YXDPropertyInfo *propertyInfo = [_propertyInfos objectForKey:key];
        if (propertyInfo) {
            if ([obj isKindOfClass:[NSString class]] && ((NSString *)obj).length) {
                propertyInfo.mapKey = obj;
            } else if ([obj isKindOfClass:[NSDictionary class]]) {
                NSString *firstKey = ((NSDictionary *)obj).allKeys.firstObject;
                id clazz = [((NSDictionary *)obj) objectForKey:firstKey];
                if ([firstKey isKindOfClass:[NSString class]] && firstKey.length && [clazz respondsToSelector:@selector(isSubclassOfClass:)]) {
                    propertyInfo.mapKey = firstKey;
                    propertyInfo.arrayObjectClass = clazz;
                }
            }
        }
    }];
}

+ (instancetype)classInfoWithClass:(Class)cls {
    if (!cls || (cls == [NSObject class])) return nil;
    static CFMutableDictionaryRef classCache;
    static dispatch_once_t onceToken;
    static dispatch_semaphore_t lock;
    dispatch_once(&onceToken, ^{
        classCache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        lock = dispatch_semaphore_create(1);
    });
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    YXDClassInfo *info = CFDictionaryGetValue(classCache, (__bridge const void *)(cls));

    dispatch_semaphore_signal(lock);
    if (!info) {
        info = [[YXDClassInfo alloc] initWithClass:cls];
        if (info) {
            dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
            CFDictionarySetValue(classCache, (__bridge const void *)(cls), (__bridge const void *)(info));
            dispatch_semaphore_signal(lock);
        }
    }
    return info;
}

+ (instancetype)classInfoWithClassName:(NSString *)className {
    return [self classInfoWithClass:NSClassFromString(className)];
}

#pragma mark - 

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

// 如果有 propertyMap 则根据属性值获取实际返回的对应值
- (NSString *)mapKeyWithPropertyName:(NSString *)propertyName {
    if (!propertyName.length || !_propertyMap) {
        return nil;
    }
    
    NSString *mapKey = nil;
    
    id value = [_propertyMap valueForKey:propertyName];
    
    if ([value isKindOfClass:[NSString class]] && ((NSString *)value).length) {
        mapKey = value;
    } else if ([value isKindOfClass:[NSDictionary class]]) {
        NSString *firstKey = ((NSDictionary *)value).allKeys.firstObject;
        if ([firstKey isKindOfClass:[NSString class]] && firstKey.length) {
            mapKey = firstKey;
        }
    }
    
    return mapKey;
}

@end

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

#warning 优化方案考虑如下: \
1.缓存 \
2.一些对象可以声明成 __unsafe_unretained \
3.使用高效的数组遍历方法 \
4.优化遍历方案，减少遍历次数 \
5.使用内联函数 \

- (instancetype)voluationWithData:(id)data {
    
    YXDClassInfo *classInfo = [YXDClassInfo classInfoWithClass:[self class]];
    
    NSArray *propertyList = classInfo.propertyInfos.allKeys;
    
    if (!propertyList || !propertyList.count || !data || [data isKindOfClass:[NSNull class]]) {
        return self;
    }
    
    //属性名称直接对应返回值
    for (NSString *propertyName in propertyList) {
        [self voluationWithPropertyName:propertyName value:[data valueForKey:propertyName] arrayObjectClass:nil];
    }
    
    //属性名称对应不同的返回值
    NSDictionary *propertyMapDictionary = classInfo.propertyMap;
    
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
    
    YXDClassInfo *classInfo = [YXDClassInfo classInfoWithClass:[self class]];
//    YXDPropertyInfo *propertyInfo = classInfo.propertyInfos[propertyName];
    
    Class propertyClass = nil;
    
    if (!propertyClass) {
        return;
    }
    
    if (propertyClass == [NSString class]) {
        if ([value isKindOfClass:[NSString class]]) {
            propertyValue = value;
        }
    } else if (propertyClass == [NSNumber class]) {
        if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
            propertyValue = @([value doubleValue]);
        }
    } else if ((propertyClass == [NSArray class]) || (propertyClass == [NSMutableArray class])) {
        
        NSDictionary *propertyMapDictionary = classInfo.propertyMap;
        
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

- (NSDictionary *)propertyValuesWithNeedNullValue:(BOOL)needNullValue useMapPropertyKey:(BOOL)useMapPropertyKey {
    
    YXDClassInfo *classInfo = [YXDClassInfo classInfoWithClass:[self class]];
    
    NSArray *propertyList = classInfo.propertyInfos.allKeys;
    
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
    
    NSDictionary *propertyMapDictionary = classInfo.propertyMap;
    
    if (useMapPropertyKey && propertyMapDictionary) {
        for (NSString *key in propertyMapDictionary.allKeys) {
            if (![key isKindOfClass:[NSString class]] || !key.length) {
                continue;
            }
            
            NSString *mapPropertyKey = [classInfo mapKeyWithPropertyName:key];
            
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

//防止意外崩溃 但是这样做就无法在其他类里面再对这种情况进行处理 考虑到极少需要处理这种情况 所以我觉得无所谓 :)
- (id)valueForUndefinedKey:(NSString *)key {
    NSLog(@"%@ -> valueForUndefinedKey : %@",self,key);
    return nil;
}

@end
