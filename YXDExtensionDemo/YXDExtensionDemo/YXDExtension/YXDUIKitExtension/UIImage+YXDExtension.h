//
//  UIImage+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIGifImageData : NSObject
@property (nonatomic, strong) NSArray<UIImage *> *images;
@property (nonatomic, assign) CGFloat duration;
@end

@interface UIImage (YXDExtension)

//将GIF图片转化为图片数组 但是调用此方法需要引入系统库 ImageIO
+ (UIGifImageData *)gifImageDataByData:(NSData *)data;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

- (UIImage *)scaleToSize:(CGSize)size;

@end
