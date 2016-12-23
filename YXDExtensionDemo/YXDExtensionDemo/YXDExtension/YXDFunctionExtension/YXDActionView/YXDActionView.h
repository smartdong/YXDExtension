//
//  YXDActionView.h
//  YXDExtensionDemo
//
//  Copyright © 2015年 YangXudong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXDActionView : UIView

+ (void)showView:(UIView *)view title:(NSString *)title comfirmTitle:(NSString *)comfirmTitle cancelTitle:(NSString *)cancelTitle completion:(void(^)(BOOL done))completion;

+ (void)showDatePickerWithMaxDate:(NSDate *)maxDate
                          minDate:(NSDate *)minDate
                     selectedDate:(NSDate *)selectedDate
                   datePickerMode:(UIDatePickerMode)datePickerMode
                   minuteInterval:(NSInteger)minuteInterval
                            title:(NSString *)title
                     comfirmTitle:(NSString *)comfirmTitle
                      cancelTitle:(NSString *)cancelTitle
                  backgroundColor:(UIColor *)backgroundColor
                       completion:(void(^)(BOOL done, NSDate *date))completion;

@end
