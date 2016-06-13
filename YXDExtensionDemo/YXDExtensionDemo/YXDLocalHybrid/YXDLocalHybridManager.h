//
//  YXDLocalHybridManager.h
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXDLocalHybridManager : NSObject

//更新本地 HTML 文件资源
+ (void)checkUpdateWithURL:(NSString *)URL params:(NSDictionary *)params;

//返回本地缓存的 HTML 文件地址
//如果为 nil 则需要加载在线地址
+ (NSString *)resourcePathForPage:(NSString *)page;

@end
