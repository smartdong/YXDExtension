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
- (void)setImageWithURLString:(NSString *)URLString placeholderImage:(UIImage *)placeholderImage;
- (void)setImageWithURLString:(NSString *)URLString placeholderImage:(UIImage *)placeholderImage completed:(void(^)(UIImage *image, NSError *error, NSURL *imageURL))completedBlock;

- (void)startAnimatingWithGIFImageName:(NSString *)GIFImageName;
- (void)startAnimatingWithGIFImageName:(NSString *)GIFImageName repeatCount:(NSUInteger)repeatCount;

- (void)startAnimatingWithGIFImagePath:(NSString *)GIFImagePath;
- (void)startAnimatingWithGIFImagePath:(NSString *)GIFImagePath repeatCount:(NSUInteger)repeatCount;

- (void)startAnimatingWithImages:(NSArray<UIImage *> *)images duration:(CGFloat)duration;
- (void)startAnimatingWithImages:(NSArray<UIImage *> *)images duration:(CGFloat)duration repeatCount:(NSUInteger)repeatCount;

@end
