//
//  YXDNetworkManager.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "YXDNetworkManager.h"
#import "AFNetworking.h"
#import "YXDHUDManager.h"
#import "YXDNetworkUploadObject.h"
#import "YXDNetworkResult.h"
#import "YXDLog.h"
#import "YXDExtensionDefine.h"
#import "NSString+YXDExtension.h"
#import "YXDFileManager.h"

NSString *const kYXDNetworkLoadingStatusDefault = @"正在加载";

NSTimeInterval const kYXDNetworkRequestTimeoutIntervalDefault = 15.;
NSTimeInterval const kYXDNetworkUploadTimeoutIntervalDefault = 600.; // Or 0. ?

@implementation YXDNetworkRequestOperation

@end

@interface YXDNetworkManager ()

@end

@implementation YXDNetworkManager

#pragma mark - Request

- (YXDNetworkRequestOperation *)sendRequestWithParams:(NSDictionary *)params
                                     interfaceAddress:(NSString *)interfaceAddress
                                           completion:(void (^)(YXDNetworkResult *result))completion
                                               method:(NetworkManagerHttpMethod)method {
    return [self sendRequestWithParams:params
                      interfaceAddress:interfaceAddress
                            completion:completion
                         loadingStatus:nil
                                method:method];
}

- (YXDNetworkRequestOperation *)sendRequestWithParams:(NSDictionary *)params
                                     interfaceAddress:(NSString *)interfaceAddress
                                           completion:(void (^)(YXDNetworkResult *result))completion
                                        loadingStatus:(NSString *)loadingStatus
                                               method:(NetworkManagerHttpMethod)method {
    return [self sendRequestWithParams:params
                      interfaceAddress:interfaceAddress
                            completion:completion
                        networkFailure:nil
                         loadingStatus:loadingStatus
                                method:method];
}

- (YXDNetworkRequestOperation *)sendRequestWithParams:(NSDictionary *)params
                                     interfaceAddress:(NSString *)interfaceAddress
                                           completion:(void (^)(YXDNetworkResult *result))completion
                                       networkFailure:(void (^)(NSError *error))networkFailure
                                        loadingStatus:(NSString *)loadingStatus
                                               method:(NetworkManagerHttpMethod)method {
    return [self sendRequestWithParams:params
                    uploadObjectsArray:nil
                      interfaceAddress:interfaceAddress
                            completion:completion
                        networkFailure:networkFailure
                         loadingStatus:loadingStatus
                        uploadProgress:nil
                       timeoutInterval:kYXDNetworkRequestTimeoutIntervalDefault
                                method:method];
}

