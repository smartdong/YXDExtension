//
//  YXDCommonFunction.m
//  YXDExtensionDemo
//
//  Created by YangXudong on 15/10/17.
//  Copyright © 2015年 YangXudong. All rights reserved.
//

#import "YXDCommonFunction.h"
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "NSString+YXDExtension.h"
#import "NSData+YXDExtension.h"

#define YXDCommonFunctionUserDefaultsKey(key, account) (account?[NSString stringWithFormat:@"%@_%@",key,account]:key)

@implementation YXDCommonFunction

#pragma mark - User Defaults

+ (void)setUserDefaultsValue:(id)value forKey:(NSString *)key {
    [self setUserDefaultsValue:value forKey:key account:nil];
}

+ (void)setUserDefaultsValue:(id)value forKey:(NSString *)key account:(NSString *)account {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (value == nil) {
        [ud removeObjectForKey:YXDCommonFunctionUserDefaultsKey(key, account)];
    }
    else {
        [ud setObject:value forKey:YXDCommonFunctionUserDefaultsKey(key, account)];
    }
    [ud synchronize];
}

+ (id)userDefaultsValueForKey:(NSString *)key {
    return [self userDefaultsValueForKey:key account:nil];
}

+ (id)userDefaultsValueForKey:(NSString *)key account:(NSString *)account {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:YXDCommonFunctionUserDefaultsKey(key, account)];
}

+ (void)setOpened:(NSString *)key {
    [self setOpened:key forAccount:nil];
}

+ (void)setOpened:(NSString *)key forAccount:(NSString *)account {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:YES forKey:YXDCommonFunctionUserDefaultsKey(key, account)];
    [ud synchronize];
}

+ (BOOL)isFirstOpen:(NSString *)key {
    return [self isFirstOpen:key forAccount:nil];
}

+ (BOOL)isFirstOpen:(NSString *)key forAccount:(NSString *)account {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return ![ud boolForKey:YXDCommonFunctionUserDefaultsKey(key, account)];
}

#pragma mark - Calculate Time Cost

+ (void)calculate:(dispatch_block_t)doSth done:(void(^)(double timeCost))done {
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    if (doSth) {
        doSth();
    }
    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    
    if (done) {
        done(end - start);
    }
}

#pragma mark - MIMEType & UTI

+ (NSString *)UTIForExtention:(NSString *)extention {
    if (!extention.length) {
        return nil;
    }
    return (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)(extention), NULL);
}

+ (NSString *)MIMETypeForExtention:(NSString *)extention {
    return [self MIMETypeForUTI:[self UTIForExtention:extention]];
}

+ (NSString *)extentionForUTI:(NSString *)UTI {
    if (!UTI.length) {
        return nil;
    }
    return (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)UTI, kUTTagClassFilenameExtension);
}

+ (NSString *)extentionForMIMEType:(NSString *)MIMEType {
    return [self extentionForUTI:[self UTIForMIMEType:MIMEType]];
}

+ (NSString *)UTIForMIMEType:(NSString *)MIMEType {
    if (!MIMEType.length) {
        return nil;
    }
    return (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType,(__bridge CFStringRef)MIMEType, NULL);
}

+ (NSString *)MIMETypeForUTI:(NSString *)UTI {
    if (!UTI.length) {
        return nil;
    }
    return (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef) UTI, kUTTagClassMIMEType);
}

+ (NSString *)UTIForFileAtPath:(NSString *)path {
    if (![[NSFileManager new] fileExistsAtPath:path]) {
        return nil;
    }
    return (__bridge NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[path pathExtension], NULL);
}

+ (NSString *)MIMETypeForFileAtPath:(NSString *)path {
    return [self MIMETypeForUTI:[self UTIForFileAtPath:path]];
}

+ (NSString *)UTIForObject:(id)object {
    return nil;
}

+ (NSString *)MIMETypeForObject:(id)object {
    return nil;
}

#pragma mark - Save Image

+ (void)saveImageToPhotosAlbum:(UIImage *)image metadata:(NSDictionary *)metadata completionBlock:(void(^)(NSURL *assetURL, NSError *error))completionBlock {
    [[ALAssetsLibrary new] writeImageToSavedPhotosAlbum:image.CGImage metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
        if (completionBlock) {
            completionBlock(assetURL,error);
        }
    }];
}

#pragma mark - 加密

+ (NSString *)hmacsha1WithPlainText:(NSString *)plainText secretKey:(NSString *)secretKey {
    return [plainText hmacsha1WithSecretKey:secretKey];
}

#pragma mark - Others

+ (void)setDisableWebViewCache {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [ud setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    [ud setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    [ud synchronize];
}

+ (id)objectFromJSONDataForResource:(NSString *)name ofType:(NSString *)ext {
    return [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:ext]].objectFromJSONData;
}

@end
