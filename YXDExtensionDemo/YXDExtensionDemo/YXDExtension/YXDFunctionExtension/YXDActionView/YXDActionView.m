//
//  YXDActionView.m
//  YXDExtensionDemo
//
//  Copyright © 2015年 YangXudong. All rights reserved.
//

#import "YXDActionView.h"
#import "UIColor+YXDExtension.h"

@interface YXDActionView ()<UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *wrapperView;

@property (nonatomic, weak) UIView *showedView;

@property (nonatomic, copy) void (^completion)(BOOL done);

@property (nonatomic, strong) NSArray<NSString *> *array;

@end

@implementation YXDActionView

+ (void)showView:(UIView *)view title:(NSString *)title completion:(void (^)(BOOL))completion {
    [YXDActionView showView:view
               barTintColor:nil
                 titleColor:nil
                      title:title
               comfirmTitle:nil
                cancelTitle:nil
                 completion:completion];
}

+ (void)showView:(UIView *)view
    barTintColor:(UIColor *)barTintColor
      titleColor:(UIColor *)titleColor
           title:(NSString *)title
    comfirmTitle:(NSString *)comfirmTitle
     cancelTitle:(NSString *)cancelTitle
      completion:(void (^)(BOOL))completion {
    [[YXDActionView new] showView:view
                     barTintColor:barTintColor
                       titleColor:titleColor
                            title:title
                     comfirmTitle:comfirmTitle
                      cancelTitle:cancelTitle
                       completion:completion];
}

+ (void)showPickerWithArray:(NSArray<NSString *> *)array title:(NSString *)title completion:(void (^)(BOOL, NSInteger, NSString *))completion {
    [YXDActionView showPickerWithArray:array
                          barTintColor:nil
                            titleColor:nil
                       backgroundColor:nil
                                 title:title
                          comfirmTitle:nil
                           cancelTitle:nil
                            completion:completion];
}

+ (void)showPickerWithArray:(NSArray<NSString *> *)array
               barTintColor:(UIColor *)barTintColor
                 titleColor:(UIColor *)titleColor
            backgroundColor:(UIColor *)backgroundColor
                      title:(NSString *)title
               comfirmTitle:(NSString *)comfirmTitle
                cancelTitle:(NSString *)cancelTitle
                 completion:(void (^)(BOOL, NSInteger, NSString *))completion {
    YXDActionView *actionView = [YXDActionView new];
    actionView.array = array;
    
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 240)];
    picker.showsSelectionIndicator = YES;
    picker.dataSource = actionView;
    picker.delegate = actionView;
    picker.backgroundColor = backgroundColor?:[UIColor whiteColor];
    
    [actionView showView:picker
            barTintColor:barTintColor
              titleColor:titleColor
                   title:title
            comfirmTitle:comfirmTitle
             cancelTitle:cancelTitle
              completion:^(BOOL done) {
                  if (completion) {
                      NSInteger index = [picker selectedRowInComponent:0];
                      completion(done, index, array[index]);
                  }
              }];
}

+ (void)showDatePickerWithMaxDate:(NSDate *)maxDate
                          minDate:(NSDate *)minDate
                     selectedDate:(NSDate *)selectedDate
                   datePickerMode:(UIDatePickerMode)datePickerMode
                   minuteInterval:(NSInteger)minuteInterval
                            title:(NSString *)title
                       completion:(void (^)(BOOL, NSDate *))completion {
    [YXDActionView showDatePickerWithMaxDate:maxDate
                                     minDate:minDate
                                selectedDate:selectedDate
                              datePickerMode:datePickerMode
                              minuteInterval:minuteInterval
                                barTintColor:nil
                                  titleColor:nil
                             backgroundColor:nil
                                       title:title
                                comfirmTitle:nil
                                 cancelTitle:nil
                                  completion:completion];
}

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
                       completion:(void (^)(BOOL, NSDate *))completion {
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 240)];
    datePicker.date = selectedDate;
    datePicker.maximumDate = maxDate;
    datePicker.minimumDate = minDate;
    datePicker.datePickerMode = datePickerMode;
    datePicker.minuteInterval = minuteInterval;
    datePicker.backgroundColor = backgroundColor?:[UIColor whiteColor];
    
    [YXDActionView showView:datePicker
               barTintColor:barTintColor
                 titleColor:titleColor
                      title:title
               comfirmTitle:comfirmTitle
                cancelTitle:cancelTitle
                 completion:^(BOOL done) {
                     if (completion) {
                         completion(done, datePicker.date);
                     }
                 }];
}

