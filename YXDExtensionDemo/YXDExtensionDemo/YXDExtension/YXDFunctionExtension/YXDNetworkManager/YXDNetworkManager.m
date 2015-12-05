//
//  YXDNetworkManager.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "YXDNetworkManager.h"
#import "AFNetworking.h"
#import "YXDHUDManager.h"

#define Network_Manager_Instance  ((YXDNetworkManager *)[YXDNetworkManager sharedInstance])

@interface YXDNetworkManager ()

@property (nonatomic, strong) AFHTTPRequestOperationManager  *requsetManager;

@end

@implementation YXDNetworkManager

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
+ (void)loadDataFromServerWithParams:(NSDictionary *)params
                    interfaceAddress:(NSString *)interfaceAddress
                             success:(void (^)(NSDictionary *data, NSString *msg))success
                             failure:(void (^)(NSError *error))failure
                       loadingStatus:(NSString *)loadingStatus
                              method:(NetworkManagerHttpMethod)method {
    [self loadDataFromServerWithParams:params
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
 *  @param imagesDataArray  图片数据数组     paramName:参数名  imageName:图片名  imageData:图片数据
 *  @param interfaceAddress 接口地址
 *  @param success          成功处理方法
 *  @param failure          失败处理方法
 *  @param loadingStatus    是否显示加载提示  nil则不提示
 *  @param method           网络请求方法
 */
+ (void)loadDataFromServerWithParams:(NSDictionary *)params
                     imagesDataArray:(NSArray *)imagesDataArray
                    interfaceAddress:(NSString *)interfaceAddress
                             success:(void (^)(NSDictionary *data, NSString *msg))success
                             failure:(void (^)(NSError *error))failure
                       loadingStatus:(NSString *)loadingStatus
                              method:(NetworkManagerHttpMethod)method {
    
    if (loadingStatus) {
        [YXDHUDManager showWithStatus:loadingStatus];
    }
    
    NSLog(@"\n接口地址: %@ \n发送数据: %@",interfaceAddress,params);
    
    void (^constructingBodyBlock)(id<AFMultipartFormData> formData) = ^(id<AFMultipartFormData> formData){
        for (NSDictionary *imageDic in imagesDataArray) {
            
            NSLog(@"\n图片数据: %@",imageDic);
            
            NSString *paramName = [imageDic objectForKey:Define_Image_Dictionary_paramName];
            NSString *imageName = [imageDic objectForKey:Define_Image_Dictionary_imageName];
            UIImage *image      = [imageDic objectForKey:Define_Image_Dictionary_imageData];
            
            if (image) {
                [formData appendPartWithFileData:[image isKindOfClass:[UIImage class]]?UIImageJPEGRepresentation(image,0.1):[NSData data]
                                            name:paramName
                                        fileName:imageName
                                        mimeType:@"image/png"];
            }
        }
    };
    
    void (^successBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"\n返回数据: %@",responseObject);

        if ([responseObject isKindOfClass:[NSNull class]] || !responseObject || ![responseObject isKindOfClass:[NSDictionary class]]) {
            if (failure) {
                failure([NSError errorWithDomain:@"com.jingchen" code:0 userInfo:@{NSLocalizedDescriptionKey : @"服务器返回数据错误"}]);
            }
            return;
        }
        
        NSDictionary *dic_returnDic = (NSDictionary *)responseObject;
        
        NSNumber *result            = [dic_returnDic objectForKey:@"ret"];
        NSString *message           = [dic_returnDic objectForKey:@"message"];
        
        if (result && [result intValue] == 0) {
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
                [YXDHUDManager showErrorWithTitle:message duration:kHUDShowDuration];
            }
            
            if (failure) {
                failure([NSError errorWithDomain:@"com.jingchen" code:result.integerValue userInfo:@{NSLocalizedDescriptionKey : message}]);
            }
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error: %@",error.userInfo);
        
        if (loadingStatus) {
            [YXDHUDManager showErrorWithTitle:@"网络连接失败" duration:kHUDShowDuration];
        }
        
        if (failure) {
            failure(error);
        }
    };
    
    switch (method) {
        case GET:
        {
            [Network_Manager_Instance.requsetManager GET:interfaceAddress
                                              parameters:params
                                                 success:successBlock
                                                 failure:failureBlock];
        }
            break;
        case POST:
        {
            [Network_Manager_Instance.requsetManager POST:interfaceAddress
                                               parameters:params
                                constructingBodyWithBlock:constructingBodyBlock
                                                  success:successBlock
                                                  failure:failureBlock];
        }
            break;
        case PUT:
        {
            [Network_Manager_Instance.requsetManager PUT:interfaceAddress
                                              parameters:params
                                                 success:successBlock
                                                 failure:failureBlock];
        }
            break;
        case DELETE:
        {
            [Network_Manager_Instance.requsetManager DELETE:interfaceAddress
                                                 parameters:params
                                                    success:successBlock
                                                    failure:failureBlock];
        }
            break;
        case PATCH:
        {
            [Network_Manager_Instance.requsetManager PATCH:interfaceAddress
                                                parameters:params
                                                   success:successBlock
                                                   failure:failureBlock];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Init

+(instancetype)sharedInstance {
    static YXDNetworkManager *networkManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkManager = [[YXDNetworkManager new] commonInit];
    });
    
    return networkManager;
}

- (instancetype) commonInit {
    self.requsetManager = [AFHTTPRequestOperationManager new];
    self.requsetManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"application/json",@"text/plain",@"text/javascript",nil];
    self.requsetManager.requestSerializer.timeoutInterval = 15; //设置超时
    return self;
}

@end
