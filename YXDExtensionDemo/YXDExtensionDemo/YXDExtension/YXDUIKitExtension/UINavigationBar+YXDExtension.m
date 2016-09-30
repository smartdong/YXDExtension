//
//  UINavigationBar+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "UINavigationBar+YXDExtension.h"
#import <objc/runtime.h>

@interface UINavigationBar ()

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) UIImageView *systemBackgroundView;

@end

static const void *YXDExtensionBackViewKey = &YXDExtensionBackViewKey;

static const void *YXDExtensionSystemBackgroundViewKey = &YXDExtensionSystemBackgroundViewKey;

@implementation UINavigationBar (YXDExtension)

- (void)setSeparatorLineHidden:(BOOL)hidden {
    UIImageView *separatorLine = [self.subviews firstObject].subviews.firstObject;
    if ([separatorLine isKindOfClass:[UIImageView class]] && (separatorLine.bounds.size.width == [UIScreen mainScreen].bounds.size.width) && (separatorLine.bounds.size.height <= 1)) {
        separatorLine.hidden = hidden;
    }
}

- (void)setBarBackgroundColor:(UIColor *)backgroundColor {
    if (!self.backView) {
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, 64)];
        self.backView.userInteractionEnabled = NO;
        [self insertSubview:self.backView atIndex:0];
    }
    
    if (self.systemBackgroundView.alpha > 0) {
        self.systemBackgroundView.alpha = 0;
    }
    
    self.backView.backgroundColor = backgroundColor;
}

- (void)setBarBackgroundAlpha:(CGFloat)alpha {
    self.systemBackgroundView.alpha = alpha;
}

- (void)resetBarColor {
    self.systemBackgroundView.alpha = 1;
    [self.backView removeFromSuperview];
    self.backView = nil;
}

#pragma mark -

- (void)setBackView:(UIView *)backView {
    objc_setAssociatedObject(self, YXDExtensionBackViewKey, backView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)backView {
    return objc_getAssociatedObject(self, YXDExtensionBackViewKey);
}

- (void)setSystemBackgroundView:(UIImageView *)systemBackgroundView {
    objc_setAssociatedObject(self, YXDExtensionSystemBackgroundViewKey, systemBackgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)systemBackgroundView {
    UIImageView *backgroundView = objc_getAssociatedObject(self, YXDExtensionSystemBackgroundViewKey);
    
    if (!backgroundView) {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                self.systemBackgroundView = (UIImageView *)view;
                backgroundView = (UIImageView *)view;
                break;
            }
        }
    }
    
    return backgroundView;
}

@end
