//
//  YXDLocalHybridManager.m
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import "YXDLocalHybridManager.h"
#import "YXDExtensionHeader.h"
#import "YXDLocalHybridConfig.h"
#import "YXDNetworkManager.h"
#import "YXDNetworkResult.h"

@interface YXDLocalHybridManager ()

//是否正在更新
@property (nonatomic, assign) BOOL updating;

@property (nonatomic, copy) NSString *updateUrl;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSDictionary *headers;

@end

@implementation YXDLocalHybridManager

#pragma mark - Update

- (void)checkUpdate {
    if (_updating) {
        return;
    }
    
    _updating = YES;
    
//    NSString *versionInfo = [YXDLocalHybridConfig valueForConfigKey:kYXDLocalHybridConfigVersionInfoKey];
    
    //调接口更新 参数为versionInfo
//    YXDNetworkManager *manager = [YXDNetworkManager newManager];
//    manager.commonParams = [self.params mutableCopy];
//    manager.commonHeaders = [self.headers mutableCopy];

    //调取接口 获取更新资源包
    //如果有资源包 则下载资源包
    //解压资源包到临时目录 并复制文件到资源目录 覆盖同名文件
    
    _updated = YES;
    _updating = NO;
}

#pragma mark - Getter

- (BOOL)useLocalHtmlBeforeUpdateSucceed {
    return [[YXDLocalHybridConfig valueForConfigKey:kYXDLocalHybridConfigUseLocalHtmlBeforeUpdateSucceedKey] boolValue];
}

#pragma mark - Shared Instance & Set Up

- (void)configUpdateUrl:(NSString *)updateUrl params:(NSDictionary *)params headers:(NSDictionary *)headers {
    self.updateUrl = updateUrl;
    self.params = params;
    self.headers = headers;
}

+ (instancetype)sharedInstance {
    static YXDLocalHybridManager *localHybridManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localHybridManager = [YXDLocalHybridManager new];
    });
    return localHybridManager;
}

@end
