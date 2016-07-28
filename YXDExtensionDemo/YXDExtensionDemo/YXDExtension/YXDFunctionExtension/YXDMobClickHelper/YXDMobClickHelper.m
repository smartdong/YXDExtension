//
//  YXDMobClickHelper.m
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import "YXDMobClickHelper.h"
#import "Aspects.h"
#import "YXDCommonFunction.h"
#import "YXDNetworkManager.h"
#import "YXDNetworkResult.h"

static NSString *YXDMobClickHelperAutoConfigKey = @"YXDMobClickHelperAutoConfigKey";

@implementation YXDMobClickHelper

+ (void)autoConfigWithURL:(NSString *)URL params:(NSDictionary *)params eventBlock:(void (^)(NSString *))eventBlock {
    if (!URL.length || !eventBlock) {
        return;
    }
    
    //存在本地的配置
    NSArray<NSDictionary *> *config = [YXDCommonFunction userDefaultsValueForKey:YXDMobClickHelperAutoConfigKey];
    //hook 统计事件
    [config enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *clazz = [obj objectForKey:@"class"];
            NSString *method = [obj objectForKey:@"method"];
            NSString *event = [obj objectForKey:@"event"];
            if (clazz.length && method.length && event.length) {
                [NSClassFromString(clazz) aspect_hookSelector:NSSelectorFromString(method)
                                                  withOptions:AspectPositionAfter
                                                   usingBlock:^{eventBlock(event);}
                                                        error:nil];
            }
        }
    }];
    
    //更新最新的 config
    [[YXDNetworkManager newManager] sendRequestWithParams:params
                                         interfaceAddress:URL
                                                  completion:^(YXDNetworkResult *result) {
                                                      if (result.list.count) {
                                                          [YXDCommonFunction setUserDefaultsValue:result.list forKey:YXDMobClickHelperAutoConfigKey];
                                                      }
                                                  }
                                                   method:POST];
}

@end
