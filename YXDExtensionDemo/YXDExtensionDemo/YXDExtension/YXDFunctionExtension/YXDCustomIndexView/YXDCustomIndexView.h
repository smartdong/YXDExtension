//
//  YXDCustomIndexView.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YXDCustomIndexView;

@protocol YXDCustomIndexViewDelegate <NSObject>

/**
 *  选择了某个索引
 */
- (void)customIndexView:(YXDCustomIndexView *)customView selectedSectionIndex:(NSUInteger)index;

@end


@interface YXDCustomIndexView : UIView

@property (nonatomic, weak) id<YXDCustomIndexViewDelegate> delegate;

@property (nonatomic, strong) NSArray *sectionTitleArray;

+ (YXDCustomIndexView *)customIndexViewWithWidth:(CGFloat)width
                                          center:(CGPoint)center
                               sectionTitleArray:(NSArray *)sectionTitleArray
                                        delegate:(id<YXDCustomIndexViewDelegate>)delegate
                                       superView:(UIView *)superView;

@end
