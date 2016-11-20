//
//  ALAsset+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import "ALAsset+YXDExtension.h"
#import <UIKit/UIImage.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <ImageIO/ImageIO.h>

@implementation ALAsset (YXDExtension)

- (UIImage *)thumbnailImage {
    return [[UIImage alloc] initWithCGImage:self.thumbnail];
}

- (UIImage *)fullScreenImage {
    return [[UIImage alloc] initWithCGImage:self.defaultRepresentation.fullScreenImage];
}

- (UIImage *)fullResolutionImage {
    return [[UIImage alloc] initWithCGImage:self.defaultRepresentation.fullResolutionImage];
}

- (NSDictionary *)metadata {
    return self.defaultRepresentation.metadata;
}

- (NSData *)fullResolutionImageData {
    NSMutableData *imageData = [NSMutableData data];
    CGImageDestinationRef imageDestination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)imageData, (__bridge CFStringRef)self.defaultRepresentation.UTI, 1, NULL);
    CGImageDestinationAddImage(imageDestination, self.defaultRepresentation.fullResolutionImage, (__bridge CFDictionaryRef)self.defaultRepresentation.metadata);
    if (!CGImageDestinationFinalize(imageDestination)) {
        imageData = nil;
    }
    CFRelease(imageDestination);
    return imageData;
}

@end
