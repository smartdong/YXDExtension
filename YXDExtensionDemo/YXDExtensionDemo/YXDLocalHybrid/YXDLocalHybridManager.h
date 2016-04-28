//
//  YXDLocalHybridManager.h
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXDLocalHybridManager : NSObject

//所有的配置信息
@property (nonatomic, strong, readonly) NSDictionary *localConfig;

//是否正在更新
@property (nonatomic, assign, readonly, getter=isUpdating) BOOL updating;

//本次启动是否已经更新完毕
@property (nonatomic, assign, readonly, getter=isUpdated) BOOL updated;

//当更新失败或者未更新时 是否使用本地 Html 默认 YES
@property (nonatomic, assign, readonly) BOOL useLocalHtmlWhenUpdateFailed;

- (UIViewController *)rootViewController;

#pragma mark -

- (void)configUpdateUrl:(NSString *)updateUrl params:(NSDictionary *)params headers:(NSDictionary *)headers;

+ (instancetype)sharedInstance;

@end
