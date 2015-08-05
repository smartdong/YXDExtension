//
//  YXDLockScreenView.h
//
//  Created by dd .
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <UIKit/UIKit.h>

//解锁通知
static NSString *YXDDisLockScreenNotification   = @"YXDDisLockScreenNotification";
//设置密码成功通知
static NSString *YXDCreatePasswordNotification  = @"YXDCreatePasswordNotification";
//删除密码成功通知
static NSString *YXDDeletePasswordNotification  = @"YXDDeletePasswordNotification";


@interface YXDLockScreenView : UIControl

/**
 *  是否需要 锁屏/解锁   并选择是否需要动画
 *
 *  @param lockScreen 锁屏/解锁
 *  @param animated   是否需要动画
 */
+ (void) lockScreen:(BOOL)lockScreen animated:(BOOL)animated;

/**
 *  是否在锁屏状态
 */
+ (BOOL) isLocking;

/**
 *  用户是否设有密码
 */
+ (BOOL) userHasPassword;

/**
 *  如果没有密码 则创建密码   如果有密码 则删除密码
 */
+ (void) modifyPassword;

@end
