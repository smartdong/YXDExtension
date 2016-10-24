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

- (void)startAnimatingWithGIFImageName:(NSString *)GIFImageName {
    [self startAnimatingWithGIFImageName:GIFImageName repeatCount:0];
}

- (void)startAnimatingWithGIFImageName:(NSString *)GIFImageName repeatCount:(NSUInteger)repeatCount {
    [self startAnimatingWithGIFImagePath:[[NSBundle mainBundle] pathForResource:GIFImageName ofType:@".gif"] repeatCount:repeatCount];
}

- (void)startAnimatingWithGIFImagePath:(NSString *)GIFImagePath {
    [self startAnimatingWithGIFImagePath:GIFImagePath repeatCount:0];
}

- (void)startAnimatingWithGIFImagePath:(NSString *)GIFImagePath repeatCount:(NSUInteger)repeatCount {
    UIGIFImageData *imageData = [UIImage GIFImageDataByData:[NSData dataWithContentsOfFile:GIFImagePath]];
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
