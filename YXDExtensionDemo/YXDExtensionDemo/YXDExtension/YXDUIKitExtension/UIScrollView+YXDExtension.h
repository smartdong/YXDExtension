//
//  UIScrollView+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YXDExtensionScrollViewState) {
    YXDExtensionScrollViewStateLoading,
    YXDExtensionScrollViewStateSuccess,
    YXDExtensionScrollViewStateEmpty,
    YXDExtensionScrollViewStateFailed
};

@interface UIScrollView (YXDExtension)

- (void)setTitle:(NSString *)title imageName:(NSString *)imageName forState:(YXDExtensionScrollViewState)state;

- (void)setTitleLableTouchBlock:(dispatch_block_t)block forState:(YXDExtensionScrollViewState)state;

- (void)setState:(YXDExtensionScrollViewState)state;

@end
