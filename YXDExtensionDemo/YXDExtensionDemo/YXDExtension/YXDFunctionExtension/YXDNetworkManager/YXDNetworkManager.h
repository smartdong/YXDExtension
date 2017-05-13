//
//  YXDNetworkManager.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"
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

typedef void(^YXDNetworkManagerUploadProgressChangedBlock)(CGFloat currentProgress);
typedef void(^YXDNetworkManagerDownloadCompletionBlock)(NSURL *filePath, NSError *error);
typedef void(^YXDNetworkManagerMultiFilesDownloadCompletionBlock)(NSArray<NSURL *> *filePaths, NSError *error);

@class AFHTTPRequestOperationManager;
@class AFURLSessionManager;
@class YXDNetworkUploadObject;
@class YXDNetworkResult;

@interface YXDNetworkRequestOperation : AFHTTPRequestOperation

@end

@interface YXDNetworkManager : NSObject

@property (nonatomic, strong) NSMutableDictionary *commonParams;
@property (nonatomic, strong) NSMutableDictionary *commonHeaders;

@property (nonatomic, strong) AFHTTPRequestOperationManager *requestManager;    //普通请求
@property (nonatomic, strong) AFURLSessionManager *tasksManager;                //上传下载

#pragma mark - Request

/**
 *  根据相应接口获取数据
 *
 *  @param params           数据字典
 *  @param interfaceAddress 接口地址
 *  @param completion       接口返回处理方法
 *  @param method           网络请求方法
 */
- (YXDNetworkRequestOperation *)sendRequestWithParams:(NSDictionary *)params
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
- (YXDNetworkRequestOperation *)sendRequestWithParams:(NSDictionary *)params
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
- (YXDNetworkRequestOperation *)sendRequestWithParams:(NSDictionary *)params
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
- (YXDNetworkRequestOperation *)sendRequestWithParams:(NSDictionary *)params
                                   uploadObjectsArray:(NSArray<YXDNetworkUploadObject *> *)uploadObjectsArray
                                     interfaceAddress:(NSString *)interfaceAddress
                                           completion:(void (^)(YXDNetworkResult *result))completion
                                       networkFailure:(void (^)(NSError *error))networkFailure
                                        loadingStatus:(NSString *)loadingStatus
                                       uploadProgress:(YXDNetworkManagerUploadProgressChangedBlock)uploadProgress
                                      timeoutInterval:(NSTimeInterval)timeoutInterval
                                               method:(NetworkManagerHttpMethod)method;

#pragma mark - Upload & Download

/**
 *  根据 URL 下载文件
 *
 *  @param URL              文件 URL
 *  @param completion       下载完毕后执行的方法
 */
- (NSURLSessionDownloadTask *)downloadWithURL:(NSString *)URL
                                   completion:(YXDNetworkManagerDownloadCompletionBlock)completion;

/**
 *  根据 URL 下载文件
 *
 *  @param URL              文件 URL
 *  @param directory        下载目录
 *  @param completion       下载完毕后执行的方法
 */
- (NSURLSessionDownloadTask *)downloadWithURL:(NSString *)URL
                                    directory:(NSURL *)directory
                                   completion:(YXDNetworkManagerDownloadCompletionBlock)completion;

/**
 *  根据 URL 下载文件
 *
 *  @param URL              文件 URL
 *  @param directory        下载目录
 *  @param loadingStatus    是否显示加载提示  nil则不提示 不为nil则同时显示下载进度
 *  @param completion       下载完毕后执行的方法
 */
- (NSURLSessionDownloadTask *)downloadWithURL:(NSString *)URL
                                    directory:(NSURL *)directory
                                loadingStatus:(NSString *)loadingStatus
                                   completion:(YXDNetworkManagerDownloadCompletionBlock)completion;

/**
 *  根据 URLArray 下载文件
 *
 *  @param URLArray         文件 URLArray
 *  @param directory        下载目录 所有的文件都下载到这个目录
 *  @param completion       下载完毕后执行的方法
 */
- (NSArray<NSURLSessionDownloadTask *> *)downloadWithURLArray:(NSArray<NSString *> *)URLArray
                                                    directory:(NSURL *)directory
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

//将要发送HTTP请求时调用
- (void)willSendHTTPRequestWithParams:(NSMutableDictionary *)params;
//HTTP请求返回成功时调用
- (void)handleSuccessWithHTTPRequestOperation:(YXDNetworkRequestOperation *)operation result:(YXDNetworkResult *)result;
//HTTP请求返回失败时调用
- (void)handleFailureWithHTTPRequestOperation:(YXDNetworkRequestOperation *)operation result:(YXDNetworkResult *)result;

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
