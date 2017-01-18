//
//  UIWebView+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright © 2017年 YangXudong. All rights reserved.
//

#import "UIWebView+YXDExtension.h"

@implementation UIWebView (YXDExtension)

- (void)clearLoad {
    self.delegate = nil;
    [self stopLoading];
    [self removeFromSuperview];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end
