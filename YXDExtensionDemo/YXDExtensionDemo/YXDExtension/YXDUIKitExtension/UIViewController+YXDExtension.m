//
//  UIViewController+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "UIViewController+YXDExtension.h"
#import <objc/runtime.h>
#import "UINavigationItem+YXDExtension.h"
#import "UIView+YXDExtension.h"
#import "NSObject+YXDExtension.h"

@interface UIViewController()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, copy) YXDExtensionImagePickerBlock imageBlock;

@property (nonatomic, strong) NSNumber *presentType;
@property (nonatomic, strong) NSNumber *needBlackBackground;
@property (nonatomic, strong) NSNumber *originPopGestureRecognizerEnabled;

@end

static const void *YXDExtensionImagePickerBlockKey                  = &YXDExtensionImagePickerBlockKey;
static const void *YXDExtensionPresentTypeKey                       = &YXDExtensionPresentTypeKey;
static const void *YXDExtensionNeedBlackBackgroundKey               = &YXDExtensionNeedBlackBackgroundKey;
static const void *YXDExtensionOriginPopGestureRecognizerEnabledKey = &YXDExtensionOriginPopGestureRecognizerEnabledKey;

static const NSInteger kYXDExtensionActionSheetTag                  = 250;
static const NSInteger kYXDExtensionBgViewTag                       = 1008611;
static const NSInteger kYXDExtensionPresentViewTag                  = 1001011;
static const NSInteger kYXDExtensionPresentViewControllerViewTag    = 1795111;

static const CGFloat kYXDExtensionPresentViewControllerViewBgAlpha  = 0.5;

static const CGFloat kYXDExtensionPresentViewAnimationDuration      = 0.25;

static const NSString *kYXDExtensionPresentViewOriginPositionKey    = @"kYXDExtensionPresentViewOriginPositionKey";
static const NSString *kYXDExtensionPresentViewNormalPositionKey    = @"kYXDExtensionPresentViewNormalPositionKey";

@implementation UIViewController (YXDExtension)

- (UINavigationController *)parentNavigationController {
    if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)self.parentViewController;
    } else if ([self.parentViewController.navigationController isKindOfClass:[UINavigationController class]]) {
        return self.parentViewController.navigationController;
    }
    return nil;
}

- (void)presentView:(UIView *)view position:(YXDViewShowPosition)position {
    [self presentView:view position:position offset:UIOffsetZero animated:YES];
}

- (void)presentView:(UIView *)view position:(YXDViewShowPosition)position offset:(UIOffset)offset animated:(BOOL)animated {
    if (!view) {
        return;
    }
    
    UIView *bgview = [self.view viewWithTag:kYXDExtensionBgViewTag];
    if (!bgview) {
        bgview = [[UIView alloc] initWithFrame:self.view.bounds];
        bgview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        bgview.alpha = 0;
        bgview.tag = kYXDExtensionBgViewTag;
        [self.view addSubview:bgview];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
        [bgview addGestureRecognizer:tap];
    }
    
    BOOL top    = ((position & YXDViewShowPositionTop)      == YXDViewShowPositionTop);
    BOOL bottom = ((position & YXDViewShowPositionBottom)   == YXDViewShowPositionBottom);
    BOOL left   = ((position & YXDViewShowPositionLeft)     == YXDViewShowPositionLeft);
    BOOL right  = ((position & YXDViewShowPositionRight)    == YXDViewShowPositionRight);
    
    NSInteger originX = 0;
    NSInteger originY = 0;
    NSInteger normalX = 0;
    NSInteger normalY = 0;
    
    if (left) {
        originX = -view.width;
        normalX = 0;
    } else if (right) {
        originX = self.view.width;
        normalX = self.view.width - view.width;
    } else {
        originX = (self.view.width - view.width)/2.;
        normalX = originX;
    }
    
    if (top) {
        if (left || right) {
            originY = 0;
            normalY = originY;
        } else {
            originY = -view.height;
            normalY = 0;
        }
    } else if (bottom) {
        if (left || right) {
            originY = self.view.height - view.height;
            normalY = originY;
        } else {
            originY = self.view.height;
            normalY = self.view.height - view.height;
        }
    } else {
        if (left || right) {
            originY = (self.view.height - view.height)/2.;
            normalY = originY;
        } else {
            originY = self.view.height;
            normalY = (self.view.height - view.height)/2.;
        }
    }
    
    CGPoint originPosition = CGPointMake(originX + offset.horizontal, originY + offset.vertical);
    CGPoint normalPosition = CGPointMake(normalX + offset.horizontal, normalY + offset.vertical);
    
    view.userData = @{kYXDExtensionPresentViewOriginPositionKey:NSStringFromCGPoint(originPosition),kYXDExtensionPresentViewNormalPositionKey:NSStringFromCGPoint(normalPosition)};
    view.origin = originPosition;
    view.tag = kYXDExtensionPresentViewTag;
    [self.view addSubview:view];
    
    bgview.alpha = 0;
    bgview.hidden = NO;
    [UIView animateWithDuration:animated?kYXDExtensionPresentViewAnimationDuration:0 animations:^{
        bgview.alpha = 1;
        view.origin = normalPosition;
    }];
}

