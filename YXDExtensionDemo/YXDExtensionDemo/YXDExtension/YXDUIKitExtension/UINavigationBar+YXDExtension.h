//
//  UINavigationBar+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (YXDExtension)

- (void)setSeparatorLineHidden:(BOOL)hidden;

- (void)setBarBackgroundColor:(UIColor *)backgroundColor;

- (void)setBarBackgroundAlpha:(CGFloat)alpha;

- (void)resetBarColor;

@end
