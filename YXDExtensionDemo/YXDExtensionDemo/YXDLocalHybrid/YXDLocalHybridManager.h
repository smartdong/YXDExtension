//
//  YXDLocalHybridManager.h
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXDLocalHybridManager : NSObject

//本次启动是否已经更新完毕
@property (nonatomic, assign, readonly, getter=isUpdated) BOOL updated;

//在更新资源成功以前是否使用本地 HTML
@property (nonatomic, assign, readonly) BOOL useLocalHtmlBeforeUpdateSucceed;

#pragma mark - Update

//检查资源更新
- (void)checkUpdate;

#pragma mark - Shared Instance & Set Up

//配置更新 URL 以及相关请求参数
- (void)configUpdateUrl:(NSString *)updateUrl params:(NSDictionary *)params headers:(NSDictionary *)headers;

+ (instancetype)sharedInstance;

@end
