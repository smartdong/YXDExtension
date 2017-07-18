//
//  YXDNetworkManager.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "YXDNetworkManager.h"
#import "YXDMacroExtensionHeader.h"
#import "AFNetworking.h"
#import "YXDHUDManager.h"
#import "YXDNetworkUploadObject.h"
#import "YXDNetworkResult.h"
#import "YXDLog.h"
#import "YXDExtensionDefine.h"
#import "NSString+YXDExtension.h"
#import "YXDFileManager.h"
#import "NSTimer+YXDExtension.h"
#import "NSData+YXDExtension.h"
#import "NSDictionary+YXDExtension.h"

NSString *const kYXDNetworkLoadingStatusDefault = @"正在加载";

NSTimeInterval const kYXDNetworkRequestTimeoutIntervalDefault   = 15.;
NSTimeInterval const kYXDNetworkUploadTimeoutIntervalDefault    = 60 * 60; // Or 0. ?

typedef void (^YXDNetworkManagerTaskDidCompleteBlock)(NSURLSession *session, NSURLSessionTask *task, NSError *error);

@implementation YXDNetworkSessionDataTask

@end

@implementation YXDNetworkSessionUploadTask

@end

@implementation YXDNetworkSessionDownloadTask

@end

@interface YXDNetworkManager ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, YXDNetworkManagerTaskDidCompleteBlock> *taskDidCompleteBlocksMap;

@end

@implementation YXDNetworkManager

#pragma mark - Request

- (YXDNetworkSessionDataTask *)sendRequestWithParams:(NSDictionary *)params
                                    interfaceAddress:(NSString *)interfaceAddress
                                          completion:(void (^)(YXDNetworkResult *result))completion
                                              method:(NetworkManagerHttpMethod)method {
    return [self sendRequestWithParams:params
                      interfaceAddress:interfaceAddress
                            completion:completion
                         loadingStatus:nil
                                method:method];
}

- (YXDNetworkSessionDataTask *)sendRequestWithParams:(NSDictionary *)params
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

- (YXDNetworkSessionDataTask *)sendRequestWithParams:(NSDictionary *)params
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

