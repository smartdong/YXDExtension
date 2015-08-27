//
//  UIViewController+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YXDExtensionImagePickerBlock)(UIImage *image);

@interface UIViewController (YXDExtension)

- (void)pushViewControllerHidesBottomBar:(UIViewController *)viewController;

- (void)setLeftBarItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (void)setLeftBarItemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action;

- (void)setRightBarItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (void)setRightBarItemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action;

#pragma mark -

/**
 *  使用相机或相册获取图片
 */
- (void) imageByCameraAndPhotosAlbum:(YXDExtensionImagePickerBlock)imageBlock;

@end
