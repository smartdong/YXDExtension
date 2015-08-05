//
//  UIButton+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

//默认倒计时时间
#define YXDExtension_Verify_Button_Time                  60

//可用时的标题
#define YXDExtension_Verify_Button_Title_Available       @"获取验证码"

//倒计时的标题
#define YXDExtension_Verify_Button_Title_Unavailable     @"秒后重新获取"

#import <UIKit/UIKit.h>

@interface UIButton (YXDExtension)

/**
 *  接收到按钮事件后 调用此方法
 */
- (void) unavailable;

@end
