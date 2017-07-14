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
    YXDEncodingTypeDate,    //仅支持服务器返回数字 值为timeIntervalSince1970
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

typedef NS_OPTIONS(NSInteger, YXDPropertyType) {
    
    YXDPropertyTypeUnknown      = 0,
    
    YXDPropertyTypeNonatomic    = 1 << 1,
    
    YXDPropertyTypeCopy         = 1 << 2,
    YXDPropertyTypeRetain       = 2 << 2,
    YXDPropertyTypeWeak         = 3 << 2,
    
    YXDPropertyTypeCustomGetter = 1 << 3,
    YXDPropertyTypeCustomSetter = 2 << 3,
    YXDPropertyTypeDynamic      = 3 << 3,
    
    YXDPropertyTypeReadonly     = 1 << 4,
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
        case '*': return YXDEncodingTypeCString;
        case '[': return YXDEncodingTypeCArray;
        case '(': return YXDEncodingTypeUnion;
        case '{': return YXDEncodingTypeStruct;
        case '^':
        {
            if (len == 2) {
                if (*(type + 1) == '#') {
                    return YXDEncodingTypeClass;
                } else if (*(type + 1) == ':') {
                    return YXDEncodingTypeSEL;
                }
            } else {
                return YXDEncodingTypePointer;
            }
        }
        case '@':
        {
            if (len == 2 && *(type + 1) == '?') {
                return YXDEncodingTypeBlock;
            } else {
                return YXDEncodingTypeObject;
            }
        }
        default: return YXDEncodingTypeUnknown;
    }
    return YXDEncodingTypeUnknown;
}

