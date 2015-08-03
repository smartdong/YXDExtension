//
//  UIScreen+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "UIScreen+YXDExtension.h"

@implementation UIScreen (YXDExtension)

- (CGFloat)screenWidth {
    return [self screenSize].width;
}

- (CGFloat)screenHeight {
    return [self screenSize].height;
}

- (CGSize)screenSize {
    return [UIScreen mainScreen].bounds.size;
}

@end
