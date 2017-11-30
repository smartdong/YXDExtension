//
//  UIViewController+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, YXDViewShowPosition) {
    YXDViewShowPositionCenter   = 0,
    
    YXDViewShowPositionTop      = 1 << 1,
    YXDViewShowPositionBottom   = 2 << 1,
    
    YXDViewShowPositionLeft     = 1 << 3,
    YXDViewShowPositionRight    = 2 << 3,
};

typedef NS_ENUM(NSInteger, YXDViewControllerPresentType) {
    YXDViewControllerPresentTypeNone,
    YXDViewControllerPresentTypePresent,
    YXDViewControllerPresentTypePopover,
};

typedef void(^YXDExtensionImagePickerBlock)(UIImage *image);

@interface UIViewController (YXDExtension)

- (UINavigationController *)parentNavigationController;

- (void)presentView:(UIView *)view position:(YXDViewShowPosition)position;
- (void)presentView:(UIView *)view position:(YXDViewShowPosition)position offset:(UIOffset)offset animated:(BOOL)animated;
- (void)dismissView;
- (void)dismissViewAnimated:(BOOL)animated completion:(void (^)(void))completion;

- (void)presentInViewController:(UIViewController *)viewController type:(YXDViewControllerPresentType)type;
- (void)presentInViewController:(UIViewController *)viewController type:(YXDViewControllerPresentType)type offset:(UIOffset)offset resize:(BOOL)resize needBlackBackground:(BOOL)needBlackBackground;
- (void)dismissInViewController;
- (void)dismissInViewControllerWithCompletion:(void (^)(void))completion;

- (void)pushViewControllerHidesBottomBar:(UIViewController *)viewController;

- (void)setLeftBarItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (void)setLeftBarItemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action;

- (void)setRightBarItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;
- (void)setRightBarItemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action;

- (void)imageByCameraAndPhotosAlbum:(YXDExtensionImagePickerBlock)imageBlock allowsEditing:(BOOL)allowsEditing;

@end
