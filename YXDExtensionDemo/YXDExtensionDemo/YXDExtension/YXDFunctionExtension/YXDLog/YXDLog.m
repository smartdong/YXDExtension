//
//  YXDLog.m
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import "YXDLog.h"

@implementation YXDLog

static DDFileLogger *fl = nil;

+ (void)load{
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24;
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
    
    fl = fileLogger;
}

+ (NSString *)logsDirectory {
    return fl.logFileManager.logsDirectory;
}

@end
