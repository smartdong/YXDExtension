//
//  UITableView+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (YXDExtension)

- (void)hideGroupHeaderView;
- (void)hideFooterView;

- (void)registerNibCellWithCellClass:(Class)cellClass;
- (void)registerCellWithCellClass:(Class)cellClass;

- (void)registerNibHeaderFooterWithClass:(Class)aClass;
- (void)registerHeaderFooterWithClass:(Class)aClass;

@end
