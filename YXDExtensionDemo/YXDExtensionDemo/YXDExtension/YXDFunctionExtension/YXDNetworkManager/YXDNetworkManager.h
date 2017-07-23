//
//  YXDNetworkManager.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>

#define NetworkManagerInstance  [YXDNetworkManager sharedInstance]

extern NSString *const kYXDNetworkLoadingStatusDefault;

extern NSTimeInterval const kYXDNetworkRequestTimeoutIntervalDefault;
extern NSTimeInterval const kYXDNetworkUploadTimeoutIntervalDefault;

typedef NS_ENUM(NSInteger, NetworkManagerReachabilityStatus) {
    NetworkManagerReachabilityStatusUnknown          = -1,
    NetworkManagerReachabilityStatusNotReachable     = 0,
    NetworkManagerReachabilityStatusReachableViaWWAN = 1,
    NetworkManagerReachabilityStatusReachableViaWiFi = 2,
};

typedef NS_ENUM(NSInteger, NetworkManagerHttpMethod) {
    GET = 0,
    POST,
    PUT,
    DELETE,
    PATCH,
};

typedef void(^YXDNetworkManagerProgressChangedBlock)(CGFloat currentProgress);
typedef void(^YXDNetworkManagerDownloadCompletionBlock)(NSURL *filePath, NSError *error);
typedef void(^YXDNetworkManagerMultiFilesDownloadCompletionBlock)(NSDictionary<NSString *, NSURL *> *filePathsDictionary, NSArray<NSError *> *errors);

@class AFHTTPSessionManager;
@class AFURLSessionManager;
@class YXDNetworkUploadObject;
@class YXDNetworkResult;

@interface YXDNetworkSessionTask : NSObject

- (void)cancel;
- (void)suspend;
- (void)resume;

@end

@interface YXDNetworkSessionDataTask : YXDNetworkSessionTask

@property (nonatomic, strong) NSURLSessionDataTask *task;

@end

@interface YXDNetworkSessionUploadTask : YXDNetworkSessionTask

@property (nonatomic, strong) NSURLSessionUploadTask *task;

@property (nonatomic, assign) CGFloat progress;

@end

@interface YXDNetworkSessionDownloadTask : YXDNetworkSessionTask

@property (nonatomic, strong) NSURLSessionDownloadTask *task;

@property (nonatomic, assign) CGFloat progress;

@end

@interface YXDNetworkManager : NSObject

@property (nonatomic, strong) NSMutableDictionary *commonParams;
@property (nonatomic, strong) NSMutableDictionary *commonHeaders;

@property (nonatomic, strong) AFHTTPSessionManager *requestManager;     //普通请求
@property (nonatomic, strong) AFURLSessionManager *tasksManager;        //上传下载

#pragma mark - Request

/**
 *  根据相应接口获取数据
 *
 *  @param params           数据字典
 *  @param interfaceAddress 接口地址
 *  @param completion       接口返回处理方法
 *  @param method           网络请求方法
 */
- (YXDNetworkSessionDataTask *)sendRequestWithParams:(NSDictionary *)params
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
- (YXDNetworkSessionDataTask *)sendRequestWithParams:(NSDictionary *)params
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
- (YXDNetworkSessionDataTask *)sendRequestWithParams:(NSDictionary *)params
                                    interfaceAddress:(NSString *)interfaceAddress
                                          completion:(void (^)(YXDNetworkResult *result))completion
                                      networkFailure:(void (^)(NSError *error))networkFailure
                                       loadingStatus:(NSString *)loadingStatus
                                              method:(NetworkManagerHttpMethod)method;

/**
 *  根据相应接口获取数据
 *
 *  @param params             数据字典
 *  @param uploadObjectsArray 上传文件数据（只有在 POST 方法下才生效）
 *  @param interfaceAddress   接口地址
 *  @param completion         接口返回处理方法
 *  @param networkFailure     网络失败处理方法
 *  @param loadingStatus      是否显示加载提示  nil则不提示
 *  @param uploadProgress     上传进度
 *  @param timeoutInterval    超时时间
 *  @param method             网络请求方法
 */
