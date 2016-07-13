//
//  UITableViewCell+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import "UITableViewCell+YXDExtension.h"

@implementation UITableViewCell (YXDExtension)

- (CGFloat)autoLayoutHeight {
    return [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
}

@end
