//
//  UITableView+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "UITableView+YXDExtension.h"

@implementation UITableView (YXDExtension)

-(void)hideFooterView {
    self.tableFooterView = [UIView new];
}

- (void)registerNibCellWithCellClass:(Class)cellClass {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(cellClass) bundle:nil] forCellReuseIdentifier:NSStringFromClass(cellClass)];
}

- (void)registerCellWithCellClass:(Class)cellClass {
    [self registerClass:cellClass forCellReuseIdentifier:NSStringFromClass(cellClass)];
}

- (void)registerNibHeaderFooterWithClass:(Class)aClass {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(aClass) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass(aClass)];
}

- (void)registerHeaderFooterWithClass:(Class)aClass {
    [self registerClass:aClass forHeaderFooterViewReuseIdentifier:NSStringFromClass(aClass)];
}

@end
