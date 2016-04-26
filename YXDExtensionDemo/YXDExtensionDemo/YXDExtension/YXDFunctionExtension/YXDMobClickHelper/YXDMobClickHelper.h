//
//  YXDMobClickHelper.h
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXDMobClickHelper : NSObject

/**
 *  根据服务器返回的统计需求 在指定方法执行的时候执行统计事件
 *
 *  @param url        请求服务器统计需求的url
 *  @param params     请求所需参数
 *  @param eventBlock 指定方法执行时需要执行的block 参数为服务器返回的对应事件名称
 */
+ (void)autoConfigWithUrl:(NSString *)url params:(NSDictionary *)params eventBlock:(void(^)(NSString *eventName))eventBlock;

@end
