//
//  ALAsset+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>

@class UIImage;

@interface ALAsset (YXDExtension)

- (UIImage *)thumbnailImage;
- (UIImage *)fullScreenImage;
- (UIImage *)fullResolutionImage;

- (NSDictionary *)metadata;

@end
