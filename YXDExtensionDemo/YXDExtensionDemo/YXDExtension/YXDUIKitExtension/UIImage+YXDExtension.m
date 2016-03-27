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
    UIGraphicsBeginImageContext(rect.size);
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
    size.width /= self.scale;
    size.height /= self.scale;
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, YES, self.scale);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (UIImage *)roundedImage {
    CGFloat radius = (self.size.width > self.size.height) ? self.size.height : self.size.width;
    return [self radius:radius];
}

- (UIImage *)radius:(NSUInteger)radius {
    return [self radius:radius maskType:UIImageRoundedCornerMaskTypeAll];
}

- (UIImage *)radius:(NSUInteger)radius maskType:(UIImageRoundedCornerMaskType)maskType {
    
    UIImageView *bkImageViewTmp = [[UIImageView alloc] initWithImage:self];
    
    int w = self.size.width;
    int h = self.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context,bkImageViewTmp.frame, radius, maskType);
    CGContextClosePath(context);
    CGContextClip(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), self.CGImage);
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *newImage = [UIImage imageWithCGImage:imageMasked];
    
    CGImageRelease(imageMasked);
    
    return newImage;
}

+ (UIImage *)roundedImageNamed:(NSString *)name {
    return [[self imageNamed:name] roundedImage];
}

+ (UIImage *)imageNamed:(NSString *)name radius:(NSUInteger)radius {
    return [[self imageNamed:name] radius:radius];
}

+ (UIImage *)imageNamed:(NSString *)name radius:(NSUInteger)radius maskType:(UIImageRoundedCornerMaskType)maskType {
    return [[self imageNamed:name] radius:radius maskType:maskType];
}

+ (UIImage *)roundedImageWithContentsOfFile:(NSString *)path {
    return [[self imageWithContentsOfFile:path] roundedImage];
}

+ (UIImage *)imageWithContentsOfFile:(NSString *)path radius:(NSUInteger)radius {
    return [[self imageWithContentsOfFile:path] radius:radius];
}

+ (UIImage *)imageWithContentsOfFile:(NSString *)path radius:(NSUInteger)radius maskType:(UIImageRoundedCornerMaskType)maskType {
    return [[self imageWithContentsOfFile:path] radius:radius maskType:maskType];
}

#pragma mark - 

//UIKit坐标系统原点在左上角，y方向向下的（坐标系A），但在Quartz中坐标系原点在左下角，y方向向上的(坐标系B)。图片绘制也是颠倒的。
static void addRoundedRectToPath(CGContextRef context, CGRect rect, float radius, UIImageRoundedCornerMaskType maskType)
{
    //原点在左下方，y方向向上。移动到线条2的起点。
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + radius);
    
    //画出线条2, 目前画线的起始点已经移动到线条2的结束地方了。
    CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height - radius);
    
    //如果左上角需要画圆角，画出一个弧线出来。
    if (maskType & UIImageRoundedCornerMaskTypeTopLeft) {
        
        //已左上的正方形的右下脚为圆心，半径为radius， 180度到90度画一个弧线，
        CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + rect.size.height - radius,
                        radius, M_PI, M_PI / 2, 1);
    }
    
    else {
        //如果不需要画左上角的弧度。从线2终点，画到线3的终点，
        CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height);
        
        //线3终点，画到线4的起点
        CGContextAddLineToPoint(context, rect.origin.x + radius, rect.origin.y + rect.size.height);
    }
    
    //画线4的起始，到线4的终点
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - radius,
                            rect.origin.y + rect.size.height);
    
    //画右上角
    if (maskType & UIImageRoundedCornerMaskTypeTopRight) {
        CGContextAddArc(context, rect.origin.x + rect.size.width - radius,
                        rect.origin.y + rect.size.height - radius, radius, M_PI / 2, 0.0f, 1);
    }
    else {
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height - radius);
    }
    
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + radius);
    
    //画右下角弧线
    if (maskType & UIImageRoundedCornerMaskTypeBottomRight) {
        CGContextAddArc(context, rect.origin.x + rect.size.width - radius, rect.origin.y + radius,
                        radius, 0.0f, -M_PI / 2, 1);
    }
    else {
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y);
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - radius, rect.origin.y);
    }
    
    CGContextAddLineToPoint(context, rect.origin.x + radius, rect.origin.y);
    
    //画左下角弧线
    if (maskType & UIImageRoundedCornerMaskTypeBottomLeft) {
        CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + radius, radius,
                        -M_PI / 2, M_PI, 1);
    }
    else {
        CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y);
        CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + radius);
    }
    
    CGContextClosePath(context);
}

@end