//根据对象的属性和类型赋值
static force_inline void YXDSetPropertyValue(NSObject *object, SEL setter, YXDEncodingType encodingType, id value, Class objectClass) {

    if (!object || !setter || (encodingType == YXDEncodingTypeUnknown) || !value || [value isKindOfClass:[NSNull class]]) {
        return;
    }
    
    switch (encodingType) {
        case YXDEncodingTypeString:
        case YXDEncodingTypeMutableString:
        {
            NSString *val = nil;
            
            if ([value isKindOfClass:[NSString class]]) {
                val = value;
            } else if ([value isKindOfClass:[NSNumber class]]) {
                val = ((NSNumber *)value).stringValue;
            }
            
            if (val) {
                if (encodingType == YXDEncodingTypeString) {
                    ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)object, setter, val);
                } else if (encodingType == YXDEncodingTypeMutableString) {
                    ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)object, setter, val.mutableCopy);
                }
            }
        }
            break;
        case YXDEncodingTypeArray:
        case YXDEncodingTypeMutableArray:
        {
            NSMutableArray *val = nil;
            
            if (![value isKindOfClass:[NSArray class]] && [value isKindOfClass:[NSString class]]) {
                value = [value objectFromJSONString];
            }
            
            if (objectClass && [value isKindOfClass:[NSArray class]] && [(NSArray *)value count]) {
                val = [NSMutableArray array];
                
                for (id obj in value) {
                    id newObj = [objectClass objectWithData:obj];
                    if (newObj) {
                        [val addObject:newObj];
                    }
                }
                
                if (val.count) {
                    ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)object, setter, val);
                }
            }
        }
            break;
        case YXDEncodingTypeDictionary:
        case YXDEncodingTypeMutableDictionary:
        {
            NSDictionary *val = nil;
            
            if (![value isKindOfClass:[NSDictionary class]] && [value isKindOfClass:[NSString class]]) {
                value = [value objectFromJSONString];
            }
            
            if ([value isKindOfClass:[NSDictionary class]]) {
                val = value;
            }

            if (val) {
                if (encodingType == YXDEncodingTypeDictionary) {
                    ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)object, setter, val);
                } else if (encodingType == YXDEncodingTypeMutableDictionary) {
                    ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)object, setter, val.mutableCopy);
                }
            }
        }
            break;
        case YXDEncodingTypeObject:
        {
            NSDictionary *val = nil;
            
            if ([value isKindOfClass:[NSDictionary class]]) {
                val = value;
            }
            
            if (objectClass && val) {
                ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)object, setter, [objectClass objectWithData:val]);
            }
        }
            break;
        case YXDEncodingTypeNumber:
        case YXDEncodingTypeDate:
        case YXDEncodingTypeInt32:
        case YXDEncodingTypeUInt32:
        case YXDEncodingTypeFloat:
        case YXDEncodingTypeDouble:
        case YXDEncodingTypeBool:
        case YXDEncodingTypeBoolean:
        {
            NSNumber *val = nil;
            
            if ([value isKindOfClass:[NSNumber class]]) {
                val = value;
            } else if ([value isKindOfClass:[NSString class]]) {
                val = @([((NSString *)value) doubleValue]);
            }
            
            if (val) {
                switch (encodingType) {
                    case YXDEncodingTypeNumber:
                    {
                        ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)object, setter, val);
                    }
                        break;
                    case YXDEncodingTypeDate:
                    {
                        ((void (*)(id, SEL, id))(void *) objc_msgSend)((id)object, setter, [NSDate dateWithTimeIntervalSince1970:val.floatValue]);
                    }
                        break;
                    case YXDEncodingTypeInt32:
                    {
                        ((void (*)(id, SEL, int32_t))(void *) objc_msgSend)((id)object, setter, (int32_t)val.integerValue);
                    }
                        break;
                    case YXDEncodingTypeUInt32:
                    {
                        ((void (*)(id, SEL, uint32_t))(void *) objc_msgSend)((id)object, setter, (uint32_t)val.unsignedIntegerValue);
                    }
                        break;
                    case YXDEncodingTypeFloat:
                    {
                        ((void (*)(id, SEL, float))(void *) objc_msgSend)((id)object, setter, val.floatValue);
                    }
                        break;
                    case YXDEncodingTypeDouble:
                    {
                        ((void (*)(id, SEL, double))(void *) objc_msgSend)((id)object, setter, val.doubleValue);
                    }
                        break;
                    case YXDEncodingTypeBool:
                    {
                        ((void (*)(id, SEL, int8_t))(void *) objc_msgSend)((id)object, setter, (int8_t)val.charValue);
                    }
                        break;
                    case YXDEncodingTypeBoolean:
                    {
                        ((void (*)(id, SEL, uint8_t))(void *) objc_msgSend)((id)object, setter, (uint8_t)val.unsignedCharValue);
                    }
                        break;
                    default:
                        break;
                }
            }
        }
            break;
        default:
            break;
    }
}

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
@property (nonatomic, assign, readonly) SEL getter;
@property (nonatomic, assign, readonly) SEL setter;
@property (nonatomic, assign, readonly) YXDEncodingType encodingType;
@property (nonatomic, assign, readonly) YXDPropertyType propertyType;

@property (nonatomic, strong, readwrite) NSString *mapKey;          //propertyMap中定义的服务器返回字段名 如果为nil 则代表服务器返回的就是name
@property (nonatomic, assign, readwrite) Class objectClass;         //如果属性类型是数组 且propertyMap方法里有对象类型定义 则代表数组内对象的类型 或属性类型为对象 则代表对象类型 否则为nil

- (instancetype)initWithProperty:(objc_property_t)property;

@end

@implementation YXDPropertyInfo

