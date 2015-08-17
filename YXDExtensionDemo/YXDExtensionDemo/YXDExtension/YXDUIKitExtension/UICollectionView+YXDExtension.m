//
//  UICollectionView+YXDExtension.m
//  YXDExtensionDemo
//
//  Created by zjdd on 15/8/17.
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "UICollectionView+YXDExtension.h"

@implementation UICollectionView (YXDExtension)

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

@end
