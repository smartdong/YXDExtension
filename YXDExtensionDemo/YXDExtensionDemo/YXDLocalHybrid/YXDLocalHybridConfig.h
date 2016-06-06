//
//  YXDLocalHybridConfig.h
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 返回字段定义

typedef NS_ENUM(NSInteger,YXDLocalHybridRootViewControllerType) {
    YXDLocalHybridRootViewControllerTypeViewController          = 1,
    YXDLocalHybridRootViewControllerTypeNavigationController    = 2,
    YXDLocalHybridRootViewControllerTypeTabBarController        = 3,
};

//版本信息

//本次是否要强制更新

//如果检查更新失败 是否加载在线资源 （或者还是只加载本地资源）

//root vc type  1.纯vc 2.nvc 3.tab vc

//root vc name （数组<字典> 根据 type  如果是3 字典里面是 1.vc url 2.标题 3.tabicon url 4.tabicon selected url）

//

//

//

//

//

@interface YXDLocalHybridConfig : NSObject

//根据某个页面获取在线 URL
+ (NSString *)urlForPage:(NSString *)page;

//获取具体某项配置的值
+ (id)valueForConfigKey:(NSString *)configKey;

//更新为服务器返回的配置
+ (void)updateConfig:(NSDictionary *)configDictionary;

@end
