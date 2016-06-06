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

static NSString *YXDLocalHybridResourcerPathMapKey = @"YXDLocalHybridResourcerPathMapKey";

@implementation YXDLocalHybridResourceManager

+ (void)setResourcePath:(NSString *)resourcePath forPage:(NSString *)page {
    if (!page.length) {
        return;
    }
    NSMutableDictionary *resourcePathMap = [YXDCommonFunction userDefaultsValueForKey:YXDLocalHybridResourcerPathMapKey];
    if (!resourcePathMap || ![resourcePathMap isKindOfClass:[NSDictionary class]]) {
        resourcePathMap = [NSMutableDictionary dictionary];
    } else if (![resourcePathMap isKindOfClass:[NSMutableDictionary class]]){
        resourcePathMap = [NSMutableDictionary dictionaryWithDictionary:resourcePathMap];
    }
    [resourcePathMap setObject:resourcePath forKey:page];
    [YXDCommonFunction setUserDefaultsValue:resourcePathMap forKey:YXDLocalHybridResourcerPathMapKey];
}

+ (NSURL *)resourceUrlForPage:(NSString *)page {
    if (!page.length) {
        return nil;
    }
    NSDictionary *resourcePathMap = [YXDCommonFunction userDefaultsValueForKey:YXDLocalHybridResourcerPathMapKey];
    NSString *resourcePath = [resourcePathMap objectForKey:page];
    
    YXDLocalHybridManager *manager = [YXDLocalHybridManager sharedInstance];
    BOOL couldUseLocalHtml = manager.updated || manager.useLocalHtmlBeforeUpdateSucceed;
    
    if (resourcePath && [YXDFileManager existsItemAtPath:resourcePath] && couldUseLocalHtml) {
        return resourcePath.url;
    }
    
    //如果不能使用本地资源 或者本地没有可用资源 则使用在线 URL
    return [YXDLocalHybridConfig urlForKey:page].url;
}

@end