- (YXDNetworkSessionDataTask *)sendRequestWithParams:(NSDictionary *)params
                                  uploadObjectsArray:(NSArray<YXDNetworkUploadObject *> *)uploadObjectsArray
                                    interfaceAddress:(NSString *)interfaceAddress
                                          completion:(void (^)(YXDNetworkResult *result))completion
                                      networkFailure:(void (^)(NSError *error))networkFailure
                                       loadingStatus:(NSString *)loadingStatus
                                      uploadProgress:(YXDNetworkManagerProgressChangedBlock)uploadProgress
                                     timeoutInterval:(NSTimeInterval)timeoutInterval
                                              method:(NetworkManagerHttpMethod)method {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
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
            [self.requestManager.requestSerializer setValue:value forHTTPHeaderField:key];
        }
    }];
    
    [self willSendRequestTaskWithParams:sendParams];
    
    YXDNetworkSessionDataTask *requestTask = [[YXDNetworkSessionDataTask alloc] init];
    
    void (^successBlock)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
        
        if (!self.requestManager.operationQueue.operationCount) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        
        YXDNetworkResult *result = [YXDNetworkResult resultWithDictionary:responseObject];
        
        result.allHeaderFields = ((NSHTTPURLResponse *)task.response).allHeaderFields;
        
        if (result.code == YXDExtensionErrorCodeSuccess) {
            if (loadingStatus) {
                [YXDHUDManager dismiss];
            }
            
            DDLogInfo(@"\nSuccess : %@ \n%@",result.message,[YXDNetworkManager responseInfoDescription:task params:sendParams responseObject:responseObject]);
            
            [self handleSuccessWithTask:requestTask result:result];
            
        } else {
            if (loadingStatus) {
                [YXDHUDManager showErrorAndAutoDismissWithTitle:result.message];
            }
            
            DDLogError(@"\nError : %@ \n%@",result.error.localizedDescription,[YXDNetworkManager responseInfoDescription:task params:sendParams responseObject:responseObject]);
            
            [self handleFailureWithTask:requestTask result:result];
        }
        
        if (completion) {
            completion(result);
        }
    };
    
    void (^failureBlock)(NSURLSessionTask *task, NSError *error) = ^(NSURLSessionTask *task, NSError *error) {
        
        if (!self.requestManager.operationQueue.operationCount) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        
        DDLogError(@"\nError : %@ \n%@",error.userInfo,[YXDNetworkManager responseInfoDescription:task params:sendParams responseObject:nil]);
        
        NSString *message = @"网络连接失败";
        
        if (loadingStatus) {
            [YXDHUDManager showErrorAndAutoDismissWithTitle:message];
        }
        
        if (networkFailure) {
            networkFailure([NSError errorWithDomain:kYXDExtensionErrorDomain code:YXDExtensionErrorCodeLostNetwork userInfo:@{NSLocalizedDescriptionKey : message}]);
        }
    };
    
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
        
        requestTask.task = [self.requestManager POST:interfaceAddress
                                          parameters:sendParams
                           constructingBodyWithBlock:constructingBodyBlock
                                            progress:^(NSProgress * _Nonnull progress) {
                                                if (uploadProgress) {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        uploadProgress(progress.fractionCompleted);
                                                    });
                                                }
                                            }
                                             success:successBlock
                                             failure:failureBlock];
    } else {
        
        if (timeoutInterval >= 0) {
            self.requestManager.requestSerializer.timeoutInterval = timeoutInterval;
        } else {
            self.requestManager.requestSerializer.timeoutInterval = kYXDNetworkRequestTimeoutIntervalDefault;
        }
        
        switch (method) {
            case GET:
            {
                requestTask.task = [self.requestManager GET:interfaceAddress
                                                 parameters:sendParams
                                                    success:successBlock
                                                    failure:failureBlock];
            }
                break;
            case POST:
            {
                requestTask.task = [self.requestManager POST:interfaceAddress
                                                  parameters:sendParams
                                                    progress:nil
                                                     success:successBlock
                                                     failure:failureBlock];
            }
                break;
            case PUT:
            {
                requestTask.task = [self.requestManager PUT:interfaceAddress
                                                 parameters:sendParams
                                                    success:successBlock
                                                    failure:failureBlock];
            }
                break;
            case DELETE:
            {
                requestTask.task = [self.requestManager DELETE:interfaceAddress
                                                    parameters:sendParams
                                                       success:successBlock
                                                       failure:failureBlock];
            }
                break;
            case PATCH:
            {
                requestTask.task = [self.requestManager PATCH:interfaceAddress
                                                   parameters:sendParams
                                                      success:successBlock
                                                      failure:failureBlock];
            }
                break;
                
            default:
                break;
        }
    }
    
    return requestTask;
}

#pragma mark - Upload & Download

