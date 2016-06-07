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

- (void)sendRequestWithParams:(NSDictionary *)params
             interfaceAddress:(NSString *)interfaceAddress
                   completion:(void (^)(YXDNetworkResult *result))completion
                       method:(NetworkManagerHttpMethod)method {
    [self sendRequestWithParams:params
               interfaceAddress:interfaceAddress
                     completion:completion
                  loadingStatus:nil
                         method:method];
}

- (void)sendRequestWithParams:(NSDictionary *)params
             interfaceAddress:(NSString *)interfaceAddress
                   completion:(void (^)(YXDNetworkResult *result))completion
                loadingStatus:(NSString *)loadingStatus
                       method:(NetworkManagerHttpMethod)method {
    [self sendRequestWithParams:params
               interfaceAddress:interfaceAddress
                     completion:completion
                 networkFailure:nil
                  loadingStatus:loadingStatus
                         method:method];
}

- (void)sendRequestWithParams:(NSDictionary *)params
             interfaceAddress:(NSString *)interfaceAddress
                   completion:(void (^)(YXDNetworkResult *result))completion
               networkFailure:(void (^)(NSError *error))networkFailure
                loadingStatus:(NSString *)loadingStatus
                       method:(NetworkManagerHttpMethod)method {
    [self sendRequestWithParams:params
                imagesDataArray:nil
               interfaceAddress:interfaceAddress
                     completion:completion
                 networkFailure:networkFailure
                  loadingStatus:loadingStatus
                         method:method];
}

