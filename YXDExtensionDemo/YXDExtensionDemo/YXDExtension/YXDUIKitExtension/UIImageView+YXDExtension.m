//
//  UIImageView+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "UIImageView+YXDExtension.h"
#import "UIImageView+WebCache.h"
#import "NSString+YXDExtension.h"
#import "UIImage+YXDExtension.h"

@implementation UIImageView (YXDExtension)

- (void)setImageWithName:(NSString *)name {
    self.image = [UIImage imageNamed:name];
}

- (void)setImageWithURLString:(NSString *)URLString {
    [self sd_setImageWithURL:URLString.URL];
}

- (void)setImageWithURLString:(NSString *)URLString placeholderImageName:(NSString *)placeholderImageName {
    [self sd_setImageWithURL:URLString.URL placeholderImage:[UIImage imageNamed:placeholderImageName]];
}

- (void)startAnimatingWithGifImageName:(NSString *)gifImageName {
    [self startAnimatingWithGifImageName:gifImageName repeatCount:0];
}

- (void)startAnimatingWithGifImageName:(NSString *)gifImageName repeatCount:(NSUInteger)repeatCount {
    [self startAnimatingWithGifImagePath:[[NSBundle mainBundle] pathForResource:gifImageName ofType:@".gif"] repeatCount:repeatCount];
}

- (void)startAnimatingWithGifImagePath:(NSString *)gifImagePath {
    [self startAnimatingWithGifImagePath:gifImagePath repeatCount:0];
}

- (void)startAnimatingWithGifImagePath:(NSString *)gifImagePath repeatCount:(NSUInteger)repeatCount {
    UIGifImageData *imageData = [UIImage gifImageDataByData:[NSData dataWithContentsOfFile:gifImagePath]];
    [self startAnimatingWithImages:imageData.images duration:imageData.duration repeatCount:repeatCount];
}

- (void)startAnimatingWithImages:(NSArray<UIImage *> *)images duration:(CGFloat)duration {
    [self startAnimatingWithImages:images duration:duration repeatCount:0];
}

- (void)startAnimatingWithImages:(NSArray<UIImage *> *)images duration:(CGFloat)duration repeatCount:(NSUInteger)repeatCount {
    if (!images.count) {
        return;
    }
    self.animationImages = images;
    self.animationDuration = duration;
    self.animationRepeatCount = repeatCount;
    [self startAnimating];
}

@end
