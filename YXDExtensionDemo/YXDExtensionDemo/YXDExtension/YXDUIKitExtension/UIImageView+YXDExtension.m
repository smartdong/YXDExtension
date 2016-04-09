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

- (void)setImageWithUrlString:(NSString *)urlString {
    [self sd_setImageWithURL:urlString.url];
}

- (void)setImageWithUrlString:(NSString *)urlString placeholderImageName:(NSString *)placeholderImageName {
    [self sd_setImageWithURL:urlString.url placeholderImage:[UIImage imageNamed:placeholderImageName]];
}

- (void)setAnimationWithGifImageName:(NSString *)gifImageName {
    [self setAnimationWithGifImagePath:[[NSBundle mainBundle] pathForResource:gifImageName ofType:@".gif"]];
}

- (void)setAnimationWithGifImagePath:(NSString *)gifImagePath {
    UIGifImageData *imageData = [UIImage gifImageDataByData:[NSData dataWithContentsOfFile:gifImagePath]];
    [self setAnimationWithImages:imageData.images duration:imageData.duration];
}

- (void)setAnimationWithImages:(NSArray<UIImage *> *)images duration:(CGFloat)duration {
    if (!images.count) {
        return;
    }
    self.animationImages = images;
    self.animationDuration = duration;
    self.animationRepeatCount = 0;
    [self startAnimating];
}

@end
