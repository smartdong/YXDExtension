//
//  YXDActionView.h
//  YXDExtensionDemo
//
//  Copyright © 2015年 YangXudong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXDActionView : UIView

+ (void)showView:(UIView *)view
           title:(NSString *)title
      completion:(void(^)(BOOL done))completion;

+ (void)showView:(UIView *)view
    barTintColor:(UIColor *)barTintColor
      titleColor:(UIColor *)titleColor
           title:(NSString *)title
    comfirmTitle:(NSString *)comfirmTitle
     cancelTitle:(NSString *)cancelTitle
      completion:(void(^)(BOOL done))completion;

+ (void)showPickerWithArray:(NSArray<NSString *> *)array
                      title:(NSString *)title
                 completion:(void(^)(BOOL done, NSInteger index, NSString *data))completion;

+ (void)showPickerWithArray:(NSArray<NSString *> *)array
               barTintColor:(UIColor *)barTintColor
                 titleColor:(UIColor *)titleColor
            backgroundColor:(UIColor *)backgroundColor
                      title:(NSString *)title
               comfirmTitle:(NSString *)comfirmTitle
                cancelTitle:(NSString *)cancelTitle
                 completion:(void(^)(BOOL done, NSInteger index, NSString *data))completion;

+ (void)showDatePickerWithMaxDate:(NSDate *)maxDate
                          minDate:(NSDate *)minDate
                     selectedDate:(NSDate *)selectedDate
                   datePickerMode:(UIDatePickerMode)datePickerMode
                   minuteInterval:(NSInteger)minuteInterval
                            title:(NSString *)title
                       completion:(void(^)(BOOL done, NSDate *date))completion;

+ (void)showDatePickerWithMaxDate:(NSDate *)maxDate
                          minDate:(NSDate *)minDate
                     selectedDate:(NSDate *)selectedDate
                   datePickerMode:(UIDatePickerMode)datePickerMode
                   minuteInterval:(NSInteger)minuteInterval
                     barTintColor:(UIColor *)barTintColor
                       titleColor:(UIColor *)titleColor
                  backgroundColor:(UIColor *)backgroundColor
                            title:(NSString *)title
                     comfirmTitle:(NSString *)comfirmTitle
                      cancelTitle:(NSString *)cancelTitle
                       completion:(void(^)(BOOL done, NSDate *date))completion;

@end
