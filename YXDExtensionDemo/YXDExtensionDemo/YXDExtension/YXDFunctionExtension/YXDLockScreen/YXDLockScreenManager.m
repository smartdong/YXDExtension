//
//  YXDLockScreenManager.m
//
//  Created by dd .
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "YXDLockScreenManager.h"
#import <UIKit/UIApplication.h>
#import "YXDTouchIDHelper.h"
#import "YXDLockScreenView.h"

@implementation YXDLockScreenManager

/**
 *  用户是否设置了密码
 */
+ (BOOL) userHasPassword {
    return [YXDLockScreenView userHasPassword];
}

/**
 *  如果没有密码 则创建密码   如果有密码 则删除密码
 */
+ (void) modifyPassword {
    [YXDLockScreenView modifyPassword];
}

//-------------

/**
 *  激活锁屏功能  需在-application:didFinishLaunchingWithOptions:中调用
 */
+(void)enableLockScreen {
    [YXDLockScreenManager sharedInstance];
}

/**
 *  弹出指纹解锁框
 */
+ (void) useTouchID {
    if ([YXDTouchIDHelper canUseTouchID]) {
        [YXDTouchIDHelper useTouchIDWithMessage:@"采集指纹来解锁"
                                        success:^ {
                                            [[NSNotificationCenter defaultCenter] postNotificationName:YXDDisLockScreenNotification object:nil];
                                        }
                                         failed:nil];
    }
}

#pragma mark - 通知事件

- (void) action_UIApplicationDidFinishLaunchingNotification {
    //启动完毕
//    NSLog(@"sel: %@",NSStringFromSelector(_cmd));
}

- (void) action_UIApplicationDidBecomeActiveNotification {
    //变为活动状态
//    NSLog(@"sel: %@",NSStringFromSelector(_cmd));
}

- (void) action_UIApplicationDidEnterBackgroundNotification {
    //进入后台
//    NSLog(@"sel: %@",NSStringFromSelector(_cmd));
    
    if ([YXDLockScreenManager userHasPassword] && (![YXDLockScreenView isLocking])) {
        [YXDLockScreenView lockScreen:YES animated:NO];
    }
}

- (void) action_UIApplicationWillEnterForegroundNotification {
    //将要进入前台
//    NSLog(@"sel: %@",NSStringFromSelector(_cmd));
    
    if ([YXDLockScreenManager userHasPassword] && [YXDLockScreenView isLocking]) {
        [YXDLockScreenManager useTouchID];
    }
}

- (void) action_UIApplicationWillResignActiveNotification {
    //活动状态改变
//    NSLog(@"sel: %@",NSStringFromSelector(_cmd));
}

- (void) action_UIApplicationWillTerminateNotification {
    //将要终止
//    NSLog(@"sel: %@",NSStringFromSelector(_cmd));
}

#pragma mark - init

+ (YXDLockScreenManager *) sharedInstance {
    
    static YXDLockScreenManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YXDLockScreenManager new] notificationInit];
    });

    return manager;
}

- (id) notificationInit {
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self
               selector:@selector(action_UIApplicationDidFinishLaunchingNotification)
                   name:UIApplicationDidFinishLaunchingNotification
                 object:nil];
    
    [center addObserver:self
               selector:@selector(action_UIApplicationDidBecomeActiveNotification)
                   name:UIApplicationDidBecomeActiveNotification
                 object:nil];
    
    [center addObserver:self
               selector:@selector(action_UIApplicationDidEnterBackgroundNotification)
                   name:UIApplicationDidEnterBackgroundNotification
                 object:nil];
    
    [center addObserver:self
               selector:@selector(action_UIApplicationWillEnterForegroundNotification)
                   name:UIApplicationWillEnterForegroundNotification
                 object:nil];
    
    [center addObserver:self
               selector:@selector(action_UIApplicationWillResignActiveNotification)
                   name:UIApplicationWillResignActiveNotification
                 object:nil];
    
    [center addObserver:self
               selector:@selector(action_UIApplicationWillTerminateNotification)
                   name:UIApplicationWillTerminateNotification
                 object:nil];
    
    return self;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
