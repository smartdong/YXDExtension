//
//  UIButton+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIButtonImageAlignment) {
    UIButtonImageAlignmentLeft  = 0, // default
    UIButtonImageAlignmentRight = 1,
};

@interface UIButton (YXDExtension)

- (void)setImageAlignment:(UIButtonImageAlignment)imageAlignment;

- (void)unavailable;
- (void)available;

@end
