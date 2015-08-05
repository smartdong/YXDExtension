//
//  UIViewController+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YXDExtensionImagePickerBlock)(UIImage *image);

@interface UIViewController (YXDExtension)

/**
 *  使用相机或相册获取图片
 */
- (void) imageByCameraAndPhotosAlbum:(YXDExtensionImagePickerBlock)imageBlock;

@end
