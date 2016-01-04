//
//  UIView+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "UIView+YXDExtension.h"

@implementation UIView (YXDExtension)

- (void)setOrginX:(CGFloat)orginX {
    CGRect frame = self.frame;
    frame.origin.x = orginX;
    self.frame = frame;
}

- (CGFloat)orginX {
    return self.frame.origin.x;
}

- (void)setOrginY:(CGFloat)orginY {
    CGRect frame = self.frame;
    frame.origin.y = orginY;
    self.frame = frame;
}

- (CGFloat)orginY {
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setBorderColor:(UIColor *)color width:(CGFloat)width {
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
}

- (void)setCornerWidth:(CGFloat)width {
    self.layer.cornerRadius = width;
    self.layer.masksToBounds = YES;
}

@end
