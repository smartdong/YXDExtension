//
//  YXDDevicePushTokenManager.h
//  YXDExtensionDemo
//
//  Copyright © 2017年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXDDevicePushTokenManager : NSObject

//保存最新的 token
+ (void)saveDeviceToken:(NSData *)deviceToken;

//清除已经上传的 token
+ (void)clearUploadedDeviceToken;

//判断是否需要更新 token 如果需要则会回调 updateBlock 上传成功后需要回调 successCompletion
+ (void)autoUpdateBlock:(void(^)(NSString *deviceToken, dispatch_block_t successCompletion))updateBlock;

@end
