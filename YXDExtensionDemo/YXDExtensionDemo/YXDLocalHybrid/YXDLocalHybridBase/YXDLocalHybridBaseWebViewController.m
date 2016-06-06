//
//  YXDLocalHybridBaseWebViewController.m
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import "YXDLocalHybridBaseWebViewController.h"

@implementation YXDLocalHybridBaseWebViewController

- (void)setUrl:(NSString *)url {
    [super setUrl:url];
    
    if ([url hasPrefix:@"/"]) {
        self.showLoadingBar = NO;
    } else {
        self.showLoadingBar = YES;
    }
}

@end
