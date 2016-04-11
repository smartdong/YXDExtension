//
//  YXDFMDBHelper.h
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabase;

@interface YXDFMDBHelper : NSObject

#pragma mark - 增删改查

+ (BOOL)insertObjects:(NSArray *)objects primaryKey:(NSString *)primaryKey error:(NSError *)error;

+ (BOOL)deleteObjects:(NSArray *)objects primaryKey:(NSString *)primaryKey error:(NSError *)error;

+ (BOOL)updateObjects:(NSArray *)objects primaryKey:(NSString *)primaryKey error:(NSError *)error;

+ (NSArray *)selectObjectsWithClass:(Class)clazz error:(NSError *)error;

+ (NSArray *)selectObjectsWithQuery:(NSString *)query clazz:(Class)clazz error:(NSError *)error;

#pragma mark - Shared Database

+ (FMDatabase *)sharedDatabase;

@end

@interface NSObject (YXDFMDBHelper)

+ (NSArray *)selectAllObjects;

+ (NSArray *)selectObjectsWithConditions:(NSArray<NSString *> *)conditions orderBy:(NSString *)orderBy asc:(BOOL)isAsc limit:(NSString *)limit;

+ (NSArray *)selectObjectsWithQuery:(NSString *)query;

@end
