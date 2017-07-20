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

- (void)setImageWithURLString:(NSString *)URLString placeholderImage:(UIImage *)placeholderImage {
    [self sd_setImageWithURL:URLString.URL placeholderImage:placeholderImage];
}

- (void)setImageWithURLString:(NSString *)URLString placeholderImage:(UIImage *)placeholderImage completed:(void (^)(UIImage *, NSError *, NSURL *))completedBlock {
    [self sd_setImageWithURL:URLString.URL placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image,error,imageURL);
        }
    }];
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
    UIGIFImageObject *object = [UIGIFImageObject GIFImageObjectByImagePath:GIFImagePath];
    [self startAnimatingWithImages:object.images duration:object.duration repeatCount:repeatCount];
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