- (YXDNetworkRequestOperation *)sendRequestWithParams:(NSDictionary *)params
                                   uploadObjectsArray:(NSArray<YXDNetworkUploadObject *> *)uploadObjectsArray
                                     interfaceAddress:(NSString *)interfaceAddress
                                           completion:(void (^)(YXDNetworkResult *result))completion
                                       networkFailure:(void (^)(NSError *error))networkFailure
                                        loadingStatus:(NSString *)loadingStatus
                                       uploadProgress:(YXDNetworkManagerUploadProgressChangedBlock)uploadProgress
                                      timeoutInterval:(NSTimeInterval)timeoutInterval
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
            
            [self handleSuccessWithHTTPRequestOperation:(YXDNetworkRequestOperation *)operation result:result];
            
        } else {
            if (loadingStatus) {
                [YXDHUDManager showErrorAndAutoDismissWithTitle:result.message];
            }
            
            DDLogError(@"\nError : %@ \n%@",result.error.localizedDescription,[YXDNetworkManager responseInfoDescription:operation]);
            
            [self handleFailureWithHTTPRequestOperation:(YXDNetworkRequestOperation *)operation result:result];
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
    
    YXDNetworkRequestOperation *requestOperation = nil;
    
    if (uploadObjectsArray.count) {
        
        if (timeoutInterval >= 0) {
            self.requestManager.requestSerializer.timeoutInterval = timeoutInterval;
        } else {
            self.requestManager.requestSerializer.timeoutInterval = kYXDNetworkUploadTimeoutIntervalDefault;
        }
        
        void (^constructingBodyBlock)(id<AFMultipartFormData> formData) = uploadObjectsArray.count?^(id<AFMultipartFormData> formData){
            for (YXDNetworkUploadObject *uploadObject in uploadObjectsArray) {
                if ([uploadObject isKindOfClass:[YXDNetworkUploadObject class]] && uploadObject.paramName.length && uploadObject.file) {
                    
                    NSData *data = nil;
                    
                    if ([uploadObject.file isKindOfClass:[NSData class]]) {
                        data = uploadObject.file;
                    } else if ([uploadObject.file isKindOfClass:[UIImage class]]) {
                        data = UIImageJPEGRepresentation(uploadObject.file,uploadObject.imageQuality);
                    } else {
                        continue;
                    }
                    
                    [formData appendPartWithFileData:data
                                                name:uploadObject.paramName
                                            fileName:uploadObject.fileName
                                            mimeType:uploadObject.fileType];
                } else {
                    DDLogInfo(@"上传数据格式错误");
                }
            }
        }:nil;
        
        NSMutableURLRequest *request = [self.requestManager.requestSerializer multipartFormRequestWithMethod:@"POST"
                                                                                                   URLString:interfaceAddress
                                                                                                  parameters:sendParams
                                                                                   constructingBodyWithBlock:constructingBodyBlock
                                                                                                       error:nil];
        
        requestOperation = (YXDNetworkRequestOperation *)[self.requestManager HTTPRequestOperationWithRequest:request
                                                                                                      success:successBlock
                                                                                                      failure:failureBlock];
        
        if (uploadProgress) {
            [requestOperation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                                       long long totalBytesWritten,
                                                       long long totalBytesExpectedToWrite) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    uploadProgress((CGFloat)(totalBytesWritten/(double)totalBytesExpectedToWrite));
                });
            }];
        }
        
        [requestOperation start];
        
    } else {
        
        if (timeoutInterval >= 0) {
            self.requestManager.requestSerializer.timeoutInterval = timeoutInterval;
        } else {
            self.requestManager.requestSerializer.timeoutInterval = kYXDNetworkRequestTimeoutIntervalDefault;
        }
        
        switch (method) {
            case GET:
            {
                requestOperation = (YXDNetworkRequestOperation *)[self.requestManager GET:interfaceAddress
                                                                               parameters:sendParams
                                                                                  success:successBlock
                                                                                  failure:failureBlock];
            }
                break;
            case POST:
            {
                requestOperation = (YXDNetworkRequestOperation *)[self.requestManager POST:interfaceAddress
                                                                                parameters:sendParams
                                                                 constructingBodyWithBlock:nil
                                                                                   success:successBlock
                                                                                   failure:failureBlock];
            }
                break;
            case PUT:
            {
                requestOperation = (YXDNetworkRequestOperation *)[self.requestManager PUT:interfaceAddress
                                                                               parameters:sendParams
                                                                                  success:successBlock
                                                                                  failure:failureBlock];
            }
                break;
            case DELETE:
            {
                requestOperation = (YXDNetworkRequestOperation *)[self.requestManager DELETE:interfaceAddress
                                                                                  parameters:sendParams
                                                                                     success:successBlock
                                                                                     failure:failureBlock];
            }
                break;
            case PATCH:
            {
                requestOperation = (YXDNetworkRequestOperation *)[self.requestManager PATCH:interfaceAddress
                                                                                 parameters:sendParams
                                                                                    success:successBlock
                                                                                    failure:failureBlock];
            }
                break;
                
            default:
                break;
        }
    }
    
    return requestOperation;
}

#pragma mark - Upload & Download

