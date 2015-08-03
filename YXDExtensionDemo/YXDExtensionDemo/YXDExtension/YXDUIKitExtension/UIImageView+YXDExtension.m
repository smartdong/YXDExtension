//
//  UIImageView+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "UIImageView+YXDExtension.h"

@implementation UIImageView (YXDExtension)

- (void)setImageWithName:(NSString *)name {
    self.image = [UIImage imageNamed:name];
}

@end
