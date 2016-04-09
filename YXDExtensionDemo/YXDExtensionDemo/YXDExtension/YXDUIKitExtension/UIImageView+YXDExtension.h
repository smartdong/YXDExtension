//
//  UIImageView+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (YXDExtension)

- (void)setImageWithName:(NSString *)name;

- (void)setImageWithUrlString:(NSString *)urlString;

- (void)setImageWithUrlString:(NSString *)urlString placeholderImageName:(NSString *)placeholderImageName;

- (void)startAnimatingWithGifImageName:(NSString *)gifImageName;

- (void)startAnimatingWithGifImagePath:(NSString *)gifImagePath;

- (void)startAnimatingWithImages:(NSArray<UIImage *> *)images duration:(CGFloat)duration;

@end
