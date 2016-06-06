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

//static NSString *kYXDLocalHybridManagerVersionInfoKey = @"kYXDLocalHybridManagerVersionInfoKey";
//static NSString *kYXDLocalHybridManagerLocalConfigKey = @"kYXDLocalHybridManagerLocalConfigKey";

@interface YXDLocalHybridManager ()

//是否正在更新
//@property (nonatomic, assign, readonly, getter=isUpdating) BOOL updating;

@property (nonatomic, copy) NSString *updateUrl;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSDictionary *headers;

@end

@implementation YXDLocalHybridManager

#pragma mark - Update

- (void)checkUpdate {
//    _updating = YES;
    
//    NSString *versionInfo = [YXDCommonFunction userDefaultsValueForKey:kYXDLocalHybridManagerVersionInfoKey];
    
//    //调接口更新 参数为versionInfo
//    YXDNetworkManager *manager = [YXDNetworkManager newManager];
//    manager.commonParams = [self.params mutableCopy];
//    manager.commonHeaders = [self.headers mutableCopy];
//    [manager sendRequestWithParams:nil
//                  interfaceAddress:self.updateUrl
//                           success:^(YXDNetworkResult *result) {
//                               
//                           }
//                           failure:nil
//                     loadingStatus:nil
//                            method:POST];
    
    //返回配置列表
    //返回所有图片资源文件
    //返回所有网页资源
    
    //如果没有新的更新 则不下载任何资源 _updated 改为 yes
    //如果有新的更新 则下载对应资源下载完毕后 _updated 改为 yes 把新版本信息存下来
    //如果下载到一半失败了 则下次继续下载 不存新版本信息
    
    //_updated 为 no 的情况下 所有 html 不加载本地资源 直接访问在线地址 (是否需要这样做 可以配置)
    
    //如果结果返回需要强制更新 则展示全局的 hud 不让用户继续操作 显示正在更新资源

    //保存配置
//    _localConfig = xxx;
//    [YXDCommonFunction setUserDefaultsValue:_localConfig forKey:kYXDLocalHybridManagerLocalConfigKey];
    
    //保存版本信息
//    [YXDCommonFunction setUserDefaultsValue:versionInfo forKey:kYXDLocalHybridManagerVersionInfoKey];
    
//    _updated = YES;
//    _updating = NO;
}

#pragma mark - Getter

- (BOOL)useLocalHtmlBeforeUpdateSucceed {
    //获取配置
//    [YXDLocalHybridConfig valueForConfigKey:<#(NSString *)#>];
    return YES;
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
