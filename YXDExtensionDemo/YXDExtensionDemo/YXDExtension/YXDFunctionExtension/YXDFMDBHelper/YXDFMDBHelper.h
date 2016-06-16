//
//  YXDFMDBHelper.h
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabase;
@class YXDBaseObject;

@interface YXDFMDBHelper : NSObject

#pragma mark - 增删改查

+ (BOOL)insertObjects:(NSArray<YXDBaseObject *> *)objects error:(NSError **)error;

+ (BOOL)deleteObjects:(NSArray<YXDBaseObject *> *)objects error:(NSError **)error;

+ (BOOL)updateObjects:(NSArray<YXDBaseObject *> *)objects error:(NSError **)error;

+ (NSArray *)selectAllObjectsWithClass:(Class)clazz error:(NSError **)error;

+ (NSArray *)selectObjectsWithClass:(Class)clazz conditions:(NSArray<NSString *> *)conditions orderBy:(NSString *)orderBy asc:(BOOL)isAsc limit:(NSNumber *)limit error:(NSError **)error;

+ (NSArray *)selectObjectsWithClass:(Class)clazz query:(NSString *)query error:(NSError **)error;

#pragma mark - Shared Database

+ (FMDatabase *)sharedDatabase;

@end

@interface NSArray (YXDFMDBHelper)

- (BOOL)insertWithError:(NSError **)error;

- (BOOL)deleteWithError:(NSError **)error;

- (BOOL)updateWithError:(NSError **)error;

@end

@interface NSObject (YXDFMDBHelper)

+ (NSArray *)selectAllObjectsWithError:(NSError **)error;

+ (NSArray *)selectObjectsWithConditions:(NSArray<NSString *> *)conditions orderBy:(NSString *)orderBy asc:(BOOL)isAsc limit:(NSNumber *)limit error:(NSError **)error;

+ (NSArray *)selectObjectsWithQuery:(NSString *)query error:(NSError **)error;

@end