- (YXDNetworkSessionDataTask *)sendRequestWithParams:(NSDictionary *)params
                                  uploadObjectsArray:(NSArray<YXDNetworkUploadObject *> *)uploadObjectsArray
                                    interfaceAddress:(NSString *)interfaceAddress
                                          completion:(void (^)(YXDNetworkResult *result))completion
                                      networkFailure:(void (^)(NSError *error))networkFailure
                                       loadingStatus:(NSString *)loadingStatus
                                      uploadProgress:(YXDNetworkManagerProgressChangedBlock)uploadProgress
                                     timeoutInterval:(NSTimeInterval)timeoutInterval
                                              method:(NetworkManagerHttpMethod)method;

#pragma mark - Upload & Download

/**
 *  根据 URL 上传文件
 *  需要在 AppDelegate.m 文件中实现 - (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler 方法才能实现后台上传
 *
 *  @param URL              上传地址 URL
 *  @param params           数据字典
 *  @param uploadObject     上传文件数据
 *  @param uploadProgress   上传进度
 *  @param completion       下载完毕后执行的方法
 */
- (YXDNetworkSessionUploadTask *)uploadWithURL:(NSString *)URL
                                        params:(NSDictionary *)params
                                  uploadObject:(YXDNetworkUploadObject *)uploadObject
                                uploadProgress:(YXDNetworkManagerProgressChangedBlock)uploadProgress
                                    completion:(void (^)(YXDNetworkResult *result))completion;

/**
 *  根据 URL 下载文件 (默认下载到 Documents/Downloads)
 *
 *  @param URL              文件 URL
 *  @param downloadProgress 下载进度
 *  @param completion       下载完毕后执行的方法
 */
- (YXDNetworkSessionDownloadTask *)downloadWithURL:(NSString *)URL
                                  downloadProgress:(YXDNetworkManagerProgressChangedBlock)downloadProgress
                                        completion:(YXDNetworkManagerDownloadCompletionBlock)completion;

/**
 *  根据 URL 下载文件
 *
 *  @param URL              文件 URL
 *  @param directory        下载目录 (Documents/directory)
 *  @param downloadProgress 下载进度
 *  @param completion       下载完毕后执行的方法
 */
- (YXDNetworkSessionDownloadTask *)downloadWithURL:(NSString *)URL
                                         directory:(NSString *)directory
                                  downloadProgress:(YXDNetworkManagerProgressChangedBlock)downloadProgress
                                        completion:(YXDNetworkManagerDownloadCompletionBlock)completion;

/**
 *  根据 URLArray 下载文件
 *
 *  @param URLArray         文件 URLArray
 *  @param directory        下载目录 (Documents/directory)
 *  @param downloadProgress 下载进度
 *  @param completion       下载完毕后执行的方法
 */
- (NSDictionary<NSString *, YXDNetworkSessionDownloadTask *> *)downloadWithURLArray:(NSArray<NSString *> *)URLArray
                                                                          directory:(NSString *)directory
                                                                   downloadProgress:(YXDNetworkManagerProgressChangedBlock)downloadProgress
                                                                         completion:(YXDNetworkManagerMultiFilesDownloadCompletionBlock)completion;

#pragma mark - Cancel

/**
 *  取消所有普通请求
 */
- (void)cancelAllRequest;

/**
 *  取消所有上传下载
 */
- (void)cancelAllTasks;

/**
 *  取消所有网络请求及上传下载
 */
- (void)cancelAllRequestAndTasks;

#pragma mark - Return Data Handle

//将要发送请求时调用
- (void)willSendRequestTaskWithParams:(NSMutableDictionary *)params NS_REQUIRES_SUPER;
//请求返回成功时调用
- (void)handleSuccessWithTask:(YXDNetworkSessionTask *)task result:(YXDNetworkResult *)result NS_REQUIRES_SUPER;
//请求返回失败时调用
- (void)handleFailureWithTask:(YXDNetworkSessionTask *)task result:(YXDNetworkResult *)result NS_REQUIRES_SUPER;

#pragma mark - New

/**
 *  默认全局的 manager
 */
+ (instancetype)sharedInstance;

/**
 *  新建一个 manager
 */
+ (instancetype)newManager;

#pragma mark - Reachability Status

+ (void)startMonitoringReachabilityStatus;
+ (void)stopMonitoringReachabilityStatus;

+ (NetworkManagerReachabilityStatus)currentReachabilityStatus;

+ (void)setReachabilityStatusChangeBlock:(nullable void (^)(NetworkManagerReachabilityStatus status))block;

@end
