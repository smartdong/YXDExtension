//
//  YXDNetworkResult.h
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *kNetworkReturnCodeKey      = @"code";
static NSString *kNetworkReturnMessageKey   = @"msg";
static NSString *kNetworkReturnDataKey      = @"data";
static NSString *kNetworkReturnListKey      = @"list";
static NSString *kNetworkReturnSizeKey      = @"size";
static NSString *kNetworkReturnCountKey     = @"count";
static NSString *kNetworkReturnOffsetKey    = @"offset";

@interface YXDNetworkResult : NSObject

//如果不等于0 则说明返回错误
@property (nonatomic, readonly, assign) NSInteger code;

//返回信息
@property (nonatomic, readonly, copy) NSString *message;

//返回错误
@property (nonatomic, readonly, strong) NSError *error;

//服务器返回的 header
@property (nonatomic, strong) NSDictionary *allHeaderFields;

+ (instancetype)resultWithError:(NSError *)error;

+ (instancetype)resultWithCode:(NSInteger)code message:(NSString *)message;

+ (instancetype)resultWithDictionary:(NSDictionary *)dictionary;

#pragma mark - Data || List

@property (nonatomic, readonly, strong) NSDictionary *data;

@property (nonatomic, readonly, assign) NSUInteger size;
@property (nonatomic, readonly, assign) NSUInteger count;
@property (nonatomic, readonly, assign) NSUInteger offset;
@property (nonatomic, readonly, strong) NSArray *list;

- (id)model:(Class)modelClass;
- (id)model:(Class)modelClass atKeyPath:(NSString *)keyPath;

- (NSArray *)arrayOfModel:(Class)modelClass;
- (NSArray *)arrayOfModel:(Class)modelClass atKeyPath:(NSString *)keyPath;

@end