- (instancetype)initWithProperty:(objc_property_t)property {
    if (!property) return nil;
    self = [self init];
    _property = property;

    const char *name = property_getName(property);
    if (name) {
        _name = [NSString stringWithUTF8String:name];
    }
    
    _propertyType = YXDPropertyTypeUnknown;
    
    unsigned int attrCount;
    objc_property_attribute_t *attrs = property_copyAttributeList(property, &attrCount);
    for (unsigned int i = 0; i < attrCount; i++) {
        switch (attrs[i].name[0]) {
            case 'T':
            {
                if (attrs[i].value) {
                    _encodingType = YXDGetEncodingType(attrs[i].value);
                    
                    if (_encodingType == YXDEncodingTypeObject) {
                        size_t len = strlen(attrs[i].value);
                        if (len > 3) {
                            char name[len - 2];
                            name[len - 3] = '\0';
                            memcpy(name, attrs[i].value + 2, len - 3);
                            _objectClass = objc_getClass(name);

                            if ([_objectClass isSubclassOfClass:[NSMutableString class]]) {
                                _encodingType = YXDEncodingTypeMutableString;
                            } else if ([_objectClass isSubclassOfClass:[NSString class]]) {
                                _encodingType = YXDEncodingTypeString;
                            } else if ([_objectClass isSubclassOfClass:[NSMutableArray class]]) {
                                _encodingType = YXDEncodingTypeMutableArray;
                            } else if ([_objectClass isSubclassOfClass:[NSArray class]]) {
                                _encodingType = YXDEncodingTypeArray;
                            } else if ([_objectClass isSubclassOfClass:[NSMutableDictionary class]]) {
                                _encodingType = YXDEncodingTypeMutableDictionary;
                            } else if ([_objectClass isSubclassOfClass:[NSDictionary class]]) {
                                _encodingType = YXDEncodingTypeDictionary;
                            } else if ([_objectClass isSubclassOfClass:[NSNumber class]]) {
                                _encodingType = YXDEncodingTypeNumber;
                            } else if ([_objectClass isSubclassOfClass:[NSDate class]]) {
                                _encodingType = YXDEncodingTypeDate;
                            }
                        }
                    }
                }
            }
                break;
            case 'R':
            {
                _propertyType |= YXDPropertyTypeReadonly;
            }
                break;
            case 'C':
            {
                _propertyType |= YXDPropertyTypeCopy;
            }
                break;
            case '&':
            {
                _propertyType |= YXDPropertyTypeRetain;
            }
                break;
            case 'N':
            {
                _propertyType |= YXDPropertyTypeNonatomic;
            }
                break;
            case 'D':
            {
                _propertyType |= YXDPropertyTypeDynamic;
            }
                break;
            case 'W':
            {
                _propertyType |= YXDPropertyTypeWeak;
            }
                break;
            case 'G':
            {
                _propertyType |= YXDPropertyTypeCustomGetter;
                if (attrs[i].value) {
                    _getter = NSSelectorFromString([NSString stringWithUTF8String:attrs[i].value]);
                }
            }
                break;
            case 'S':
            {
                _propertyType |= YXDPropertyTypeCustomSetter;
                if (attrs[i].value) {
                    _setter = NSSelectorFromString([NSString stringWithUTF8String:attrs[i].value]);
                }
            }
                break;
            default:
                break;
        }
    }
    if (attrs) {
        free(attrs);
        attrs = NULL;
    }
    
    if (_name.length) {
        if (!_getter) {
            _getter = NSSelectorFromString(_name);
        }
        if (!_setter) {
            _setter = NSSelectorFromString([NSString stringWithFormat:@"set%@%@:", [_name substringToIndex:1].uppercaseString, [_name substringFromIndex:1]]);
        }
    }
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
    
    if (!_propertyMap.count || !_propertyInfos.count) {
        return;
    }
    
    [_propertyMap enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        YXDPropertyInfo *propertyInfo = [_propertyInfos objectForKey:key];
        if (propertyInfo) {
            if ([obj isKindOfClass:[NSString class]] && ((NSString *)obj).length) {
                propertyInfo.mapKey = obj;
            } else if (((propertyInfo.encodingType == YXDEncodingTypeArray) || (propertyInfo.encodingType == YXDEncodingTypeMutableArray)) && [obj isKindOfClass:[NSDictionary class]]) {
                NSString *firstKey = ((NSDictionary *)obj).allKeys.firstObject;
                id clazz = [((NSDictionary *)obj) objectForKey:firstKey];
                if ([firstKey isKindOfClass:[NSString class]] && firstKey.length && [clazz respondsToSelector:@selector(isSubclassOfClass:)]) {
                    propertyInfo.mapKey = firstKey;
                    propertyInfo.objectClass = clazz;
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

@end

//根据对象属性生成 dictionary
static force_inline NSDictionary* YXDGetPropertyValue(NSObject *object, BOOL needNullValue, BOOL useMapPropertyKey) {
    
    Class clazz = [object class];
    
    //如果某个对象的属性是数组时会用到这块代码
    if ([clazz isSubclassOfClass:[NSNull class]]) {
        return nil;
    } else if ([clazz isSubclassOfClass:[NSDate class]]) {
        return (id)@([((NSDate *)object) timeIntervalSince1970]);
    } else if ([clazz isSubclassOfClass:[NSString class]] ||
               [clazz isSubclassOfClass:[NSNumber class]] ||
               [clazz isSubclassOfClass:[NSDictionary class]]) {
        return (id)object;
    } else if ([clazz isSubclassOfClass:[NSArray class]]) {
        NSMutableArray *arr = [NSMutableArray array];
        for (id arrObj in (NSArray *)object) {
            id newObjPV = YXDGetPropertyValue(arrObj, needNullValue, useMapPropertyKey);
            if (newObjPV) {
                [arr addObject:newObjPV];
            }
        }
        if (arr.count) {
            return (id)arr;
        }
    }
    
    YXDClassInfo *classInfo = [YXDClassInfo classInfoWithClass:[object class]];
    
    if (!classInfo.propertyInfos.count) {
        return nil;
    }

    NSMutableDictionary *propertyValues = [NSMutableDictionary dictionary];
    
    [classInfo.propertyInfos enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, YXDPropertyInfo * _Nonnull obj, BOOL * _Nonnull stop) {
        
        id value = nil;
        
        switch (obj.encodingType) {
            case YXDEncodingTypeString:
            case YXDEncodingTypeMutableString:
            {
                value = ((NSString* (*)(id, SEL))(void *) objc_msgSend)((id)object, obj.getter);
            }
                break;
            case YXDEncodingTypeArray:
            case YXDEncodingTypeMutableArray:
            {
                NSArray *arr = ((NSArray* (*)(id, SEL))(void *) objc_msgSend)((id)object, obj.getter);
                if (arr && [arr isKindOfClass:[NSArray class]] && arr.count) {
                    NSMutableArray *valArray = [NSMutableArray array];
                    [arr enumerateObjectsUsingBlock:^(id  _Nonnull arrObj, NSUInteger idx, BOOL * _Nonnull stop) {
                        id arrObjPV = YXDGetPropertyValue(arrObj, needNullValue, useMapPropertyKey);
                        if (arrObjPV) {
                            [valArray addObject:arrObjPV];
                        }
                    }];
                    if (valArray.count) {
                        value = valArray;
                    }
                }
            }
                break;
            case YXDEncodingTypeDictionary:
            {
                value = ((NSDictionary* (*)(id, SEL))(void *) objc_msgSend)((id)object, obj.getter);
            }
                break;
            case YXDEncodingTypeMutableDictionary:
            {
                value = ((NSMutableDictionary* (*)(id, SEL))(void *) objc_msgSend)((id)object, obj.getter);
            }
                break;
            case YXDEncodingTypeObject:
            {
                value = YXDGetPropertyValue(((NSObject* (*)(id, SEL))(void *) objc_msgSend)((id)object, obj.getter), needNullValue, useMapPropertyKey);
            }
                break;
            case YXDEncodingTypeNumber:
            {
                value = ((NSNumber* (*)(id, SEL))(void *) objc_msgSend)((id)object, obj.getter);
            }
                break;
            case YXDEncodingTypeDate:
            {
                value = @([((NSDate* (*)(id, SEL))(void *) objc_msgSend)((id)object, obj.getter) timeIntervalSince1970]);
            }
                break;
            case YXDEncodingTypeInt32:
            {
                value = @(((int32_t (*)(id, SEL))(void *) objc_msgSend)((id)object, obj.getter));
            }
                break;
            case YXDEncodingTypeUInt32:
            {
                value = @(((uint32_t (*)(id, SEL))(void *) objc_msgSend)((id)object, obj.getter));
            }
                break;
            case YXDEncodingTypeFloat:
            {
                value = @(((float (*)(id, SEL))(void *) objc_msgSend)((id)object, obj.getter));
            }
                break;
            case YXDEncodingTypeDouble:
            {
                value = @(((double (*)(id, SEL))(void *) objc_msgSend)((id)object, obj.getter));
            }
                break;
            case YXDEncodingTypeBool:
            {
                value = @(((int8_t (*)(id, SEL))(void *) objc_msgSend)((id)object, obj.getter));
            }
                break;
            case YXDEncodingTypeBoolean:
            {
                value = @(((uint8_t (*)(id, SEL))(void *) objc_msgSend)((id)object, obj.getter));
            }
                break;
            default:
                break;
        }
        
        if (!value && needNullValue) {
            value = [NSNull null];
        }
        
        if (value) {
            [propertyValues setObject:value forKey:(useMapPropertyKey && obj.mapKey)?obj.mapKey:obj.name];
        }
    }];
    
    if (propertyValues.count) {
        return propertyValues;
    }
    
    return nil;
}

static const void *YXDExtensionNSObjectUserDataKey = &YXDExtensionNSObjectUserDataKey;

@implementation NSObject (YXDExtension)

#pragma mark - 新建对象 & 对象赋值

//根据数据创建对象数组
+ (NSMutableArray *)objectArrayWithDictionaryArray:(NSArray<NSDictionary *> *)dictionaryArray {
    if (!dictionaryArray.count) {
        return nil;
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSDictionary *dic in dictionaryArray) {
        id obj = [self objectWithData:dic];
        if (obj) {
            [arr addObject:obj];
        }
    }
    if (arr.count) {
        return arr;
    }
    return nil;
}

+ (instancetype)objectWithData:(id)data {
    
    Class clazz = [self class];
    
    if (!data || [data isKindOfClass:[NSNull class]] || (clazz == [NSObject class])) {
        return nil;
    }
    
    if ([clazz isSubclassOfClass:[NSMutableString class]]) {
        if ([data isKindOfClass:[NSString class]]) {
            return [data mutableCopy];
        }
    } else if ([clazz isSubclassOfClass:[NSString class]]) {
        if ([data isKindOfClass:[NSString class]]) {
            return data;
        }
    } else if ([clazz isSubclassOfClass:[NSNumber class]]) {
        if ([data isKindOfClass:[NSNumber class]] || [data isKindOfClass:[NSNumber class]]) {
            return @([data doubleValue]);
        }
    } else if ([clazz isSubclassOfClass:[NSMutableDictionary class]]) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            return [data mutableCopy];
        }
    } else if ([clazz isSubclassOfClass:[NSDictionary class]]) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            return data;
        }
    } else if ([clazz isSubclassOfClass:[NSArray class]]) {
        if ([data isKindOfClass:[NSArray class]] && [(NSArray *)data count]) {
            NSMutableArray *arr = [NSMutableArray array];
            for (id obj in data) {
                //因为无法确定obj的具体类型 所以只能支持基本类型
                id newObj = [[obj class] objectWithData:obj];
                if (newObj) {
                    [arr addObject:newObj];
                }
            }
            if (arr.count) {
                return arr;
            }
        }
    } else {
        return [[self new] voluationWithData:data];
    }
    
    return nil;
}