- (void)sendRequestWithParams:(NSDictionary *)params
              imagesDataArray:(NSArray<YXDNetworkImageObject *> *)imagesDataArray
             interfaceAddress:(NSString *)interfaceAddress
                   completion:(void (^)(YXDNetworkResult *result))completion
               networkFailure:(void (^)(NSError *error))networkFailure
                loadingStatus:(NSString *)loadingStatus
                       method:(NetworkManagerHttpMethod)method {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    if (loadingStatus) {
        [YXDHUDManager showWithStatus:loadingStatus];
    }
    
    [self willSendHTTPRequest];
    
    NSMutableDictionary *sendParams = nil;
    
    if (params.count || self.commonParams.count) {
        sendParams = [NSMutableDictionary dictionaryWithDictionary:params];
        [sendParams addEntriesFromDictionary:self.commonParams];
    }
    
    [self.commonHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL * _Nonnull stop) {
        if ([key isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
            [self.requestManager.requestSerializer setValue:value forHTTPHeaderField:key];
        }
    }];

    void (^constructingBodyBlock)(id<AFMultipartFormData> formData) = imagesDataArray.count?^(id<AFMultipartFormData> formData){
        for (YXDNetworkImageObject *imageObject in imagesDataArray) {
            if ([imageObject isKindOfClass:[YXDNetworkImageObject class]] && imageObject.paramName.length && [imageObject.imageData isKindOfClass:[UIImage class]]) {
                [formData appendPartWithFileData:UIImageJPEGRepresentation(imageObject.imageData,(imageObject.quality>0)?imageObject.quality:0.1)
                                            name:imageObject.paramName
                                        fileName:imageObject.imageName?:@""
                                        mimeType:[NSString stringWithFormat:@"image/%@",imageObject.imageType.length?imageObject.imageType:@"png"]];
            } else {
                DDLogInfo(@"图片上传数据有误");
            }
        }
    }:nil;
    
    void (^successBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject) {

        if (!self.requestManager.operationQueue.operationCount) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        
        YXDNetworkResult *result = [YXDNetworkResult resultWithDictionary:responseObject];
        
        result.allHeaderFields = operation.response.allHeaderFields;
        
        if (result.code == YXDExtensionErrorCodeSuccess) {
            if (loadingStatus) {
                [YXDHUDManager dismiss];
            }
            
            DDLogInfo(@"\nSuccess : %@ \n%@",result.message,[YXDNetworkManager responseInfoDescription:operation]);
            
            [self handleSuccessWithHTTPRequestOperation:operation result:result];
            
        } else {
            if (loadingStatus) {
                [YXDHUDManager showErrorAndAutoDismissWithTitle:result.message];
            }
            
            DDLogError(@"\nError : %@ \n%@",result.error.localizedDescription,[YXDNetworkManager responseInfoDescription:operation]);
            
            [self handleFailureWithHTTPRequestOperation:operation result:result];
        }
        
        if (completion) {
            completion(result);
        }
    };
    
    void (^failureBlock)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (!self.requestManager.operationQueue.operationCount) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        
        DDLogError(@"\nError : %@ \n%@",error.userInfo,[YXDNetworkManager responseInfoDescription:operation]);
        
        NSString *message = @"网络连接失败";
        
        if (loadingStatus) {
            [YXDHUDManager showErrorAndAutoDismissWithTitle:message];
        }
        
        if (networkFailure) {
            networkFailure([NSError errorWithDomain:kYXDExtensionErrorDomain code:YXDExtensionErrorCodeLostNetwork userInfo:@{NSLocalizedDescriptionKey : message}]);
        }
    };
    
    switch (method) {
        case GET:
        {
            [self.requestManager GET:interfaceAddress
                          parameters:sendParams
                             success:successBlock
                             failure:failureBlock];
        }
            break;
        case POST:
        {
            [self.requestManager POST:interfaceAddress
                           parameters:sendParams
            constructingBodyWithBlock:constructingBodyBlock
                              success:successBlock
                              failure:failureBlock];
        }
            break;
        case PUT:
        {
            [self.requestManager PUT:interfaceAddress
                          parameters:sendParams
                             success:successBlock
                             failure:failureBlock];
        }
            break;
        case DELETE:
        {
            [self.requestManager DELETE:interfaceAddress
                             parameters:sendParams
                                success:successBlock
                                failure:failureBlock];
        }
            break;
        case PATCH:
        {
            [self.requestManager PATCH:interfaceAddress
                            parameters:sendParams
                               success:successBlock
                               failure:failureBlock];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Upload & Download

//- (void)downTest {
//    NSURL *URL = [NSURL URLWithString:@"http://porn.yangxudong.me/resource/imgs/giftest.gif"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    NSURLSessionDownloadTask *downloadTask = [self.tasksManager downloadTaskWithRequest:request
//                                                                               progress:nil
//                                                                            destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//                                                                                NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
//                                                                                                                                                      inDomain:NSUserDomainMask
//                                                                                                                                             appropriateForURL:nil
//                                                                                                                                                        create:NO
//                                                                                                                                                         error:nil];
//                                                                                return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
//                                                                            }
//                                                                      completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//                                                                          NSLog(@"File downloaded to: %@", filePath);
//                                                                      }];
//    
//    [self.tasksManager setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
//        
//        double progress = totalBytesWritten/(double)totalBytesExpectedToWrite;
//        
//        NSLog(@"Progress... %.2f",progress);
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (progress < 1) {
//                [YXDHUDManager showProgress:progress status:@"正在下载"];
//            } else {
//                [YXDHUDManager showSuccessWithTitle:@"下载成功" duration:1];
//            }
//        });
//
//    }];
//    
//    [downloadTask resume];
//}

#pragma mark - Cancel

- (void)cancelAllRequest {
    [self.requestManager.operationQueue cancelAllOperations];
}

- (void)cancelAllTasks {
    [self.tasksManager.operationQueue cancelAllOperations];
}

- (void)cancelAllRequestAndTasks {
    [self cancelAllRequest];
    [self cancelAllTasks];
}

#pragma mark - Return Data Handle

- (void)willSendHTTPRequest {
    
}

- (void)handleSuccessWithHTTPRequestOperation:(AFHTTPRequestOperation *)operation result:(YXDNetworkResult *)result {
    
}

- (void)handleFailureWithHTTPRequestOperation:(AFHTTPRequestOperation *)operation result:(YXDNetworkResult *)result {
    
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
    self.requestManager = [AFHTTPRequestOperationManager new];
    self.requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"application/json",@"text/plain",@"text/javascript",nil];
    self.requestManager.requestSerializer.timeoutInterval = 15; //设置超时
    return self;
}

- (AFURLSessionManager *)tasksManager {
    if (_tasksManager) {
        return _tasksManager;
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _tasksManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    return _tasksManager;
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
