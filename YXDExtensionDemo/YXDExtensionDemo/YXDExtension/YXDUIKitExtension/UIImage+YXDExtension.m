//
//  UIImage+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "UIImage+YXDExtension.h"

@implementation UIGifImageData
@end

#if __has_include(<ImageIO/ImageIO.h>)
#import <ImageIO/ImageIO.h>
#endif

@implementation UIImage (YXDExtension)

- (CGFloat)radius {
    return ((self.size.width < self.size.height) ? self.size.width : self.size.height) / 2;
}

+ (UIGifImageData *)gifImageDataByData:(NSData *)data {
#if __has_include(<ImageIO/ImageIO.h>)
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)data, NULL);
    CGFloat animationTime = 0.f;
    if (src) {
        size_t l = CGImageSourceGetCount(src);
        frames = [NSMutableArray arrayWithCapacity:l];
        for (size_t i = 0; i < l; i++) {
            CGImageRef img = CGImageSourceCreateImageAtIndex(src, i, NULL);
            NSDictionary *properties = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(src, i, NULL));
            NSDictionary *frameProperties = [properties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
            NSNumber *delayTime = [frameProperties objectForKey:(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
            animationTime += [delayTime floatValue];
            if (img) {
                [frames addObject:[UIImage imageWithCGImage:img]];
                CGImageRelease(img);
            }
        }
        CFRelease(src);
    }
    
    if (frames.count) {
        UIGifImageData *imageData = [UIGifImageData new];
        imageData.images = frames;
        imageData.duration = animationTime;
        return imageData;
    }
#else
    NSLog(@"need include <ImageIO/ImageIO.h>");
#endif
    return nil;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)roundedImageWithColor:(UIColor *)color size:(CGSize)size {
    return [[self imageWithColor:color size:size] roundedImage];
}

- (UIImage *)scaleToSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, YES, self.scale);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)roundedImage {
    return [self roundedWithRadius:self.radius];
}

- (UIImage *)roundedWithRadius:(NSUInteger)radius {
    return [self roundedWithRadius:radius maskType:UIImageRoundedCornerMaskTypeAll];
}

- (UIImage *)roundedWithMaskType:(UIImageRoundedCornerMaskType)maskType {
    return [self roundedWithRadius:self.radius maskType:maskType];
}

- (UIImage *)roundedWithRadius:(NSUInteger)radius maskType:(UIImageRoundedCornerMaskType)maskType {
    CGRect imageRect = CGRectMake(0, 0, self.size.width * self.scale, self.size.height * self.scale);
    radius *= self.scale;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, imageRect.size.width, imageRect.size.height, 8, 4 * imageRect.size.width, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, imageRect, radius, maskType);
    CGContextClosePath(context);
    CGContextClip(context);
    
    CGContextDrawImage(context, imageRect, self.CGImage);
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *newImage = [UIImage imageWithCGImage:imageMasked scale:self.scale orientation:UIImageOrientationUp];
    CGImageRelease(imageMasked);
    return newImage;
}

+ (UIImage *)roundedImageNamed:(NSString *)name {
    return [[self imageNamed:name] roundedImage];
}

+ (UIImage *)imageNamed:(NSString *)name radius:(NSUInteger)radius {
    return [[self imageNamed:name] roundedWithRadius:radius];
}

+ (UIImage *)imageNamed:(NSString *)name maskType:(UIImageRoundedCornerMaskType)maskType {
    UIImage *image = [self imageNamed:name];
    return [image roundedWithRadius:image.radius maskType:maskType];
}

+ (UIImage *)imageNamed:(NSString *)name radius:(NSUInteger)radius maskType:(UIImageRoundedCornerMaskType)maskType {
    return [[self imageNamed:name] roundedWithRadius:radius maskType:maskType];
}

+ (UIImage *)roundedImageWithContentsOfFile:(NSString *)path {
    return [[self imageWithContentsOfFile:path] roundedImage];
}

+ (UIImage *)imageWithContentsOfFile:(NSString *)path radius:(NSUInteger)radius {
    return [[self imageWithContentsOfFile:path] roundedWithRadius:radius];
}

+ (UIImage *)imageWithContentsOfFile:(NSString *)path maskType:(UIImageRoundedCornerMaskType)maskType {
    UIImage *image = [self imageWithContentsOfFile:path];
    return [image roundedWithRadius:image.radius maskType:maskType];
}

+ (UIImage *)imageWithContentsOfFile:(NSString *)path radius:(NSUInteger)radius maskType:(UIImageRoundedCornerMaskType)maskType {
    return [[self imageWithContentsOfFile:path] roundedWithRadius:radius maskType:maskType];
}

#pragma mark - 

//UIKit坐标系统原点在左上角，y方向向下的（坐标系A），但在Quartz中坐标系原点在左下角，y方向向上的(坐标系B)。图片绘制也是颠倒的。
static void addRoundedRectToPath(CGContextRef context, CGRect rect, float radius, UIImageRoundedCornerMaskType maskType)
{
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + radius);
    
    CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height - radius);
    
    //如果左上角需要画圆角，画出一个弧线出来。
    if (maskType & UIImageRoundedCornerMaskTypeTopLeft) {
        CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, radius, M_PI, M_PI / 2, 1);
    } else {
        CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height);
        CGContextAddLineToPoint(context, rect.origin.x + radius, rect.origin.y + rect.size.height);
    }
    
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height);
    
    //画右上角
    if (maskType & UIImageRoundedCornerMaskTypeTopRight) {
        CGContextAddArc(context, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height - radius, radius, M_PI / 2, 0.0f, 1);
    } else {
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height - radius);
    }
    
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + radius);
    
    //画右下角弧线
    if (maskType & UIImageRoundedCornerMaskTypeBottomRight) {
        CGContextAddArc(context, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, radius, 0.0f, -M_PI / 2, 1);
    } else {
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y);
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - radius, rect.origin.y);
    }
    
    CGContextAddLineToPoint(context, rect.origin.x + radius, rect.origin.y);
    
    //画左下角弧线
    if (maskType & UIImageRoundedCornerMaskTypeBottomLeft) {
        CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + radius, radius, -M_PI / 2, M_PI, 1);
    } else {
        CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y);
        CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + radius);
    }
    
    CGContextClosePath(context);
}

@end
