//
//  YXDFilterView.h
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YXDFilterView;

@protocol YXDFilterViewDelegate <NSObject>

@required

// Rows count in section (This count is NOT include special row)
- (NSInteger)filterView:(YXDFilterView *)filterView numberOfRowsInSection:(NSInteger)section;

// Header title
- (NSString *)filterView:(YXDFilterView *)filterView titleForHeaderInSection:(NSInteger)section;

// Row title
- (NSString *)filterView:(YXDFilterView *)filterView titleForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

// Select row event (If isSpecialRow is ture , the indexPath.row == -1)
- (void)filterView:(YXDFilterView *)filterView didSelectRowAtIndexPath:(NSIndexPath *)indexPath isSpecialRow:(BOOL)isSpecialRow;

// Default nil , not shown . Set title to show special row.
- (nullable NSString *)filterView:(YXDFilterView *)filterView specialRowTitleInSection:(NSInteger)section;

// Default 1 / (sections count) . 0 < percentage <= 1
- (CGFloat)filterView:(YXDFilterView *)filterView headerWidthPercentageInSection:(NSInteger)section;

// Default 1
- (NSInteger)numberOfSectionsInFilterView:(YXDFilterView *)filterView;

// Default 50
- (CGFloat)rowHeightForFilterView:(YXDFilterView *)filterView;

// Default 14
- (NSInteger)titleFontSizeForFilterView:(YXDFilterView *)filterView;

// Default lightGrayColor
- (UIColor *)normalTitleColorForFilterView:(YXDFilterView *)filterView;

// Default orangeColor
- (UIColor *)selectedTitleColorForFilterView:(YXDFilterView *)filterView;

@end

@interface YXDFilterView : UIView

// New instance
+ (nullable instancetype)filterViewWithSuperView:(__kindof UIView *)superView delegate:(id<YXDFilterViewDelegate>)delegate;

// Init with new data
- (void)reload;

// Reset to no selection state
- (void)reset;

// Current selected row in section (special row == -1) (NSNotFound when no selection)
- (NSInteger)selectedRowInSection:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
