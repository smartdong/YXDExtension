//
//  UICollectionView+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "UICollectionView+YXDExtension.h"

@implementation UICollectionView (YXDExtension)

- (void)registerDefaultCell {
    [self registerCellWithCellClass:[UICollectionViewCell class]];
}

- (void)registerNibCellWithCellClass:(Class)cellClass {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(cellClass) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
}

- (void)registerCellWithCellClass:(Class)cellClass {
    [self registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
}

- (void)registerNibHeaderFooterWithClass:(Class)aClass isHeader:(BOOL)isHeader {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(aClass) bundle:nil] forSupplementaryViewOfKind:isHeader?UICollectionElementKindSectionHeader:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(aClass)];
}

- (void)registerHeaderFooterWithClass:(Class)aClass isHeader:(BOOL)isHeader {
    [self registerClass:aClass forSupplementaryViewOfKind:isHeader?UICollectionElementKindSectionHeader:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(aClass)];
}

- (UICollectionViewCell *)dequeueReusableCellWithDefaultIdentifierForIndexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableCellWithCellClass:[UICollectionViewCell class] forIndexPath:indexPath];
}

- (UICollectionViewCell *)dequeueReusableCellWithCellClass:(Class)cellClass forIndexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableCellWithReuseIdentifier:NSStringFromClass(cellClass) forIndexPath:indexPath];
}

- (UICollectionReusableView *)dequeueReusableSupplementaryViewClass:(Class)aClass isHeader:(BOOL)isHeader forIndexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableSupplementaryViewOfKind:isHeader?UICollectionElementKindSectionHeader:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(aClass) forIndexPath:indexPath];
}

@end