- (YXDNetworkSessionUploadTask *)uploadWithURL:(NSString *)URL
                                        params:(NSDictionary *)params
                                  uploadObject:(YXDNetworkUploadObject *)uploadObject
                                uploadProgress:(YXDNetworkManagerProgressChangedBlock)uploadProgress
                                    completion:(void (^)(YXDNetworkResult *))completion {
    if (!URL.length) {
        if (completion) {
            completion([YXDNetworkResult resultWithDictionary:@{kNetworkReturnCodeKey:@(YXDExtensionErrorCodeInputError),
                                                                kNetworkReturnMessageKey:@"URL为空"}]);
        }
        return nil;
    }
    
    NSData *data = nil;
    if ([uploadObject isKindOfClass:[YXDNetworkUploadObject class]] && ([uploadObject.file isKindOfClass:[NSData class]] || [uploadObject.file isKindOfClass:[UIImage class]])) {
        if ([uploadObject.file isKindOfClass:[NSData class]]) {
            data = uploadObject.file;
        } else if ([uploadObject.file isKindOfClass:[UIImage class]]) {
            data = UIImageJPEGRepresentation(uploadObject.file,uploadObject.imageQuality);
        }
    } else {
        if (completion) {
            completion([YXDNetworkResult resultWithDictionary:@{kNetworkReturnCodeKey:@(YXDExtensionErrorCodeInputError),
                                                                kNetworkReturnMessageKey:@"上传数据格式错误"}]);
        }
        return nil;
    }
    
    if (params.count) {
        NSString *paramsString = params.sortedKeyValueString;
        if ([URL containsString:@"?"]) {
            URL = [URL stringByAppendingString:@"&"];
        } else {
            URL = [URL stringByAppendingString:@"?"];
        }
        URL = [URL stringByAppendingString:paramsString];
    }
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL.URL];
    [request setHTTPMethod:@"POST"];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval:kYXDNetworkUploadTimeoutIntervalDefault];
    
    NSURL *dataURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",kCaches,@"file"]];
    [data writeToURL:dataURL atomically:YES];
    
    YXDNetworkSessionUploadTask *ut = [[YXDNetworkSessionUploadTask alloc] init];
    ut.task = [self.tasksManager uploadTaskWithRequest:request
                                              fromFile:dataURL
                                              progress:^(NSProgress * _Nonnull progress) {
                                                  ut.progress = progress.fractionCompleted;
                                                  if (uploadProgress) {
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          uploadProgress(ut.progress);
                                                      });
                                                  }
                                              }
                                     completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                         
                                         [YXDFileManager removeItemAtPath:dataURL.relativePath];
                                         
                                         NSDictionary *responseDictionary = nil;
                                         
                                         if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                             responseDictionary = responseObject;
                                         } else if ([responseObject isKindOfClass:[NSData class]]) {
                                             responseDictionary = [responseObject objectFromJSONData];
                                         }
                                         
                                         if (error || !responseDictionary) {
                                             if (completion) {
                                                 completion([YXDNetworkResult resultWithDictionary:@{kNetworkReturnCodeKey:@(YXDExtensionErrorCodeServerError),
                                                                                                     kNetworkReturnMessageKey:error.localizedDescription?:@"返回数据为空"}]);
                                             }
                                             return;
                                         }
                                         
                                         YXDNetworkResult *result = [YXDNetworkResult resultWithDictionary:responseDictionary];
                                         
                                         if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                             result.allHeaderFields = ((NSHTTPURLResponse *)response).allHeaderFields;
                                         }
                                         
                                         if (completion) {
                                             completion(result);
                                         }
                                     }];
    [ut.task resume];
    return ut;
}

- (YXDNetworkSessionDownloadTask *)downloadWithURL:(NSString *)URL
                                  downloadProgress:(YXDNetworkManagerProgressChangedBlock)downloadProgress
                                        completion:(YXDNetworkManagerDownloadCompletionBlock)completion {
    return [self downloadWithURL:URL
                       directory:nil
                downloadProgress:downloadProgress
                      completion:completion];
}

- (YXDNetworkSessionDownloadTask *)downloadWithURL:(NSString *)URL
                                         directory:(NSString *)directory
                                  downloadProgress:(YXDNetworkManagerProgressChangedBlock)downloadProgress
                                        completion:(YXDNetworkManagerDownloadCompletionBlock)completion {
    if (!URL.length) {
        if (completion) {
            completion(nil,[NSError errorWithDomain:kYXDExtensionErrorDomain
                                               code:YXDExtensionErrorCodeInputError
                                           userInfo:@{NSLocalizedDescriptionKey:@"下载URL为空"}]);
        }
        return nil;
    }
    
    YXDNetworkSessionDownloadTask *dt = [[YXDNetworkSessionDownloadTask alloc] init];
    dt.task = [self.tasksManager downloadTaskWithRequest:URL.URLRequest
                                                progress:^(NSProgress * _Nonnull progress) {
                                                    dt.progress = progress.fractionCompleted;
                                                    if (downloadProgress) {
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            downloadProgress(dt.progress);
                                                        });
                                                    }
                                                }
                                             destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                                 return [YXDNetworkManager downloadDestinationWithDirectory:directory response:response];
                                             }
                                       completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                           if (completion) {
                                               completion(filePath,error);
                                           }
                                       }];
    [dt.task resume];
    return dt;
}