//- (NSURLSessionUploadTask *)uploadWithURL:(NSString *)URL
//                                     data:(NSData *)data
//                          currentProgress:(YXDNetworkManagerUploadProgressChangedBlock)currentProgress
//                               completion:(void (^)(YXDNetworkResult *result))completion {
//    
//    NSURLSessionUploadTask *ut = [self.tasksManager uploadTaskWithRequest:URL.URLRequest
//                                                                 fromData:data
//                                                                 progress:nil
//                                                        completionHandler:^(NSURLResponse * _Nonnull response, id  _Nonnull responseObject, NSError * _Nonnull error) {
//
//                                                        }];
//
//
//    [self.tasksManager setTaskDidSendBodyDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
//        if (currentProgress && (task == ut)) {
//            __block double progress = bytesSent/(double)totalBytesSent;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (progress < 0) {
//                    progress = 0;
//                } else if (progress > 1) {
//                    progress = 1;
//                }
//
//                currentProgress(progress);
//            });
//        }
//    }];
//
//    [ut resume];
//    
//    return ut;
//}

- (NSURLSessionDownloadTask *)downloadWithURL:(NSString *)URL
                                   completion:(YXDNetworkManagerDownloadCompletionBlock)completion {
    return [self downloadWithURL:URL
                       directory:nil
                      completion:completion];
}

- (NSURLSessionDownloadTask *)downloadWithURL:(NSString *)URL
                                    directory:(NSURL *)directory
                                   completion:(YXDNetworkManagerDownloadCompletionBlock)completion {
    return [self downloadWithURL:URL
                       directory:directory
                   loadingStatus:nil
                      completion:completion];
}

- (NSURLSessionDownloadTask *)downloadWithURL:(NSString *)URL
                                    directory:(NSURL *)directory
                                loadingStatus:(NSString *)loadingStatus
                                   completion:(YXDNetworkManagerDownloadCompletionBlock)completion {
    
    if (!URL.length) {
        if (completion) {
            completion(nil,[NSError errorWithDomain:kYXDExtensionErrorDomain code:YXDExtensionErrorCodeInputError userInfo:@{NSLocalizedDescriptionKey : @"下载URL为空"}]);
        }
        return nil;
    }
    
    NSURLSessionDownloadTask *dt = [self.tasksManager downloadTaskWithRequest:URL.URLRequest
                                                                     progress:nil
                                                                  destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                                                      return [YXDNetworkManager downloadDestinationWithDirectory:directory response:response];
                                                                  }
                                                            completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                                                if (loadingStatus && (error.code == YXDExtensionErrorCodeCancelled)) {
                                                                    [YXDHUDManager showSuccessAndAutoDismissWithTitle:@"下载已取消"];
                                                                }
                                                                
                                                                if (completion) {
                                                                    completion(filePath,error);
                                                                }
                                                            }];
    
    if (loadingStatus) {
        [self.tasksManager setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
            if (downloadTask == dt) { //同时只显示一个进度
                double progress = totalBytesWritten/(double)totalBytesExpectedToWrite;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (progress < 1) {
                        [YXDHUDManager showProgress:progress status:loadingStatus];
                    } else {
                        [YXDHUDManager showSuccessAndAutoDismissWithTitle:@"下载成功"];
                    }
                });
            }
        }];
    }
    
    [dt resume];
    
    return dt;
}