- (void)dismissView {
    [self dismissViewAnimated:YES completion:nil];
}

- (void)dismissViewAnimated:(BOOL)animated completion:(void (^)(void))completion {
    UIView *view = [self.view viewWithTag:kYXDExtensionPresentViewTag];
    
    if (!view) {
        return;
    }
    
    UIView *bgview = [self.view viewWithTag:kYXDExtensionBgViewTag];
    
    [UIView animateWithDuration:animated?kYXDExtensionPresentViewAnimationDuration:0 animations:^{
        bgview.alpha = 0;
        view.origin = CGPointFromString([((NSDictionary *)view.userData) objectForKey:kYXDExtensionPresentViewOriginPositionKey]);
    } completion:^(BOOL finished) {
        bgview.hidden = YES;
        [view removeFromSuperview];
        
        if (completion) {
            completion();
        }
    }];
}

- (void)presentInViewController:(UIViewController *)viewController type:(YXDViewControllerPresentType)type {
    [self presentInViewController:viewController type:type offset:UIOffsetZero resize:YES needBlackBackground:NO];
}

- (void)presentInViewController:(UIViewController *)viewController type:(YXDViewControllerPresentType)type offset:(UIOffset)offset resize:(BOOL)resize needBlackBackground:(BOOL)needBlackBackground {
    if (!viewController) {
        return;
    }
    
    self.presentType = @(type);
    self.needBlackBackground = @(needBlackBackground);
    
    if (needBlackBackground) {
        UIView *bg = [[UIView alloc] initWithFrame:viewController.view.bounds];
        bg.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:kYXDExtensionPresentViewControllerViewBgAlpha];
        bg.alpha = 0;
        bg.tag = kYXDExtensionPresentViewControllerViewTag;
        [viewController.view addSubview:bg];
        [UIView animateWithDuration:kYXDExtensionPresentViewAnimationDuration animations:^{
            bg.alpha = 1;
        }];
    }
    
    self.view.alpha = 0;
    
    CGRect frame = self.view.frame;
    frame.origin.x += offset.horizontal;
    frame.origin.y += offset.vertical;
    if (resize) {
        frame.size.width = viewController.view.width;
        frame.size.height = viewController.view.height;
    }
    self.view.frame = frame;
    
    [viewController addChildViewController:self];
    [viewController.view addSubview:self.view];
    
    self.originPopGestureRecognizerEnabled = @([self parentNavigationController].interactivePopGestureRecognizer.enabled);
    [self parentNavigationController].interactivePopGestureRecognizer.enabled = NO;
    
    switch ((YXDViewControllerPresentType)self.presentType.integerValue) {
        case YXDViewControllerPresentTypePresent:
        {
            CGRect originFrame = frame;
            frame.origin.y = viewController.view.size.height;
            self.view.frame = frame;
            self.view.alpha = 1;
            
            [UIView animateWithDuration:kYXDExtensionPresentViewAnimationDuration animations:^{
                self.view.frame = originFrame;
            }];
        }
            break;
        case YXDViewControllerPresentTypePopover:
        {
            self.view.transform = CGAffineTransformMakeScale(0.01, 0.01);
            self.view.alpha = 1;
            
            [UIView animateWithDuration:kYXDExtensionPresentViewAnimationDuration animations:^{
                self.view.transform = CGAffineTransformIdentity;
            }];
        }
            break;
        case YXDViewControllerPresentTypeNone:
        default:
        {
            self.view.alpha = 1;
        }
            break;
    }
}

- (void)dismissInViewController {
    [self dismissInViewControllerWithCompletion:nil];
}

