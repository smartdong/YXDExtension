//
//  YXDCustomIndexView.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "YXDCustomIndexView.h"

#define YXDCustomIndexViewTitleTextColorDefault         [UIColor darkGrayColor]
#define YXDCustomIndexViewTitleLableWidthHeightRate     0.7

@interface YXDCustomIndexView ()

@property (nonatomic, assign) CGPoint selfCenter;

@property (nonatomic, strong) NSMutableArray *arr_titleLable;

@property (nonatomic, assign) NSInteger currentSelectedIndex;

@end

@implementation YXDCustomIndexView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self action_receiveTouchEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self action_receiveTouchEvent:event];
}

- (void)action_receiveTouchEvent:(UIEvent *)event {
    CGPoint point = [[[event allTouches].allObjects firstObject] locationInView:self];
    for (int i = 0 ; i < _arr_titleLable.count ; i++) {
        UILabel *titleLable = _arr_titleLable[i];
        if (CGRectContainsPoint(titleLable.frame, point)) {
            [self action_touchIndex:i];
            return;
        }
    }
}

- (void)action_touchIndex:(NSInteger)index {
    if (index == _currentSelectedIndex) {
        return;
    } else {
        _currentSelectedIndex = index;
        if ([self.delegate respondsToSelector:@selector(customIndexView:selectedSectionIndex:)]) {
            [self.delegate customIndexView:self selectedSectionIndex:index];
        }
    }
}

#pragma mark -

- (void)action_createSectionTitles {
    //重新设置self frame
    self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width * (_sectionTitleArray.count * YXDCustomIndexViewTitleLableWidthHeightRate + 1));
    self.center = self.selfCenter;
    
    self.arr_titleLable = [NSMutableArray array];
    
    for (int i = 0; i < _sectionTitleArray.count; i++) {
        
        UILabel *lable = [self action_createTitleLableWithTitle:_sectionTitleArray[i]
                                                          frame:CGRectMake(0,
                                                                           self.frame.size.width*YXDCustomIndexViewTitleLableWidthHeightRate*i + self.frame.size.width/2,
                                                                           self.frame.size.width,
                                                                           self.frame.size.width*YXDCustomIndexViewTitleLableWidthHeightRate)];
        
        [self addSubview:lable];
        [_arr_titleLable addObject:lable];
    }
}

- (UILabel *)action_createTitleLableWithTitle:(NSString *)title frame:(CGRect)frame {
    UILabel *lable = [[UILabel alloc] initWithFrame:frame];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = YXDCustomIndexViewTitleTextColorDefault;
    lable.text = title;
    lable.font = [UIFont systemFontOfSize:13];
    lable.backgroundColor = [UIColor clearColor];
    lable.adjustsFontSizeToFitWidth = YES;
    return lable;
}

- (void)action_clearView {
    for (UIView *view in _arr_titleLable) {
        [view removeFromSuperview];
    }
    [_arr_titleLable removeAllObjects];
    self.arr_titleLable = nil;
}

- (void)reloadSection {
    [self action_clearView];
    [self action_createSectionTitles];
}

- (void)setSectionTitleArray:(NSArray *)sectionTitleArray {
    _sectionTitleArray = sectionTitleArray;
    [self reloadSection];
}

+ (YXDCustomIndexView *)customIndexViewWithWidth:(CGFloat)width
                                          center:(CGPoint)center
                               sectionTitleArray:(NSArray *)sectionTitleArray
                                        delegate:(id<YXDCustomIndexViewDelegate>)delegate
                                       superView:(UIView *)superView{
    CGFloat height = width * (sectionTitleArray.count * YXDCustomIndexViewTitleLableWidthHeightRate + 1);
    YXDCustomIndexView *customIndexView = [[YXDCustomIndexView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    customIndexView.center              = center;
    customIndexView.selfCenter          = center;
    customIndexView.delegate            = delegate;
    customIndexView.clipsToBounds       = YES;
    customIndexView.sectionTitleArray   = sectionTitleArray;
    customIndexView.backgroundColor     = [UIColor clearColor];
    customIndexView.layer.cornerRadius  = width/2;
    customIndexView.currentSelectedIndex = -1;
    [superView addSubview:customIndexView];
    [superView bringSubviewToFront:customIndexView];
    return customIndexView;
}

@end
