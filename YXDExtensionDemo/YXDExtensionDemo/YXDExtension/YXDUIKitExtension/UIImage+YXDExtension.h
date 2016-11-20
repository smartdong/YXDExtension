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

@interface UIGIFImageObject : NSObject

@property (nonatomic, strong) NSArray<UIImage *> *images;
@property (nonatomic, assign) CGFloat duration;

+ (UIGIFImageObject *)GIFImageObjectByData:(NSData *)data;
+ (UIGIFImageObject *)GIFImageObjectByImageName:(NSString *)imageName;
+ (UIGIFImageObject *)GIFImageObjectByImagePath:(NSString *)imagePath;

@end

@class ALAsset;

@interface UIImage (YXDExtension)

- (CGFloat)radius;

- (UIImage *)scaleToSize:(CGSize)size;

- (UIImage *)tintWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)roundedImageWithColor:(UIColor *)color size:(CGSize)size;

- (UIImage *)roundedImage;
- (UIImage *)roundedWithRadius:(NSUInteger)radius;
- (UIImage *)roundedWithMaskType:(UIImageRoundedCornerMaskType)maskType;
- (UIImage *)roundedWithRadius:(NSUInteger)radius maskType:(UIImageRoundedCornerMaskType)maskType;

+ (UIImage *)roundedImageNamed:(NSString *)name;
+ (UIImage *)imageNamed:(NSString *)name radius:(NSUInteger)radius;
+ (UIImage *)imageNamed:(NSString *)name maskType:(UIImageRoundedCornerMaskType)maskType;
+ (UIImage *)imageNamed:(NSString *)name radius:(NSUInteger)radius maskType:(UIImageRoundedCornerMaskType)maskType;
+ (UIImage *)roundedImageWithContentsOfFile:(NSString *)path;
+ (UIImage *)imageWithContentsOfFile:(NSString *)path radius:(NSUInteger)radius;
+ (UIImage *)imageWithContentsOfFile:(NSString *)path maskType:(UIImageRoundedCornerMaskType)maskType;
+ (UIImage *)imageWithContentsOfFile:(NSString *)path radius:(NSUInteger)radius maskType:(UIImageRoundedCornerMaskType)maskType;

+ (UIImage *)thumbnailImageWithALAsset:(ALAsset *)asset;
+ (UIImage *)fullScreenImageWithALAsset:(ALAsset *)asset;
+ (UIImage *)fullResolutionImageWithALAsset:(ALAsset *)asset;

@end
