//
//  UIImageView+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (YXDExtension)

- (void)setImageWithName:(NSString *)name;

- (void)setImageWithURLString:(NSString *)URLString;

- (void)setImageWithURLString:(NSString *)URLString placeholderImageName:(NSString *)placeholderImageName;

- (void)startAnimatingWithGifImageName:(NSString *)gifImageName;
- (void)startAnimatingWithGifImageName:(NSString *)gifImageName repeatCount:(NSUInteger)repeatCount;

- (void)startAnimatingWithGifImagePath:(NSString *)gifImagePath;
- (void)startAnimatingWithGifImagePath:(NSString *)gifImagePath repeatCount:(NSUInteger)repeatCount;

- (void)startAnimatingWithImages:(NSArray<UIImage *> *)images duration:(CGFloat)duration;
- (void)startAnimatingWithImages:(NSArray<UIImage *> *)images duration:(CGFloat)duration repeatCount:(NSUInteger)repeatCount;

@end
