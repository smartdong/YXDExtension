//
//  YXDLocalHybridManager.m
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import "YXDLocalHybridManager.h"
#import "YXDExtensionHeader.h"
#import "YXDNetworkManager.h"
#import "YXDNetworkResult.h"
#import "YXDCommonFunction.h"
#import "YXDFileManager.h"

@interface YXDLocalHybridManager ()

//是否正在更新
@property (nonatomic, assign, getter=isUpdating) BOOL updating;

//本次启动是否已经更新完毕
@property (nonatomic, assign, getter=isUpdated) BOOL updated;

//在更新资源成功以前是否使用本地 HTML
@property (nonatomic, assign) BOOL useLocalHtmlBeforeUpdateSucceed;

@end

static NSString *const kYXDLocalHybridManagerVersionKey             = @"kYXDLocalHybridManagerVersionKey";
static NSString *const kYXDLocalHybridManagerResourcerPathMapKey    = @"kYXDLocalHybridManagerResourcerPathMapKey";

@implementation YXDLocalHybridManager

#pragma mark - Update

+ (void)checkUpdateWithURL:(NSString *)URL params:(NSDictionary *)params {
    YXDLocalHybridManager *manager = [YXDLocalHybridManager sharedInstance];
    
    if (manager.isUpdating) {
        return;
    }
    
    manager.updating = YES;
    
    dispatch_block_t completion = ^{
        manager.updated = YES;
        manager.updating = NO;
    };
    
    NSString *resourceVersion = [self resourceVersion];
    
    if (resourceVersion.length) {
        params = [NSMutableDictionary dictionaryWithDictionary:params];
        [(NSMutableDictionary *)params setObject:resourceVersion forKey:@"version"];
    }
    
    [[YXDNetworkManager sharedInstance] sendRequestWithParams:params
                                             interfaceAddress:URL
                                                   completion:^(YXDNetworkResult *result) {
                                                       
                                                       NSString *serverVersion = [result.data objectForKey:@"version"];
                                                       NSDictionary *resourceDic = [result.data objectForKey:@"resource"];
                                                       
                                                       if (result.error || !serverVersion.length || !resourceDic.count) {
                                                           completion();
                                                           return;
                                                       }
                                                       
                                                       // url   资源包下载地址
                                                       // path  资源包里网页文件路径
                                                       // name  页面名称
                                                       
                                                       NSString *resourcePath = [NSString stringWithFormat:@"%@/HTML",kDocuments];
                                                       NSURL *resourceDownloadDirectory = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Zips",resourcePath]];
                                                       
                                                       [[YXDNetworkManager sharedInstance] downloadWithURL:[resourceDic objectForKey:@"url"]
                                                                                                 directory:resourceDownloadDirectory
                                                                                                completion:^(NSURL *filePath, NSError *error) {
                                                                                                    if (filePath && !error) {
                                                                                                        BOOL unzipSuccess = [YXDFileManager unzipFileAtPath:filePath.relativePath toDestination:resourcePath];
                                                                                                        if (unzipSuccess) {
                                                                                                            [self setResourcePath:[NSString stringWithFormat:@"%@/%@",resourcePath,[resourceDic objectForKey:@"path"]] forPage:[resourceDic objectForKey:@"name"]];
                                                                                                            [self setResourceVersion:serverVersion];
                                                                                                        }
                                                                                                        [YXDFileManager removeItemAtPath:filePath.relativePath];
                                                                                                    }
                                                                                                    completion();
                                                                                                }];
                                                   }
                                                       method:POST];
}

#pragma mark - Get & Set Path

+ (NSString *)resourcePathForPage:(NSString *)page {
    if (!page.length) {
        return nil;
    }
    NSDictionary *resourcePathMap = [YXDCommonFunction userDefaultsValueForKey:kYXDLocalHybridManagerResourcerPathMapKey];
    NSString *resourcePath = [resourcePathMap objectForKey:page];
    
    YXDLocalHybridManager *manager = [YXDLocalHybridManager sharedInstance];
    BOOL couldUseLocalHtml = manager.updated || manager.useLocalHtmlBeforeUpdateSucceed;
    
    if (resourcePath && [YXDFileManager existsItemAtPath:resourcePath] && couldUseLocalHtml) {
        return resourcePath;
    }
    return nil;
}

+ (void)setResourcePath:(NSString *)resourcePath forPage:(NSString *)page {
    if (!page.length) {
        return;
    }
    NSMutableDictionary *resourcePathMap = [YXDCommonFunction userDefaultsValueForKey:kYXDLocalHybridManagerResourcerPathMapKey];
    if (!resourcePathMap || ![resourcePathMap isKindOfClass:[NSDictionary class]]) {
        resourcePathMap = [NSMutableDictionary dictionary];
    } else if (![resourcePathMap isKindOfClass:[NSMutableDictionary class]]){
        resourcePathMap = [NSMutableDictionary dictionaryWithDictionary:resourcePathMap];
    }
    [resourcePathMap setObject:resourcePath forKey:page];
    [YXDCommonFunction setUserDefaultsValue:resourcePathMap forKey:kYXDLocalHybridManagerResourcerPathMapKey];
}

#pragma mark - Config

- (BOOL)useLocalHtmlBeforeUpdateSucceed {
    return NO;
}

+ (void)setResourceVersion:(NSString *)resourceVersion {
    [YXDCommonFunction setUserDefaultsValue:resourceVersion forKey:kYXDLocalHybridManagerVersionKey];
}

+ (NSString *)resourceVersion {
    return [YXDCommonFunction userDefaultsValueForKey:kYXDLocalHybridManagerVersionKey];
}

#pragma mark - Shared Instance

+ (instancetype)sharedInstance {
    static YXDLocalHybridManager *localHybridManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localHybridManager = [YXDLocalHybridManager new];
    });
    return localHybridManager;
}

@end
