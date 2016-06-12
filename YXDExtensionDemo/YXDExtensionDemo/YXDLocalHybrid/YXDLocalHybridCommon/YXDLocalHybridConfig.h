//
//  YXDLocalHybridConfig.h
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

//本地资源版本信息
extern NSString *const kYXDLocalHybridConfigVersionInfoKey;
//在更新资源成功以前是否使用本地 HTML
extern NSString *const kYXDLocalHybridConfigUseLocalHtmlBeforeUpdateSucceedKey;

/**
 *  配置类：
 *  1.根据页面获取在线 URL
 *  2.根据 key 获取对应配置
 *  3.保存服务器返回的配置
 */
@interface YXDLocalHybridConfig : NSObject

//根据某个页面获取在线 URL
+ (NSString *)URLForPage:(NSString *)page;

//获取具体某项配置的值
+ (id)valueForConfigKey:(NSString *)configKey;

//更新为服务器返回的配置
+ (void)updateConfig:(NSDictionary *)configDictionary;

@end
