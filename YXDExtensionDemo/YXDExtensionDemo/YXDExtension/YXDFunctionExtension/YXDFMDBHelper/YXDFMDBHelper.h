//
//  YXDFMDBHelper.h
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabase;

static NSString *kYXDFMDBHelperObjectPrimaryID = @"primaryID";

@protocol YXDFMDBHelperObjectProtocol <NSObject>

@property (nonatomic, copy) NSString *primaryID;

@end

@interface YXDFMDBHelper : NSObject

#pragma mark - 增删改查

+ (BOOL)insertObjects:(NSArray<id<YXDFMDBHelperObjectProtocol>> *)objects error:(NSError **)error;

+ (BOOL)deleteObjectsWithPrimaryIDs:(NSArray<NSString *> *)primaryIDs error:(NSError **)error;

+ (BOOL)updateObjects:(NSArray<id<YXDFMDBHelperObjectProtocol>> *)objects error:(NSError **)error;

+ (NSArray *)selectAllObjectsWithClass:(Class)clazz error:(NSError **)error;

+ (NSArray *)selectObjectsWithClass:(Class)clazz conditions:(NSArray<NSString *> *)conditions orderBy:(NSString *)orderBy asc:(BOOL)isAsc limit:(NSNumber *)limit error:(NSError **)error;

+ (NSArray *)selectObjectsWithClass:(Class)clazz query:(NSString *)query error:(NSError **)error;

#pragma mark - Shared Database

+ (FMDatabase *)sharedDatabase;

@end

@interface NSObject (YXDFMDBHelper)

+ (NSArray *)selectAllObjectsWithError:(NSError **)error;

+ (NSArray *)selectObjectsWithConditions:(NSArray<NSString *> *)conditions orderBy:(NSString *)orderBy asc:(BOOL)isAsc limit:(NSNumber *)limit error:(NSError **)error;

+ (NSArray *)selectObjectsWithQuery:(NSString *)query error:(NSError **)error;

@end
