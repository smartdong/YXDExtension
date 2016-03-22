//
//  UIImageView+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "UIImageView+YXDExtension.h"
#import "UIImageView+WebCache.h"
#import "NSString+YXDExtension.h"

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

- (void)setAnimationWithImageNames:(NSArray *)imageNames duration:(CGFloat)duration {
    self.animationImages = imageNames;
    self.animationDuration = duration;
    self.animationRepeatCount = 0;
    [self startAnimating];
}

@end
