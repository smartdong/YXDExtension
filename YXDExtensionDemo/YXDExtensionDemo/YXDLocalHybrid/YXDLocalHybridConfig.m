//
//  YXDLocalHybridConfig.m
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import "YXDLocalHybridConfig.h"
#import "YXDCommonFunction.h"
#import "YXDMacroExtensionHeader.h"

static NSString *YXDLocalHybridConfigKey = @"YXDLocalHybridConfigKey";

@implementation YXDLocalHybridConfig

+ (NSString *)urlForPage:(NSString *)page {
    //子类继承 实现页面与 URL 的对应关系
//    YXDOverrideAssert
    return nil;
}

+ (id)valueForConfigKey:(NSString *)configKey {
    if (!configKey.length) {
        return nil;
    }
    return [[YXDCommonFunction userDefaultsValueForKey:YXDLocalHybridConfigKey] objectForKey:configKey];
}

+ (void)updateConfig:(NSDictionary *)configDictionary {
    [YXDCommonFunction setUserDefaultsValue:configDictionary forKey:YXDLocalHybridConfigKey];
}

@end