- (NSDictionary<NSString *,YXDNetworkSessionDownloadTask *> *)downloadWithURLArray:(NSArray<NSString *> *)URLArray
                                                                         directory:(NSString *)directory
                                                                  downloadProgress:(YXDNetworkManagerProgressChangedBlock)downloadProgress
                                                                        completion:(YXDNetworkManagerMultiFilesDownloadCompletionBlock)completion {
    if (!URLArray.count) {
        if (completion) {
            completion(nil,@[[NSError errorWithDomain:kYXDExtensionErrorDomain
                                                 code:YXDExtensionErrorCodeInputError
                                             userInfo:@{NSLocalizedDescriptionKey:@"下载URL为空"}]]);
        }
        return nil;
    }
    
    //下载队列
    NSMutableDictionary<NSString *, YXDNetworkSessionDownloadTask *> *downloadTasks = [NSMutableDictionary dictionary];
    //文件地址
    NSMutableDictionary<NSString *, NSURL *> *filePathsDictionary = [NSMutableDictionary dictionary];
    
    //创建下载任务
    for (NSString *URL in URLArray) {
        if (!URL.length) {
            continue;
        }
        
        YXDNetworkSessionDownloadTask *dt = [[YXDNetworkSessionDownloadTask alloc] init];
        dt.task = [self.tasksManager downloadTaskWithRequest:URL.URLRequest
                                                    progress:^(NSProgress * _Nonnull progress) {
                                                        dt.progress = progress.fractionCompleted;
                                                    }
                                                 destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                                     return [YXDNetworkManager downloadDestinationWithDirectory:directory response:response];
                                                 }
                                           completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                               if (!error && filePath) {
                                                   [filePathsDictionary setObject:filePath forKey:URL];
                                               }
                                           }];
        
        //将下载任务添加到队列
        [downloadTasks setObject:dt forKey:URL];
    }
    
    if (!downloadTasks.count) {
        completion(nil,@[[NSError errorWithDomain:kYXDExtensionErrorDomain
                                             code:YXDExtensionErrorCodeInputError
                                         userInfo:@{NSLocalizedDescriptionKey:@"没有有效的下载URL"}]]);
        return nil;
    }
    
    //计算下载进度
    NSInteger tasksCount = downloadTasks.count;
    dispatch_source_t timer = [NSTimer repeatTimerForInterval:0.15 action:^{
        CGFloat progressTotal = 0;
        for (YXDNetworkSessionDownloadTask *dt in downloadTasks.allValues) {
            progressTotal += dt.progress;
        }
        progressTotal += (tasksCount - downloadTasks.count);
        downloadProgress(progressTotal/tasksCount);
    } startImmdiately:NO];
    
    //如果需要计算下载进度 则开启定时器
    if (downloadProgress) {
        [NSTimer startTimer:timer];
    }
    
    //下载完成 从队列中移除
    __weak typeof(self) weakSelf = self;
    NSString *tasksDesc = [NSString stringWithFormat:@"%@",downloadTasks.allKeys];
    
    NSMutableArray *errors = [NSMutableArray array];
    
    YXDNetworkManagerTaskDidCompleteBlock taskDidComplete = ^(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSError * _Nonnull error) {
        NSString *currentURL = nil;
        for (NSString *URL in downloadTasks.allKeys) {
            if (downloadTasks[URL].task == task) {
                currentURL = URL;
                break;
            }
        }
        
        if (!currentURL) {
            return;
        }
        
        if (error) {
            if (error.code == YXDExtensionErrorCodeCancelled) {
                [errors addObject:[NSError errorWithDomain:kYXDExtensionErrorDomain
                                                      code:YXDExtensionErrorCodeCancelled
                                                  userInfo:@{NSLocalizedDescriptionKey:@"用户下载取消"}]];
            } else {
                [errors addObject:error];
            }
        }
        
        [downloadTasks removeObjectForKey:currentURL];
        
        //如果当前没有下载任务 则表示下载全部完成
        if (!downloadTasks.count) {
            
            [NSTimer cancelTimer:timer];
            
            [weakSelf.taskDidCompleteBlocksMap removeObjectForKey:tasksDesc];
            
            completion(filePathsDictionary.count?filePathsDictionary:nil,errors?:nil);
        }
    };
    
    [self.taskDidCompleteBlocksMap setObject:taskDidComplete forKey:tasksDesc];
    
    //开始下载
    for (YXDNetworkSessionDownloadTask *dt in downloadTasks.allValues) {
        [dt.task resume];
    }

    return downloadTasks;
}

