//
//  YXDNetworkManager.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NetworkManagerInstance  [YXDNetworkManager sharedInstance]

extern NSString *const kYXDNetworkLoadingStatusDefault;

typedef NS_ENUM(NSInteger, NetworkManagerHttpMethod) {
    GET = 0,
    POST,
    PUT,
    DELETE,
    PATCH,
};

@class AFHTTPRequestOperationManager;
@class AFHTTPRequestOperation;
@class YXDNetworkImageObject;
@class YXDNetworkResult;

@interface YXDNetworkManager : NSObject

@property (nonatomic, strong) NSMutableDictionary *commonParams;
@property (nonatomic, strong) NSMutableDictionary *commonHeaders;

@property (nonatomic, strong) AFHTTPRequestOperationManager *requestManager;    //普通请求

#pragma mark - Request

/**
 *  根据相应接口获取数据
 *
 *  @param params           数据字典
 *  @param interfaceAddress 接口地址
 *  @param completion       接口返回处理方法
 *  @param method           网络请求方法
 */
- (void)sendRequestWithParams:(NSDictionary *)params
             interfaceAddress:(NSString *)interfaceAddress
                   completion:(void (^)(YXDNetworkResult *result))completion
                       method:(NetworkManagerHttpMethod)method;

/**
 *  根据相应接口获取数据
 *
 *  @param params           数据字典
 *  @param interfaceAddress 接口地址
 *  @param completion       接口返回处理方法
 *  @param loadingStatus    是否显示加载提示  nil则不提示
 *  @param method           网络请求方法
 */
- (void)sendRequestWithParams:(NSDictionary *)params
             interfaceAddress:(NSString *)interfaceAddress
                   completion:(void (^)(YXDNetworkResult *result))completion
                loadingStatus:(NSString *)loadingStatus
                       method:(NetworkManagerHttpMethod)method;

/**
 *  根据相应接口获取数据
 *
 *  @param params           数据字典
 *  @param interfaceAddress 接口地址
 *  @param completion       接口返回处理方法
 *  @param networkFailure   网络失败处理方法
 *  @param loadingStatus    是否显示加载提示  nil则不提示
 *  @param method           网络请求方法
 */
- (void)sendRequestWithParams:(NSDictionary *)params
             interfaceAddress:(NSString *)interfaceAddress
                   completion:(void (^)(YXDNetworkResult *result))completion
               networkFailure:(void (^)(NSError *error))networkFailure
                loadingStatus:(NSString *)loadingStatus
                       method:(NetworkManagerHttpMethod)method;

/**
*  根据相应接口获取数据
*
*  @param params           数据字典
*  @param imagesDataArray  图片数据（只有在 POST 方法下才生效）
*  @param interfaceAddress 接口地址
*  @param completion       接口返回处理方法
*  @param networkFailure   网络失败处理方法
*  @param loadingStatus    是否显示加载提示  nil则不提示
*  @param method           网络请求方法
*/
- (void)sendRequestWithParams:(NSDictionary *)params
              imagesDataArray:(NSArray<YXDNetworkImageObject *> *)imagesDataArray
             interfaceAddress:(NSString *)interfaceAddress
                   completion:(void (^)(YXDNetworkResult *result))completion
               networkFailure:(void (^)(NSError *error))networkFailure
                loadingStatus:(NSString *)loadingStatus
                       method:(NetworkManagerHttpMethod)method;

/**
 *  取消所有请求
 */
- (void)cancelAllRequest;

#pragma mark - Return Data Handle

- (void)willSendRequest;
- (void)handleSuccessWithOperation:(AFHTTPRequestOperation *)operation result:(YXDNetworkResult *)result;
- (void)handleFailureWithOperation:(AFHTTPRequestOperation *)operation result:(YXDNetworkResult *)result;

#pragma mark - New

/**
 *  默认全局的 manager
 */
+ (instancetype)sharedInstance;

/**
 *  新建一个 manager
 */
+ (instancetype)newManager;

@end
