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

- (UIViewController *)rootViewController;

+ (instancetype)sharedInstance;

@end