- (void)dismissInViewControllerWithCompletion:(void (^)(void))completion {
    if (self.needBlackBackground.boolValue) {
        UIView *bg = [self.parentViewController.view viewWithTag:kYXDExtensionPresentViewControllerViewTag];
        [UIView animateWithDuration:kYXDExtensionPresentViewAnimationDuration animations:^{
            bg.alpha = 0;
        } completion:^(BOOL finished) {
            [bg removeFromSuperview];
        }];
    }
    
    dispatch_block_t animationCompletion = ^{
        [self parentNavigationController].interactivePopGestureRecognizer.enabled = self.originPopGestureRecognizerEnabled.boolValue;
        
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        
        if (completion) {
            completion();
        }
    };
    
    switch ((YXDViewControllerPresentType)self.presentType.integerValue) {
        case YXDViewControllerPresentTypePresent:
        {
            CGRect originFrame = self.view.frame;
            originFrame.origin.y = self.parentViewController.view.frame.size.height;
            
            [UIView animateWithDuration:kYXDExtensionPresentViewAnimationDuration animations:^{
                self.view.frame = originFrame;
            } completion:^(BOOL finished) {
                animationCompletion();
            }];
        }
            break;
        case YXDViewControllerPresentTypePopover:
        {
            [UIView animateWithDuration:kYXDExtensionPresentViewAnimationDuration animations:^{
                self.view.transform = CGAffineTransformMakeScale(0.01, 0.01);
            } completion:^(BOOL finished) {
                animationCompletion();
            }];
        }
            break;
        case YXDViewControllerPresentTypeNone:
        default:
        {
            animationCompletion();
        }
            break;
    }
}

- (void)pushViewControllerHidesBottomBar:(UIViewController *)viewController {
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)setLeftBarItemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    [self.navigationItem setLeftBarItemWithTitle:title target:target action:action];
}

- (void)setLeftBarItemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action {
    [self.navigationItem setLeftBarItemWithImageName:imageName target:target action:action];
}

- (void)setRightBarItemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    [self.navigationItem setRightBarItemWithTitle:title target:target action:action];
}

- (void)setRightBarItemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action {
    [self.navigationItem setRightBarItemWithImageName:imageName target:target action:action];
}

#pragma mark -

- (void)imageByCameraAndPhotosAlbum:(YXDExtensionImagePickerBlock)imageBlock allowsEditing:(BOOL)allowsEditing {
    self.imageBlock = imageBlock;
    
    UIActionSheet *as = nil;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        as = [[UIActionSheet alloc] initWithTitle:@"选择"
                                         delegate:self
                                cancelButtonTitle:@"取消"
                           destructiveButtonTitle:nil
                                otherButtonTitles:@"相机",@"从相册选择", nil];
    } else {
        as = [[UIActionSheet alloc] initWithTitle:@"选择"
                                         delegate:self
                                cancelButtonTitle:@"取消"
                           destructiveButtonTitle:nil
                                otherButtonTitles:@"从相册选择", nil];
    }
    
    as.tag = kYXDExtensionActionSheetTag;
    as.userData = @(allowsEditing);
    
    if (self.tabBarController) {
        [as showFromTabBar:self.tabBarController.tabBar];
    } else {
        [as showInView:self.view];
    }
}

#pragma mark - Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == kYXDExtensionActionSheetTag) {
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex)
            {
                case 2:
                    // 取消
                    return;
                case 0:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                default:
                    break;
            }
        } else {
            if (buttonIndex == 0) {
                //相册
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            } else {
                //取消
                return;
            }
        }
        
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        
        imagePickerController.delegate = self;
        
        imagePickerController.allowsEditing = ((NSNumber *)actionSheet.userData).boolValue;
        
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

#pragma mark - Image Picker Delegte

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:picker.allowsEditing?UIImagePickerControllerEditedImage:UIImagePickerControllerOriginalImage];
    
    if (self.imageBlock) {
        self.imageBlock(image);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 存取block

- (void)setImageBlock:(YXDExtensionImagePickerBlock)imageBlock {
    objc_setAssociatedObject(self, YXDExtensionImagePickerBlockKey, imageBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (YXDExtensionImagePickerBlock)imageBlock {
    return objc_getAssociatedObject(self, YXDExtensionImagePickerBlockKey);
}

- (void)setPresentType:(NSNumber *)presentType {
    objc_setAssociatedObject(self, YXDExtensionPresentTypeKey, presentType, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)presentType {
    return objc_getAssociatedObject(self, YXDExtensionPresentTypeKey);
}

- (void)setNeedBlackBackground:(NSNumber *)needBlackBackground {
    objc_setAssociatedObject(self, YXDExtensionNeedBlackBackgroundKey, needBlackBackground, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)needBlackBackground {
    return objc_getAssociatedObject(self, YXDExtensionNeedBlackBackgroundKey);
}

- (void)setOriginPopGestureRecognizerEnabled:(NSNumber *)originPopGestureRecognizerEnabled {
    objc_setAssociatedObject(self, YXDExtensionOriginPopGestureRecognizerEnabledKey, originPopGestureRecognizerEnabled, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)originPopGestureRecognizerEnabled {
    return objc_getAssociatedObject(self, YXDExtensionOriginPopGestureRecognizerEnabledKey);
}

@end
