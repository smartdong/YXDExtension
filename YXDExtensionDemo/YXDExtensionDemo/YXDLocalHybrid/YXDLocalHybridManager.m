//
//  YXDLocalHybridManager.m
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import "YXDLocalHybridManager.h"
#import "LocalHybridDefaultPage.h"

@implementation YXDLocalHybridManager

+ (UIViewController *)rootViewController {
    return [LocalHybridDefaultPage new];
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
