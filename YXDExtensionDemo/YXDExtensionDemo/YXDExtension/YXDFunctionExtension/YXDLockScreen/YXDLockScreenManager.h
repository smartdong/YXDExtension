//
//  YXDLockScreenManager.h
//
//  Created by dd .
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXDLockScreenManager : NSObject

/**
 *  用户是否设置了密码
 */
+ (BOOL) userHasPassword;

/**
 *  如果没有密码 则创建密码   如果有密码 则删除密码
 */
+ (void) modifyPassword;

/**
 *  激活锁屏功能  需在-application:didFinishLaunchingWithOptions:中调用
 */
+ (void) enableLockScreen;

@end
