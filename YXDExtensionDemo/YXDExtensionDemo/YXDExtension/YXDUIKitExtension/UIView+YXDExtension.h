//
//  UIView+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YXDExtension)

@property(nonatomic, assign) CGFloat orginX;
@property(nonatomic, assign) CGFloat orginY;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;

- (void)setBorderColor:(UIColor *)color width:(CGFloat)width;
- (void)setCornerWidth:(CGFloat)width;

@end
