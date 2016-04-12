//
//  YXDExtensionDefine.h
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

static NSString *kYXDExtensionErrorDomain = @"com.yxd.demo";

typedef NS_ENUM(NSInteger, YXDExtensionErrorCode) {
    
    YXDExtensionErrorCodeSuccess      = 0,
    YXDExtensionErrorCodeUndefine     = -1,
    
    //网络相关
    YXDExtensionErrorCodeServerError  = 500,
    YXDExtensionErrorCodeLostNetwork  = -100,
    
    //数据库相关
    YXDExtensionErrorCodeInputError   = 100,
};