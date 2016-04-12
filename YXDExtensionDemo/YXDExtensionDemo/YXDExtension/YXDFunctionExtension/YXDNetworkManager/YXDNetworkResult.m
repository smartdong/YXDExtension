//
//  YXDNetworkResult.m
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import "YXDNetworkResult.h"
#import "NSObject+YXDExtension.h"
#import "YXDExtensionDefine.h"

@interface YXDNetworkResult ()

//如果不等于0 则说明返回错误
@property (nonatomic, assign) NSInteger code;

//返回信息
@property (nonatomic, copy) NSString *message;

//返回错误
@property (nonatomic, strong) NSError *error;

//服务器返回的完整数据
@property (nonatomic, strong) NSDictionary *returnDictionary;

//服务器返回的data数据
@property (nonatomic, strong) NSDictionary *data;

@end

@implementation YXDNetworkResult

+ (instancetype)resultWithDictionary:(NSDictionary *)dictionary {
    
    YXDNetworkResult *result = [YXDNetworkResult new];
    
    result.returnDictionary = dictionary;
    
    if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]]) {
        
        result.code     = YXDExtensionErrorCodeServerError;
        result.message  = @"服务器返回数据格式错误";
        result.error    = [NSError errorWithDomain:kYXDExtensionErrorDomain code:result.code userInfo:@{NSLocalizedDescriptionKey : result.message}];
        
        return result;
    }
    
    NSNumber *code = [dictionary objectForKey:kNetworkReturnCodeKey];
    
    if (!code || ![code isKindOfClass:[NSNumber class]]) {
        
        result.code     = YXDExtensionErrorCodeServerError;
        result.message  = @"服务器未返回code字段";
        result.error    = [NSError errorWithDomain:kYXDExtensionErrorDomain code:result.code userInfo:@{NSLocalizedDescriptionKey : result.message}];
        
        return result;
    }
    
    if ([code integerValue] != YXDExtensionErrorCodeSuccess) {

        result.code     = [code integerValue];
        result.message  = [dictionary objectForKey:kNetworkReturnMessageKey] ? : @"服务器错误";
        result.error    = [NSError errorWithDomain:kYXDExtensionErrorDomain code:result.code userInfo:@{NSLocalizedDescriptionKey : result.message}];
        
        return result;
    }
    
    result.code         = YXDExtensionErrorCodeSuccess;
    result.message      = [dictionary objectForKey:kNetworkReturnMessageKey] ? : @"成功";
    result.error        = nil;
    
    NSDictionary *data = [dictionary objectForKey:kNetworkReturnDataKey];
    
    if (data && [data isKindOfClass:[NSDictionary class]]) {
        result.data = data;
    }
    
    return result;
}

#pragma mark - List

- (NSUInteger)size {
    return [self unsignedIntegerValueForKeyPath:kNetworkReturnSizeKey];
}

- (NSUInteger)count {
    return [self unsignedIntegerValueForKeyPath:kNetworkReturnCountKey];
}

- (NSUInteger)offset {
    return [self unsignedIntegerValueForKeyPath:kNetworkReturnOffsetKey];
}

- (NSArray *)list {
    NSArray *list = [self.data objectForKey:kNetworkReturnListKey];
    if (!list || ![list isKindOfClass:[NSArray class]] || !list.count) {
        return nil;
    }
    return list;
}

- (id)model:(Class)modelClass {
    if (!self.data) {
        return nil;
    }
    return [modelClass objectWithData:self.data];
}

- (id)model:(Class)modelClass atKeyPath:(NSString *)keyPath {
    NSDictionary *model = [self.data objectForKey:keyPath];
    if (!model || ![model isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [modelClass objectWithData:model];
}

- (NSArray *)arrayOfModel:(Class)modelClass {
    if (!self.list) {
        return nil;
    }
    return [modelClass objectArrayWithDictionaryArray:self.list];
}

- (NSArray *)arrayOfModel:(Class)modelClass atKeyPath:(NSString *)keyPath {
    NSArray *list = [self.data objectForKey:keyPath];
    if (!list || ![list isKindOfClass:[NSArray class]]) {
        return nil;
    }
    return [modelClass objectArrayWithDictionaryArray:list];
}

#pragma mark - Private

- (NSUInteger)unsignedIntegerValueForKeyPath:(NSString *)keyPath {
    NSNumber *number = [self.data objectForKey:keyPath];
    if (!number || ![number isKindOfClass:[NSNumber class]]) {
        return 0;
    }
    return number.unsignedIntegerValue;
}

@end