#pragma mark - Picker

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.array[row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.array.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

#pragma mark - Private

- (void)showView:(UIView *)view
    barTintColor:(UIColor *)barTintColor
      titleColor:(UIColor *)titleColor
           title:(NSString *)title
    comfirmTitle:(NSString *)comfirmTitle
     cancelTitle:(NSString *)cancelTitle
      completion:(void (^)(BOOL))completion {
    
    if (!barTintColor) {
        barTintColor = [UIColor colorWithHexString:@"333333"];
    }
    
    if (!titleColor) {
        titleColor = [UIColor whiteColor];
    }
    
    if (!comfirmTitle) {
        comfirmTitle = @"确定";
    }
    
    if (!cancelTitle) {
        cancelTitle = @"取消";
    }
    
    self.completion = completion;
    
    view.frame = CGRectMake(view.frame.origin.x, self.bounds.size.height, view.frame.size.width, view.frame.size.height);
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    toolbar.translucent = NO;
    toolbar.barTintColor = barTintColor;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0 , 0, 150, 21.0f)];
    [titleLabel setFont:[UIFont systemFontOfSize:17]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:titleColor];
    [titleLabel setText:title];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 10;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:cancelTitle?:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:comfirmTitle?:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    leftItem.tintColor = titleColor;
    rightItem.tintColor = titleColor;
    UIBarButtonItem *flex1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithCustomView:titleLabel];
    UIBarButtonItem *flex2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    if ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedDescending) {
        toolbar.items = @[fixedSpace, leftItem, flex1, titleItem, flex2, rightItem, fixedSpace];
    } else {
        toolbar.items = @[leftItem, flex1, titleItem, flex2, rightItem];
    }
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UIView *window = [[UIApplication sharedApplication].delegate window];
    NSArray *winSubviews = window.subviews;
    UIView *windowSubview = winSubviews.lastObject;
    
    for (NSInteger i = (winSubviews.count-1); i > 0; i--) {
        //如果windowSubview的bounds和屏幕不一致 则说明可能是其他控件 如果windowSubview.tag不为0也是其他控件
        if (CGRectEqualToRect(window.bounds, windowSubview.bounds) && !windowSubview.tag) {
            break;
        } else {
            windowSubview = winSubviews[i-1];
        }
    }
    
    view.frame = CGRectMake(view.frame.origin.x, toolbar.bounds.size.height, view.frame.size.width, view.frame.size.height);
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
    self.wrapperView.frame = CGRectMake(self.wrapperView.frame.origin.x, self.wrapperView.frame.origin.y, self.wrapperView.frame.size.width, view.bounds.size.height + toolbar.bounds.size.height);
    self.wrapperView.frame = CGRectMake(self.wrapperView.frame.origin.x, self.bounds.size.height, self.wrapperView.frame.size.width, self.wrapperView.frame.size.height);
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.wrapperView addSubview:toolbar];
    [self.wrapperView addSubview:view];
    [self addSubview:self.wrapperView];
    [windowSubview addSubview:self];
    
    [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.wrapperView.frame = CGRectMake(self.wrapperView.frame.origin.x, self.bounds.size.height - self.wrapperView.bounds.size.height, self.wrapperView.frame.size.width, self.wrapperView.frame.size.height);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }                completion:nil];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)];
        [self addGestureRecognizer:gesture];
        gesture.delegate = self;
        _wrapperView = [UIView new];
        _wrapperView.frame = self.bounds;
        _wrapperView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (void)done {
    if (self.completion) {
        self.completion(YES);
    }
    [self dismiss];
}

- (void)cancel {
    if (self.completion) {
        self.completion(NO);
    }
    [self dismiss];
}

- (void)dismiss {
    [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _wrapperView.frame = CGRectMake(_wrapperView.frame.origin.x, self.bounds.size.height, _wrapperView.frame.size.width, _wrapperView.frame.size.height);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
    }                completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:_wrapperView]) {
        return NO;
    }
    return YES;
}

@end
