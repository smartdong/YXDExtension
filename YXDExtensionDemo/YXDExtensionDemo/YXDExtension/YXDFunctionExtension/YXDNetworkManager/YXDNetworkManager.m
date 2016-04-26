//
//  YXDNetworkManager.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "YXDNetworkManager.h"
#import "AFNetworking.h"
#import "YXDHUDManager.h"
#import "YXDNetworkImageObject.h"
#import "YXDNetworkResult.h"
#import "YXDLog.h"
#import "YXDExtensionDefine.h"

NSString *const kYXDNetworkLoadingStatusDefault = @"正在加载";

@interface YXDNetworkManager ()

@end

@implementation YXDNetworkManager

#pragma mark - Request

/**
 *  根据相应接口获取数据
 *
 *  @param params           数据字典
 *  @param interfaceAddress 接口地址
 *  @param success          成功处理方法
 *  @param loadingStatus    是否显示加载提示  nil则不提示
 *  @param method           网络请求方法
 */
- (void)sendRequestWithParams:(NSDictionary *)params
             interfaceAddress:(NSString *)interfaceAddress
                      success:(void (^)(YXDNetworkResult *result))success
                loadingStatus:(NSString *)loadingStatus
                       method:(NetworkManagerHttpMethod)method {
    [self sendRequestWithParams:params
               interfaceAddress:interfaceAddress
                        success:success
                        failure:nil
                  loadingStatus:loadingStatus
                         method:method];
}

/**
 *  根据相应接口获取数据
 *
 *  @param params           数据字典
 *  @param interfaceAddress 接口地址
 *  @param success          成功处理方法
 *  @param failure          网络失败处理方法
 *  @param loadingStatus    是否显示加载提示  nil则不提示
 *  @param method           网络请求方法
 */
- (void)sendRequestWithParams:(NSDictionary *)params
             interfaceAddress:(NSString *)interfaceAddress
                      success:(void (^)(YXDNetworkResult *))success
                      failure:(void (^)(NSError *))failure
                loadingStatus:(NSString *)loadingStatus
                       method:(NetworkManagerHttpMethod)method {
    [self sendRequestWithParams:params
                imagesDataArray:nil
               interfaceAddress:interfaceAddress
                        success:success
                        failure:failure
                  loadingStatus:loadingStatus
                         method:method];
}

/**
 *  根据相应接口获取数据
 *
 *  @param params           数据字典
 *  @param imagesDataArray  图片数据
 *  @param interfaceAddress 接口地址
 *  @param success          成功处理方法
 *  @param failure          网络失败处理方法
 *  @param loadingStatus    是否显示加载提示  nil则不提示
 *  @param method           网络请求方法
 */
