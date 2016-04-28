//
//  YXDLocalHybridResourceManager.m
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import "YXDLocalHybridResourceManager.h"
#import "NSString+YXDExtension.h"
#import "YXDLocalHybridManager.h"
#import "YXDLocalHybridConfig.h"
#import "YXDCommonFunction.h"
#import "YXDFileManager.h"

static NSString *YXDLocalHybridResourceManagerPathMapKey = @"YXDLocalHybridResourceManagerPathMapKey";

@implementation YXDLocalHybridResourceManager

+ (NSURL *)resourceUrlForKey:(NSString *)key{
    if (!key.length) {
        return nil;
    }
    
    NSDictionary *pathMap = [YXDCommonFunction userDefaultsValueForKey:YXDLocalHybridResourceManagerPathMapKey];
    
    NSString *path = [pathMap objectForKey:key];
    
    YXDLocalHybridManager *manager = [YXDLocalHybridManager sharedInstance];
    //当前是否可用本地 html
    BOOL couldUseLocalHtml = manager.updated || manager.useLocalHtmlWhenUpdateFailed;
    
    if (path && [YXDFileManager existsItemAtPath:path] && couldUseLocalHtml) {
        return path.url;
    }
    
    //获取下载链接
    //返回下载链接的 url value
    //下载资源
    //成功后将文件地址作为value存在本地
    
    NSString *resourcePath = nil;

    return resourcePath.url;
}

@end
