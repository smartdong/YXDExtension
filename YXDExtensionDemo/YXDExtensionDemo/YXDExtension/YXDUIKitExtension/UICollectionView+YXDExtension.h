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

- (UICollectionViewCell *)dequeueReusableCellWithDefaultIdentifierForIndexPath:(NSIndexPath *)indexPath;
- (UICollectionViewCell *)dequeueReusableCellWithCellClass:(Class)cellClass forIndexPath:(NSIndexPath *)indexPath;
- (UICollectionReusableView *)dequeueReusableSupplementaryViewClass:(Class)aClass isHeader:(BOOL)isHeader forIndexPath:(NSIndexPath *)indexPath;

@end
