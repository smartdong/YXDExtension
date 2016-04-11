//
//  YXDFMDBHelper.h
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabase;

@interface YXDFMDBHelper : NSObject


#pragma mark - Shared Database

+ (FMDatabase *)sharedDatabase;

@end
