//
//  YXDLocalHybridBaseWebViewController.m
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import "YXDLocalHybridBaseWebViewController.h"

@implementation YXDLocalHybridBaseWebViewController

- (void)setURL:(NSString *)URL {
    [super setURL:URL];
    
    if ([URL hasPrefix:@"/"]) {
        self.showLoadingBar = NO;
    } else {
        self.showLoadingBar = YES;
    }
}

@end
