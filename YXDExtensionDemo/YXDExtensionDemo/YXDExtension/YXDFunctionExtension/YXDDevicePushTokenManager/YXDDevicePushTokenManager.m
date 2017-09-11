//
//  YXDDevicePushTokenManager.m
//  YXDExtensionDemo
//
//  Copyright © 2017年 YangXudong. All rights reserved.
//

#import "YXDDevicePushTokenManager.h"
#import "YXDCommonFunction.h"

@interface NSData (YXDDeviceToken)

- (NSString *)deviceTokenString;

@end

@implementation NSData (YXDDeviceToken)

- (NSString *)deviceTokenString {
    return [[self.description stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

@end

static NSString *const kYXDCurrentDeviceTokenStorageKey     = @"kYXDCurrentDeviceTokenStorageKey";
static NSString *const kYXDUploadedDeviceTokenStorageKey    = @"kYXDUploadedDeviceTokenStorageKey";

@implementation YXDDevicePushTokenManager

+ (void)saveDeviceToken:(NSData *)deviceToken {
    [YXDCommonFunction setUserDefaultsValue:deviceToken.deviceTokenString forKey:kYXDCurrentDeviceTokenStorageKey];
}

+ (void)clearUploadedDeviceToken {
    [YXDDevicePushTokenManager saveUploadedDeviceToken:nil];
}

+ (NSString *)currentDeviceToken {
    return [YXDCommonFunction userDefaultsValueForKey:kYXDCurrentDeviceTokenStorageKey];
}

+ (void)saveUploadedDeviceToken:(NSString *)deviceTokenString {
    [YXDCommonFunction setUserDefaultsValue:deviceTokenString forKey:kYXDUploadedDeviceTokenStorageKey];
}

+ (NSString *)uploadedDeviceToken {
    return [YXDCommonFunction userDefaultsValueForKey:kYXDUploadedDeviceTokenStorageKey];
}

+ (void)autoUpdateBlock:(void(^)(NSString *deviceToken, dispatch_block_t successCompletion))updateBlock {
    NSString *currentDeviceToken = [YXDDevicePushTokenManager currentDeviceToken];
    NSString *uploadedDeviceToken = [YXDDevicePushTokenManager uploadedDeviceToken];
    
    BOOL uploaded = [currentDeviceToken isEqualToString:uploadedDeviceToken];
    
    if (!uploaded && updateBlock) {
        updateBlock(currentDeviceToken, ^{[YXDDevicePushTokenManager saveUploadedDeviceToken:currentDeviceToken];});
    }
}

@end
