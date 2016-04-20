//
//  YXDLogUploadHelper.m
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import "YXDLogUploadHelper.h"
#import "YXDFileManager.h"
#import "YXDLog.h"
#import "YXDExtensionDefine.h"

@implementation YXDLogUploadHelper

+ (NSArray<NSString *> *)logPaths {
    NSString *logsDirectory = [YXDLog logsDirectory];
    
    if (![YXDFileManager existsItemAtPath:logsDirectory]) {
        return nil;
    }
    
    NSArray *logPaths = [YXDFileManager listFilesInDirectoryAtPath:logsDirectory withSuffix:@".log"];
    
    if (logPaths.count) {
        return logPaths;
    }
    
    return nil;
}

+ (BOOL)deleteLogAtPath:(NSString *)logPath error:(NSError **)error {
    if (![YXDFileManager existsItemAtPath:logPath]) {
        *error = [NSError errorWithDomain:kYXDExtensionErrorDomain code:YXDExtensionErrorCodeInputError userInfo:@{NSLocalizedDescriptionKey:@"logPath doesn't exist"}];
        DDLogError(@"%@ %@ Error. logPath -> %@",NSStringFromClass([self class]),NSStringFromSelector(_cmd),logPath);
        return NO;
    }
    return [YXDFileManager removeItemAtPath:logPath error:error];
}

@end
