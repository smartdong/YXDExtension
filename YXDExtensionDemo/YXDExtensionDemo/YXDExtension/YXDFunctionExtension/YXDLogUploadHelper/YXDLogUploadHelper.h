//
//  YXDLogUploadHelper.h
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXDLogUploadHelper : NSObject

+ (NSArray<NSString *> *)logPaths;

+ (BOOL)deleteLogAtPath:(NSString *)logPath error:(NSError **)error;

@end
