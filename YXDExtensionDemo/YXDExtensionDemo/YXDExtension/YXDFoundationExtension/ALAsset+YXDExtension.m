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

- (UIImage *)defaultRepresentationImage {
    return [[UIImage alloc] initWithCGImage:self.defaultRepresentation.fullScreenImage];
}

@end
