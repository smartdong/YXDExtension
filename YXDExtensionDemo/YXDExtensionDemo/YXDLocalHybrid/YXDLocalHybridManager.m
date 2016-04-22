//
//  YXDLocalHybridManager.m
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import "YXDLocalHybridManager.h"
#import "LocalHybridDefaultPage.h"
#import "YXDExtensionHeader.h"

static NSString *kYXDLocalHybridManagerVersionInfoKey = @"kYXDLocalHybridManagerVersionInfoKey";
static NSString *kYXDLocalHybridManagerLocalConfigKey = @"kYXDLocalHybridManagerLocalConfigKey";

@interface YXDLocalHybridManager ()

@property (nonatomic, strong) NSDictionary *localConfig;

@end

@implementation YXDLocalHybridManager

- (UIViewController *)rootViewController {
    //判断当前是否有配置启动页
//    if ([_localConfig valueForKey:<#(nonnull NSString *)#>]) {
//        
//    }
    return [LocalHybridDefaultPage new];
}

#pragma mark - Update

- (void)checkUpdate {
    _updating = YES;
    
//    NSString *versionInfo = [YXDCommonFunction getLocalString:kYXDLocalHybridManagerVersionInfoKey];
    
    //调接口更新 参数为versionInfo
    
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
//    [YXDCommonFunction setLocalValue:_localConfig key:kYXDLocalHybridManagerLocalConfigKey];
    
    //保存版本信息
//    [YXDCommonFunction setLocalValue:versionInfo key:kYXDLocalHybridManagerVersionInfoKey];
    
    _updated = YES;
    _updating = NO;
}

#pragma mark - Shared Instance

+ (instancetype)sharedInstance {
    static YXDLocalHybridManager *localHybridManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localHybridManager = [YXDLocalHybridManager new];
        [localHybridManager commonInit];
    });
    return localHybridManager;
}

- (void)commonInit {
    _localConfig = [YXDCommonFunction getLocalValue:kYXDLocalHybridManagerLocalConfigKey];
}

@end
