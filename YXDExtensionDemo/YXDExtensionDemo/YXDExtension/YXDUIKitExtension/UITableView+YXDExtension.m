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

@end