- (void)sendRequestWithParams:(NSDictionary *)params
              imagesDataArray:(NSArray<YXDNetworkImageObject *> *)imagesDataArray
             interfaceAddress:(NSString *)interfaceAddress
                      success:(void (^)(YXDNetworkResult *))success
                      failure:(void (^)(NSError *))failure
                loadingStatus:(NSString *)loadingStatus
                       method:(NetworkManagerHttpMethod)method {
    
    if (loadingStatus) {
        [YXDHUDManager showWithStatus:loadingStatus];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    
    [self willSendRequest];
    
    NSMutableDictionary *sendParams = nil;
    
    if (params.count || self.commonParams.count) {
        sendParams = [NSMutableDictionary dictionaryWithDictionary:params];
        [sendParams addEntriesFromDictionary:self.commonParams];
    }
    
    [self.commonHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL * _Nonnull stop) {
        if ([key isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
            [self.requsetManager.requestSerializer setValue:value forHTTPHeaderField:key];
        }
    }];

    void (^constructingBodyBlock)(id<AFMultipartFormData> formData) = imagesDataArray.count?^(id<AFMultipartFormData> formData){
        for (YXDNetworkImageObject *imageObject in imagesDataArray) {
            if ([imageObject isKindOfClass:[YXDNetworkImageObject class]] && imageObject.imageData && imageObject.paramName.length) {
                [formData appendPartWithFileData:[imageObject.imageData isKindOfClass:[UIImage class]]?UIImageJPEGRepresentation(imageObject.imageData,(imageObject.quality>0)?imageObject.quality:0.1):[NSData data]
                                            name:imageObject.paramName
                                        fileName:imageObject.imageName?:@""
                                        mimeType:[NSString stringWithFormat:@"image/%@",imageObject.imageType.length?imageObject.imageType:@"png"]];
            }
        }
    }:nil;
    
    void (^successBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject) {

        if (loadingStatus) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        
        YXDNetworkResult *result = [YXDNetworkResult resultWithDictionary:responseObject];
        
        result.allHeaderFields = operation.response.allHeaderFields;
        
        if (result.code == YXDExtensionErrorCodeSuccess) {
            if (loadingStatus) {
                [YXDHUDManager dismiss];
            }
            
            DDLogInfo(@"\nSuccess : %@ \n%@",result.message,[YXDNetworkManager responseInfoDescription:operation]);
            
            [self handleSuccessWithOperation:operation result:result];
            
        } else {
            if (loadingStatus) {
                [YXDHUDManager showErrorAndAutoDismissWithTitle:result.message];
            }
            
            DDLogError(@"\nError : %@ \n%@",result.error.localizedDescription,[YXDNetworkManager responseInfoDescription:operation]);
            
            [self handleFailureWithOperation:operation result:result];
        }
        
        if (success) {
            success(result);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DDLogError(@"\nError : %@ \n%@",error.userInfo,[YXDNetworkManager responseInfoDescription:operation]);
        
        NSString *message = @"网络连接失败";
        
        if (loadingStatus) {
            [YXDHUDManager showErrorAndAutoDismissWithTitle:message];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        
        if (failure) {
            failure([NSError errorWithDomain:kYXDExtensionErrorDomain code:YXDExtensionErrorCodeLostNetwork userInfo:@{NSLocalizedDescriptionKey : message}]);
        }
    };
    
    switch (method) {
        case GET:
        {
            [self.requsetManager GET:interfaceAddress
                          parameters:sendParams
                             success:successBlock
                             failure:failureBlock];
        }
            break;
        case POST:
        {
            [self.requsetManager POST:interfaceAddress
                           parameters:sendParams
            constructingBodyWithBlock:constructingBodyBlock
                              success:successBlock
                              failure:failureBlock];
        }
            break;
        case PUT:
        {
            [self.requsetManager PUT:interfaceAddress
                          parameters:sendParams
                             success:successBlock
                             failure:failureBlock];
        }
            break;
        case DELETE:
        {
            [self.requsetManager DELETE:interfaceAddress
                             parameters:sendParams
                                success:successBlock
                                failure:failureBlock];
        }
            break;
        case PATCH:
        {
            [self.requsetManager PATCH:interfaceAddress
                            parameters:sendParams
                               success:successBlock
                               failure:failureBlock];
        }
            break;
            
        default:
            break;
    }
}

/**
 *  取消所有请求
 */
- (void)cancelAllRequest {
    [self.requsetManager.operationQueue cancelAllOperations];
}

#pragma mark - Return Data Handle

- (void)willSendRequest {
    
}

- (void)handleSuccessWithOperation:(AFHTTPRequestOperation *)operation result:(YXDNetworkResult *)result {
    
}

- (void)handleFailureWithOperation:(AFHTTPRequestOperation *)operation result:(YXDNetworkResult *)result {
    
}

#pragma mark - New

+ (instancetype)sharedInstance {
    static YXDNetworkManager *networkManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkManager = [[YXDNetworkManager new] commonInit];
    });
    
    return networkManager;
}

+ (instancetype)newManager {
    return [[YXDNetworkManager new] commonInit];
}

- (instancetype)commonInit {
    self.requsetManager = [AFHTTPRequestOperationManager new];
    self.requsetManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"application/json",@"text/plain",@"text/javascript",nil];
    self.requsetManager.requestSerializer.timeoutInterval = 15; //设置超时
    return self;
}

#pragma mark - Private

+ (NSString *)responseInfoDescription:(AFHTTPRequestOperation *)operation {
    return  [NSString stringWithFormat:
             @" ------RequestURL------: \n %@ %@, \n "
              " ------RequestBody------: \n %@, \n "
              " ------RequestHeader------:\n %@, \n "
              " ------ResponseStatus:------:\n %@, \n "
              " ------ResponseBody------:\n %@, \n "
              " ------ResponseHeader-----:\n %@ \n ",
             operation.request.URL, operation.request.HTTPMethod,
             [[NSString alloc] initWithData:[operation.request HTTPBody] encoding:(NSUTF8StringEncoding)],
             operation.request.allHTTPHeaderFields,
             @(operation.response.statusCode),
             operation.responseString,
             operation.response.allHeaderFields];
}

@end
