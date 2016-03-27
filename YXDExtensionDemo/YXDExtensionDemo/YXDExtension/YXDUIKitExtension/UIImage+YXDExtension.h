//
//  UIImage+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    UIImageRoundedCornerMaskTypeTopLeft = 1,
    UIImageRoundedCornerMaskTypeTopRight = 1 << 1,
    UIImageRoundedCornerMaskTypeBottomRight = 1 << 2,
    UIImageRoundedCornerMaskTypeBottomLeft = 1 << 3,
    UIImageRoundedCornerMaskTypeAll = UIImageRoundedCornerMaskTypeTopLeft | UIImageRoundedCornerMaskTypeTopRight | UIImageRoundedCornerMaskTypeBottomRight | UIImageRoundedCornerMaskTypeBottomLeft
} UIImageRoundedCornerMaskType;

@interface UIGifImageData : NSObject

@property (nonatomic, strong) NSArray<UIImage *> *images;
@property (nonatomic, assign) CGFloat duration;

@end

@interface UIImage (YXDExtension)

//将GIF图片转化为图片数组 但是调用此方法需要引入系统库 ImageIO
+ (UIGifImageData *)gifImageDataByData:(NSData *)data;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)roundedImageWithColor:(UIColor *)color size:(CGSize)size;

- (UIImage *)scaleToSize:(CGSize)size;

- (UIImage *)roundedImage;

- (UIImage *)radius:(NSUInteger)radius;

- (UIImage *)radius:(NSUInteger)radius maskType:(UIImageRoundedCornerMaskType)maskType;

+ (UIImage *)roundedImageNamed:(NSString *)name;

+ (UIImage *)imageNamed:(NSString *)name radius:(NSUInteger)radius;

+ (UIImage *)imageNamed:(NSString *)name radius:(NSUInteger)radius maskType:(UIImageRoundedCornerMaskType)maskType;

+ (UIImage *)roundedImageWithContentsOfFile:(NSString *)path;

+ (UIImage *)imageWithContentsOfFile:(NSString *)path radius:(NSUInteger)radius;

+ (UIImage *)imageWithContentsOfFile:(NSString *)path radius:(NSUInteger)radius maskType:(UIImageRoundedCornerMaskType)maskType;

@end
