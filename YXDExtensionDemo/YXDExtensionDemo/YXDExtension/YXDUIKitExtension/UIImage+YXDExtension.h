//
//  UIImage+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YXDExtension)

//将GIF图片转化为图片数组 但是调用此方法需要引入系统库 ImageIO
+ (NSArray *)imagesByGifData:(NSData *)gifData;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

- (UIImage *)scaleToSize:(CGSize)size;

@end
