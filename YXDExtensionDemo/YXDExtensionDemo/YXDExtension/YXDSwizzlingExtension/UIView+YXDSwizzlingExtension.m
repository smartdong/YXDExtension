//
//  UIView+YXDSwizzlingExtension.m
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import "UIView+YXDSwizzlingExtension.h"
#import "YXDSwizzlingExtensionDefine.h"

@implementation UIView (YXDSwizzlingExtension)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzling_exchangeMethod([self class] ,@selector(setNeedsLayout), @selector(swizzling_setNeedsLayout));
        swizzling_exchangeMethod([self class] ,@selector(setNeedsDisplay), @selector(swizzling_setNeedsDisplay));
        swizzling_exchangeMethod([self class] ,@selector(setNeedsDisplayInRect:), @selector(swizzling_setNeedsDisplayInRect:));
    });
}

#pragma mark - Display

- (void)swizzling_setNeedsLayout {
    dispatch_async(dispatch_get_main_queue(),^{
//        NSLog(@"%@ : %@",self,NSStringFromSelector(_cmd));
        [self swizzling_setNeedsLayout];
    });
}

- (void)swizzling_setNeedsDisplay {
    dispatch_async(dispatch_get_main_queue(),^{
//        NSLog(@"%@ : %@",self,NSStringFromSelector(_cmd));
        [self swizzling_setNeedsDisplay];
    });
}

- (void)swizzling_setNeedsDisplayInRect:(CGRect)rect {
    dispatch_async(dispatch_get_main_queue(),^{
//        NSLog(@"%@ : %@",self,NSStringFromSelector(_cmd));
        [self swizzling_setNeedsDisplayInRect:rect];
    });
}

@end