//获取下载目录 若目录不存在则创建目录
+ (NSURL *)downloadDestinationWithDirectory:(NSString *)directory response:(NSURLResponse *)response {
    NSURL *targetURL = [[[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                               inDomain:NSUserDomainMask
                                                      appropriateForURL:nil
                                                                 create:NO
                                                                  error:nil] URLByAppendingPathComponent:directory?:@"Downloads"];
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

- (void)willSendRequestTaskWithParams:(NSMutableDictionary *)params {
    
}

- (void)handleSuccessWithTask:(YXDNetworkSessionDataTask *)task result:(YXDNetworkResult *)result {
    
}

- (void)handleFailureWithTask:(YXDNetworkSessionDataTask *)task result:(YXDNetworkResult *)result {
    
}

#pragma mark - New

+ (instancetype)sharedInstance {
    static id networkManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkManager = [[self new] commonInit];
    });
    
    return networkManager;
}

+ (instancetype)newManager {
    return [[self new] commonInit];
}

- (instancetype)commonInit {
    self.commonParams = [NSMutableDictionary dictionary];
    self.commonHeaders = [NSMutableDictionary dictionary];
    self.requestManager = [AFHTTPSessionManager new];
    self.requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"application/json",@"text/plain",@"text/javascript",nil];
    return self;
}

- (AFURLSessionManager *)tasksManager {
    if (_tasksManager) {
        return _tasksManager;
    }
    
    self.taskDidCompleteBlocksMap = [NSMutableDictionary dictionary];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:[[NSBundle mainBundle] bundleIdentifier]];
    configuration.allowsCellularAccess = YES;
    _tasksManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    _tasksManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    ((AFHTTPResponseSerializer *)_tasksManager.responseSerializer).acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"application/json",@"text/plain",@"text/javascript",nil];
    
    __weak typeof(self) weakSelf = self;
    [_tasksManager setTaskDidCompleteBlock:^(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSError * _Nullable error) {
        for (YXDNetworkManagerTaskDidCompleteBlock block in weakSelf.taskDidCompleteBlocksMap.allValues) {
            block(session, task, error);
        }
    }];
    
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

+ (NSString *)responseInfoDescription:(NSURLSessionTask *)task params:(NSDictionary *)params responseObject:(id)responseObject {
    return  [NSString stringWithFormat:
             @" ------RequestURL------: \n %@ %@, \n "
             " ------RequestBody------: \n %@, \n "
             " ------RequestHeader------:\n %@, \n "
             " ------ResponseStatus:------:\n %@, \n "
             " ------ResponseBody------:\n %@, \n "
             " ------ResponseHeader-----:\n %@ \n ",
             task.currentRequest.URL, task.currentRequest.HTTPMethod,
             params,
             task.currentRequest.allHTTPHeaderFields,
             @(((NSHTTPURLResponse *)task.response).statusCode),
             responseObject,
             ((NSHTTPURLResponse *)task.response).allHeaderFields];
}

@end