- (instancetype)voluationWithData:(id)data {
    
    YXDClassInfo *classInfo = [YXDClassInfo classInfoWithClass:[self class]];
    
    if (!data || [data isKindOfClass:[NSNull class]] || !classInfo.propertyInfos.count) {
        return self;
    }

    BOOL useMapPropertyKey = [data isKindOfClass:[NSDictionary class]];
    [classInfo.propertyInfos enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, YXDPropertyInfo * _Nonnull obj, BOOL * _Nonnull stop) {
        if (!(obj.propertyType & YXDPropertyTypeReadonly)) {
            YXDSetPropertyValue(self, obj.setter, obj.encodingType, [data valueForKey:(useMapPropertyKey && obj.mapKey)?obj.mapKey:key], obj.objectClass);
        }
    }];

    return self;
}

#pragma mark - 各种列表

- (NSArray *)propertyList {
    return [[self class] propertyList];
}

- (NSDictionary *)propertyValues {
    return YXDGetPropertyValue(self, NO, NO);
}

- (NSDictionary *)propertyValuesUseMapPropertyKey {
    return YXDGetPropertyValue(self, NO, YES);
}

- (NSDictionary *)allPropertyValues {
    return YXDGetPropertyValue(self, YES, NO);
}

- (NSDictionary *)allPropertyValuesUseMapPropertyKey {
    return YXDGetPropertyValue(self, YES, YES);
}

