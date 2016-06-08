//
//  YXDExtensionDefine.h
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#define kYXDExtensionErrorDomain [[NSBundle mainBundle] bundleIdentifier]

typedef NS_ENUM(NSInteger, YXDExtensionErrorCode) {
    YXDExtensionErrorCodeUndefine     = -1      ,   //未定义
    YXDExtensionErrorCodeSuccess      = 0       ,   //成功
    YXDExtensionErrorCodeServerError  = 500     ,   //服务器内部错误
    YXDExtensionErrorCodeLostNetwork  = -100    ,   //当前无网络
    YXDExtensionErrorCodeInputError   = 100     ,   //输入错误
    YXDExtensionErrorCodeCancelled    = -999    ,   //用户取消
};