//
//  YXDFMDBHelper.m
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import "YXDFMDBHelper.h"
#import "FMDB.h"

static NSString *YXDFMDBHelperDataBaseName = @"test.db";

#define YXDFMDBHelper_DataBase_Path     [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:YXDFMDBHelperDataBaseName]
#define YXDFMDBHelper_Instance          [YXDFMDBHelper sharedInstance]
#define YXDFMDBHelper_FMDB              [YXDFMDBHelper sharedInstance].fmdb

@interface YXDFMDBHelper ()

@property (nonatomic, strong) FMDatabase *fmdb;

@end

@implementation YXDFMDBHelper

#pragma mark -

+ (YXDFMDBHelper *)sharedInstance {
    static YXDFMDBHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[YXDFMDBHelper new] fmdbInit];
    });
    if ([helper openDatabase]) {
        return helper;
    }
    return nil;
}

- (instancetype)fmdbInit {
    self.fmdb = [FMDatabase databaseWithPath:YXDFMDBHelper_DataBase_Path];
    return self;
}

- (BOOL)openDatabase {
    if ([self.fmdb open]) {
        return YES;
    }
    return NO;
}

- (BOOL)closeDatabase {
    if ([self.fmdb close]) {
        return YES;
    }
    return NO;
}

- (void)dealloc {
    [self closeDatabase];
}

@end
