//
//  YXDExtensionDefine.h
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#define kYXDExtensionErrorDomain [[NSBundle mainBundle] bundleIdentifier]

typedef NS_ENUM(NSInteger, YXDExtensionErrorCode) {
    YXDExtensionErrorCodeSuccess      = 0,      //成功
    YXDExtensionErrorCodeUndefine     = 1,      //未定义
    YXDExtensionErrorCodeLostNetwork  = 100,    //当前无网络
    YXDExtensionErrorCodeInputError   = 300,    //输入错误
    YXDExtensionErrorCodeCancelled    = 400,    //用户取消
    YXDExtensionErrorCodeServerError  = 500,    //服务器内部错误
};

static NSString *const kYXDExtensionErrorUnknown = @"未知错误";
