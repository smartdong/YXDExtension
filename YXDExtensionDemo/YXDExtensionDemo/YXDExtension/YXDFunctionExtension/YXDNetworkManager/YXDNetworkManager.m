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

static NSString *kNetworkErrorDomain            = @"com.dd";
static const CGFloat kNetworkHUDShowDuration    = 1.0f;

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
 *  @param failure          失败处理方法
 *  @param loadingStatus    是否显示加载提示  nil则不提示
 *  @param method           网络请求方法
 */
- (void)sendRequestWithParams:(NSDictionary *)params
             interfaceAddress:(NSString *)interfaceAddress
                      success:(void (^)(NSDictionary *, NSString *))success
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
 *  @param failure          失败处理方法
 *  @param loadingStatus    是否显示加载提示  nil则不提示
 *  @param method           网络请求方法
 */
- (void)sendRequestWithParams:(NSDictionary *)params
              imagesDataArray:(NSArray<YXDNetworkImageObject *> *)imagesDataArray
             interfaceAddress:(NSString *)interfaceAddress
                      success:(void (^)(NSDictionary *, NSString *))success
                      failure:(void (^)(NSError *))failure
                loadingStatus:(NSString *)loadingStatus
                       method:(NetworkManagerHttpMethod)method {
    
    if (loadingStatus) {
        [YXDHUDManager showWithStatus:loadingStatus];
    }
    
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
        
        NSLog(@"\n接口地址: %@ \n发送数据: %@ \n返回数据: %@",interfaceAddress,sendParams,responseObject);

        if ([responseObject isKindOfClass:[NSNull class]] || !responseObject || ![responseObject isKindOfClass:[NSDictionary class]]) {
            if (failure) {
                
                NSString *message = @"服务器返回数据错误";
                
                if (loadingStatus) {
                    [YXDHUDManager showErrorWithTitle:message duration:kNetworkHUDShowDuration];
                }
                
                failure([NSError errorWithDomain:kNetworkErrorDomain code:500 userInfo:@{NSLocalizedDescriptionKey : message}]);
            }
            return;
        }
        
        NSDictionary *dic_returnDic = (NSDictionary *)responseObject;
        
        NSNumber *result            = [dic_returnDic objectForKey:@"ret"]       ? : @(500);
        NSString *message           = [dic_returnDic objectForKey:@"message"]   ? : @"";
        
        if ([result intValue] == 0) {
            //成功
            
            if (loadingStatus) {
                [YXDHUDManager dismiss];
            }
            
            if (success) {
                success(dic_returnDic,message);
            }
        } else {
            //失败
            
            if (loadingStatus) {
                [YXDHUDManager showErrorWithTitle:message duration:kNetworkHUDShowDuration];
            }
            
            if (failure) {
                failure([NSError errorWithDomain:kNetworkErrorDomain code:result.integerValue userInfo:@{NSLocalizedDescriptionKey : message}]);
            }
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"\n接口地址: %@ \n发送数据: %@ \nError: %@",interfaceAddress,sendParams,error.userInfo);
        
        NSString *message = @"网络连接失败";
        
        if (loadingStatus) {
            [YXDHUDManager showErrorWithTitle:message duration:kNetworkHUDShowDuration];
        }
        
        if (failure) {
            failure([NSError errorWithDomain:kNetworkErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : message}]);
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

#pragma mark - Return Data Handle

//先备用
//- (void)handleSuccessWithOperation:(AFHTTPRequestOperation *)operation responseObject:(id)responseObject defaultHandleBlock:(dispatch_block_t)defaultHandleBlock {
//    if (defaultHandleBlock) {
//        defaultHandleBlock();
//    }
//}
//
//- (void)handleFailureWithOperation:(AFHTTPRequestOperation *)operation error:(NSError *)error defaultHandleBlock:(dispatch_block_t)defaultHandleBlock {
//    if (defaultHandleBlock) {
//        defaultHandleBlock();
//    }
//}

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

@end