- (NSArray<NSURLSessionDownloadTask *> *)downloadWithURLArray:(NSArray<NSString *> *)URLArray
                                                    directory:(NSURL *)directory
                                                   completion:(YXDNetworkManagerMultiFilesDownloadCompletionBlock)completion {
    if (!URLArray.count) {
        if (completion) {
            completion(nil,[NSError errorWithDomain:kYXDExtensionErrorDomain code:YXDExtensionErrorCodeInputError userInfo:@{NSLocalizedDescriptionKey : @"下载URL为空"}]);
        }
        return nil;
    }
    
    //下载队列
    NSMutableArray *tasks = [NSMutableArray array];
    //文件地址
    NSMutableArray *filePaths = [NSMutableArray array];
    //创建下载任务
    for (NSString *URL in URLArray) {
        if (!URL.length) {
            continue;
        }
        
        NSURLSessionDownloadTask *dt = [self.tasksManager downloadTaskWithRequest:URL.URLRequest
                                                                         progress:nil
                                                                      destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                                                          return [YXDNetworkManager downloadDestinationWithDirectory:directory response:response];
                                                                      }
                                                                completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                                                    if (!error && filePath) {
                                                                        [filePaths addObject:filePath];
                                                                    }
                                                                }];
        //将下载任务添加到队列
        [tasks addObject:dt];
    }
    
    if (!tasks.count) {
        completion(nil,[NSError errorWithDomain:kYXDExtensionErrorDomain code:YXDExtensionErrorCodeInputError userInfo:@{NSLocalizedDescriptionKey : @"没有有效的下载URL"}]);
        return nil;
    }
    
    //下载完成 从队列中移除
    [self.tasksManager setTaskDidCompleteBlock:^(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSError * _Nonnull error) {
        if ([tasks containsObject:task]) {
            [tasks removeObject:task];
        }
        
        //如果当前没有下载任务 则表示下载全部完成
        if (!tasks.count) {
            if (error.code == YXDExtensionErrorCodeCancelled) {
                completion(filePaths,[NSError errorWithDomain:kYXDExtensionErrorDomain code:YXDExtensionErrorCodeCancelled userInfo:@{NSLocalizedDescriptionKey : @"用户下载取消"}]);
            } else {
                completion(filePaths,error);
            }
        }
    }];
    
    //开始下载
    for (NSURLSessionDownloadTask *dt in tasks) {
        [dt resume];
    }
    
    return tasks;
}

//获取下载目录 若目录不存在则创建目录
+ (NSURL *)downloadDestinationWithDirectory:(NSURL *)directory response:(NSURLResponse *)response {
    NSURL *targetURL = directory?:[[[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                          inDomain:NSUserDomainMask
                                                                 appropriateForURL:nil
                                                                            create:NO
                                                                             error:nil] URLByAppendingPathComponent:@"Downloads"];
    if (![YXDFileManager isDirectoryItemAtPath:targetURL.relativePath]) {
        [YXDFileManager createDirectoriesForPath:targetURL.relativePath];
    }
    return [targetURL URLByAppendingPathComponent:[response suggestedFilename]];
}

#pragma mark - Cancel

- (void)cancelAllRequest {
    [self.requestManager.operationQueue cancelAllOperations];
}

- (void)cancelAllTasks {
    for (NSURLSessionTask *task in self.tasksManager.tasks) {
        [task cancel];
    }
}

- (void)cancelAllRequestAndTasks {
    [self cancelAllRequest];
    [self cancelAllTasks];
}

#pragma mark - Return Data Handle

- (void)willSendHTTPRequest {
    
}

- (void)handleSuccessWithHTTPRequestOperation:(YXDNetworkRequestOperation *)operation result:(YXDNetworkResult *)result {
    
}

- (void)handleFailureWithHTTPRequestOperation:(YXDNetworkRequestOperation *)operation result:(YXDNetworkResult *)result {
    
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

#pragma mark - Reachability Status

+ (void)startMonitoringReachabilityStatus {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+ (void)stopMonitoringReachabilityStatus {
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

+ (NetworkManagerReachabilityStatus)currentReachabilityStatus {
    return (NetworkManagerReachabilityStatus)([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus);
}

+ (void)setReachabilityStatusChangeBlock:(nullable void (^)(NetworkManagerReachabilityStatus status))block {
    if (block) {
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            block((NetworkManagerReachabilityStatus)status);
        }];
    }
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
