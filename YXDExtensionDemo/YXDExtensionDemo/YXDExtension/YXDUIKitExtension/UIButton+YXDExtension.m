//
//  UIButton+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "UIButton+YXDExtension.h"

//默认倒计时时间
#define YXDExtension_Verify_Button_Time                  60

//可用时的标题
#define YXDExtension_Verify_Button_Title_Available       @"获取验证码"

//倒计时的标题
#define YXDExtension_Verify_Button_Title_Unavailable     @"秒"

@implementation UIButton (YXDExtension)

- (void)unavailable {
    if (!self.userInteractionEnabled) {
        return;
    }
    
    __block int timeout = YXDExtension_Verify_Button_Time;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^
                                      {
                                          if(timeout <= 0) {
                                              //倒计时结束，关闭
                                              dispatch_source_cancel(_timer);
                                              dispatch_async(dispatch_get_main_queue(), ^
                                                             {
                                                                 [self available];
                                                             });
                                          } else {
                                              int seconds = timeout % 60;
                                              NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds==0?60:seconds];
                                              dispatch_async(dispatch_get_main_queue(), ^
                                                             {
                                                                 [self setTitle:[NSString stringWithFormat:@"%@%@",strTime,YXDExtension_Verify_Button_Title_Unavailable]
                                                                       forState:UIControlStateNormal];
                                                                 self.userInteractionEnabled = NO;
                                                                 self.enabled = NO;
                                                             });
                                              timeout--;
                                          }
                                      });
    
    dispatch_resume(_timer);
}

- (void)available {
    [self setTitle:YXDExtension_Verify_Button_Title_Available
          forState:UIControlStateNormal];
    self.userInteractionEnabled = YES;
    self.enabled = YES;
}

@end
