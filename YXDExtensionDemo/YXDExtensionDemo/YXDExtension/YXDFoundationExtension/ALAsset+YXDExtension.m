//
//  ALAsset+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import "ALAsset+YXDExtension.h"
#import <UIKit/UIImage.h>

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

@end
