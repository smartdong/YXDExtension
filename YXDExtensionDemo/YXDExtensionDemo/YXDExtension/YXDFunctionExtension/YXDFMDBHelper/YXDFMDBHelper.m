//
//  YXDFMDBHelper.m
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import "YXDFMDBHelper.h"
#import "FMDB.h"
#import "NSObject+YXDExtension.h"
#import "YXDExtensionDefine.h"

static NSString *YXDFMDBHelperDataBaseName = @"test.db";

#define YXDFMDBHelper_DataBase_Path     [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:YXDFMDBHelperDataBaseName]
#define YXDFMDBHelper_Instance          [YXDFMDBHelper sharedInstance]
#define YXDFMDBHelper_FMDB              [YXDFMDBHelper sharedInstance].fmdb

@interface YXDFMDBHelper ()

@property (nonatomic, strong) FMDatabase *fmdb;

@end

@implementation YXDFMDBHelper

#pragma mark - 增删改查

+ (BOOL)insertObjects:(NSArray<id<YXDFMDBHelperObjectProtocol>> *)objects error:(NSError **)error {
    return NO;
}

+ (BOOL)deleteObjects:(NSArray<id<YXDFMDBHelperObjectProtocol>> *)objects error:(NSError **)error {
    return NO;
}

+ (BOOL)updateObjects:(NSArray<id<YXDFMDBHelperObjectProtocol>> *)objects error:(NSError **)error {
    return NO;
}

+ (NSArray *)selectAllObjectsWithClass:(Class)clazz error:(NSError **)error {
    return [self selectObjectsWithClass:clazz query:[NSString stringWithFormat:@"select * from %@",NSStringFromClass(clazz)] error:error];
}

+ (NSArray *)selectObjectsWithClass:(Class)clazz conditions:(NSArray<NSString *> *)conditions orderBy:(NSString *)orderBy asc:(BOOL)isAsc limit:(NSNumber *)limit error:(NSError *__autoreleasing *)error {
    
    NSString *query = [NSString stringWithFormat:@"select * from %@ where 1=1",NSStringFromClass(clazz)];
    
    for (NSString *condition in conditions) {
        if (condition.length) {
            query = [query stringByAppendingString:[NSString stringWithFormat:@" and %@",condition]];
        }
    }
    
    if (orderBy.length) {
        query = [query stringByAppendingString:[NSString stringWithFormat:@" order by %@",orderBy]];
        
        if (!isAsc) {
            query = [query stringByAppendingString:@" desc"];
        }
    }
    
    if (limit && (limit.intValue > 0)) {
        query = [query stringByAppendingString:[NSString stringWithFormat:@" limit %d",limit.intValue]];
    }
    
    return [self selectObjectsWithClass:clazz query:query error:error];
}

+ (NSArray *)selectObjectsWithClass:(Class)clazz query:(NSString *)query error:(NSError **)error {
    
    if (!clazz || !query.length) {
        *error = [NSError errorWithDomain:kYXDExtensionErrorDomain code:YXDExtensionErrorCodeInputError userInfo:@{NSLocalizedDescriptionKey:@"Class或sql语句无效"}];
        return nil;
    }
    
    if (![YXDFMDBHelper_FMDB validateSQL:query error:error]) {
        return nil;
    }
    
    //获取查询结果
    FMResultSet *resultSet = [YXDFMDBHelper_FMDB executeQuery:query];

    NSMutableArray *resultArray = [NSMutableArray array];
    
    while (resultSet.next) {
        id object = [clazz objectWithData:resultSet.resultDictionary];
        if (object) {
            [resultArray addObject:object];
        }
    }
    
    [YXDFMDBHelper_Instance closeDatabase];
    
    if (resultArray.count) {
        return resultArray;
    }
    
    return nil;
}

#pragma mark - Shared Database

+ (FMDatabase *)sharedDatabase {
    return YXDFMDBHelper_FMDB;
}

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

@implementation NSObject (YXDFMDBHelper)

+ (NSArray *)selectAllObjectsWithError:(NSError **)error {
    return [YXDFMDBHelper selectAllObjectsWithClass:[self class] error:error];
}

+ (NSArray *)selectObjectsWithConditions:(NSArray<NSString *> *)conditions orderBy:(NSString *)orderBy asc:(BOOL)isAsc limit:(NSNumber *)limit error:(NSError **)error {
    return [YXDFMDBHelper selectObjectsWithClass:[self class] conditions:conditions orderBy:orderBy asc:isAsc limit:limit error:error];
}

+ (NSArray *)selectObjectsWithQuery:(NSString *)query error:(NSError **)error {
    return [YXDFMDBHelper selectObjectsWithClass:[self class] query:query error:error];
}

@end
