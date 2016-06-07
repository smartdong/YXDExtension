//
//  YXDLocalHybridResourceManager.h
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  资源管理类：
 *  1.存储页面与本地资源的对应关系
 *  2.根据页面来获取加载 URL（是否加载本地由配置判断）
 */
@interface YXDLocalHybridResourceManager : NSObject

//存储某个页面（page）的本地 HTML 路径
+ (void)setResourcePath:(NSString *)resourcePath forPage:(NSString *)page;

//根据某个页面（page）来获取加载 URL（由配置判断加载本地或者在线）
+ (NSURL *)resourceUrlForPage:(NSString *)page;

@end
