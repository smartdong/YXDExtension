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


#pragma mark - 存取userData部分

-(void)setUserData:(id)userData {
    objc_setAssociatedObject(self, YXDExtensionNSObjectUserDataKey, userData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(id)userData {
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
    
    for (NSString *valueKey in propertyList) {
        BOOL valid;
        
        if ([data isKindOfClass:[NSDictionary class]]) {
            valid = ([data valueForKey:valueKey] == nil)?NO:YES;
        } else {
            valid = [data respondsToSelector:NSSelectorFromString(valueKey)];
        }
        
        if (valid) {
            id value = [data valueForKey:valueKey];
            
            if (value && ![value isKindOfClass:[NSNull class]]) {
                [self setValue:value forKey:valueKey];
            }
        }
    }
    
    return self;
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
