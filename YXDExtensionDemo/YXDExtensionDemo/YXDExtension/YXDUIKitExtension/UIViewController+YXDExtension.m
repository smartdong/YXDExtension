//
//  UIViewController+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#define ActionSheetTag              250

#import "UIViewController+YXDExtension.h"
#import <objc/runtime.h>
#import "UINavigationItem+YXDExtension.h"

@interface UIViewController()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, copy) YXDExtensionImagePickerBlock imageBlock;

@end

static const void *YXDExtensionImagePickerBlockKey = &YXDExtensionImagePickerBlockKey;

@implementation UIViewController (YXDExtension)

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

/**
 *  使用相机或相册获取图片
 *
 *  @param block 参数为获取的图片/图片名称/图片路径
 */
- (void)imageByCameraAndPhotosAlbum:(YXDExtensionImagePickerBlock)imageBlock {
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
    
    as.tag = ActionSheetTag;
    
    if (self.tabBarController) {
        [as showFromTabBar:self.tabBarController.tabBar];
    } else {
        [as showInView:self.view];
    }
}

#pragma mark - Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == ActionSheetTag) {
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
        
        imagePickerController.allowsEditing = YES;
        
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

#pragma mark - Image Picker Delegte

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];

    if (self.imageBlock) {
        self.imageBlock(image);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 存取block

-(void)setImageBlock:(YXDExtensionImagePickerBlock)imageBlock {
    objc_setAssociatedObject(self, YXDExtensionImagePickerBlockKey, imageBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(YXDExtensionImagePickerBlock)imageBlock {
    return objc_getAssociatedObject(self, YXDExtensionImagePickerBlockKey);
}

@end