- (NSArray *)methodList {
    return [[self class] methodList];
}

- (NSArray *)ivarList {
    return [[self class] ivarList];
}

//获取当前类的属性列表
+ (NSArray *)propertyList {
    YXDClassInfo *classInfo = [YXDClassInfo classInfoWithClass:[self class]];
    return classInfo.propertyInfos.allKeys;
}

//获取当前类的方法列表
+ (NSArray *)methodList {
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

//获取当前类的实例变量列表
+ (NSArray *)ivarList {
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

#pragma mark - JSON 互转

- (NSString *)JSONString {
    return self.propertyValuesUseMapPropertyKey.JSONString;
}

+ (instancetype)objectWithJSONString:(NSString *)JSONString {
    return [self objectWithData:[JSONString objectFromJSONString]];
}

+ (NSString *)JSONStringFromObjectArray:(NSArray *)objectArray {
    NSMutableArray *arr = [NSMutableArray array];
    for (id obj in objectArray) {
        NSDictionary *pvs = [obj propertyValuesUseMapPropertyKey];
        if (pvs.count) {
            [arr addObject:pvs];
        }
    }
    if (arr.count) {
        return arr.JSONString;
    }
    return nil;
}

+ (NSArray *)objectArrayFromJSONString:(NSString *)JSONString {
    NSArray *arr = [JSONString objectFromJSONString];
    if (!arr.count) {
        return nil;
    }
    NSMutableArray *objectArray = [NSMutableArray array];
    for (NSDictionary *pvs in arr) {
        if (pvs.count) {
            id obj = [self objectWithData:pvs];
            if (obj) {
                [objectArray addObject:obj];
            }
        }
    }
    if (objectArray.count) {
        return objectArray;
    }
    return nil;
}

#pragma mark - Description

- (NSString *)descriptionWithPropertyValues {
    return [NSString stringWithFormat:@"%@ \n%@",[self description],[self allPropertyValues]];
}

#pragma mark - Others

- (void)postNotificationName:(NSString *)notificationName userInfo:(NSDictionary *)userInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:userInfo];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

+ (instancetype)new {
    return [[self alloc] init];
}

#pragma clang diagnostic pop

#pragma mark - 异常处理

//防止意外崩溃 但是这样做就无法在其他类里面再对这种情况进行处理 考虑到极少需要处理这种情况 所以我觉得无所谓 :)
- (id)valueForUndefinedKey:(NSString *)key {
    NSLog(@"%@ -> valueForUndefinedKey : %@",self,key);
    return nil;
}

#pragma mark - NSCoder

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

#pragma mark - 存取部分

- (void)setUserData:(id)userData {
    objc_setAssociatedObject(self, YXDExtensionNSObjectUserDataKey, userData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)userData {
    return objc_getAssociatedObject(self, YXDExtensionNSObjectUserDataKey);
}

@end
