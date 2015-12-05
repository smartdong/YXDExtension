//
//  UICollectionView+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (YXDExtension)

- (void)registerDefaultCell;

- (void)registerNibCellWithCellClass:(Class)cellClass;
- (void)registerCellWithCellClass:(Class)cellClass;

- (void)registerNibHeaderFooterWithClass:(Class)aClass isHeader:(BOOL)isHeader;
- (void)registerHeaderFooterWithClass:(Class)aClass isHeader:(BOOL)isHeader;

@end
