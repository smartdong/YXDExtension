//
//  UIViewController+YXDSwizzlingExtension.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "UIViewController+YXDSwizzlingExtension.h"
#import "YXDSwizzlingExtensionDefine.h"

@implementation UIViewController (YXDSwizzlingExtension)

//+ (void)load{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        swizzling_exchangeMethod([self class] ,@selector(initWithNibName:bundle:), @selector(swizzling_initWithNibName:bundle:));
//        swizzling_exchangeMethod([self class] ,@selector(viewDidLoad),    @selector(swizzling_viewDidLoad));
//        swizzling_exchangeMethod([self class] ,@selector(viewWillAppear:), @selector(swizzling_viewWillAppear:));
//        swizzling_exchangeMethod([self class] ,@selector(viewDidAppear:), @selector(swizzling_viewDidAppear:));
//        swizzling_exchangeMethod([self class] ,@selector(viewWillDisappear:), @selector(swizzling_viewWillDisappear:));
//        swizzling_exchangeMethod([self class] ,@selector(viewDidDisappear:), @selector(swizzling_viewDidDisappear:));
//    });
//}

#pragma mark - Life Cycle

- (instancetype)swizzling_initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    id instance = [self swizzling_initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (instance) {
        NSLog(@"%@ : %@",self,NSStringFromSelector(_cmd));
    }
    return instance;
}

- (void)swizzling_viewDidLoad{
    NSLog(@"%@ : %@",self,NSStringFromSelector(_cmd));
    [self swizzling_viewDidLoad];
}

- (void)swizzling_viewWillAppear:(BOOL)animated{
    NSLog(@"%@ : %@",self,NSStringFromSelector(_cmd));
    [self swizzling_viewWillAppear:animated];
}

- (void)swizzling_viewDidAppear:(BOOL)animated{
    NSLog(@"%@ : %@",self,NSStringFromSelector(_cmd));
    [self swizzling_viewDidAppear:animated];
}

- (void)swizzling_viewWillDisappear:(BOOL)animated{
    NSLog(@"%@ : %@",self,NSStringFromSelector(_cmd));
    [self swizzling_viewWillDisappear:animated];
}

- (void)swizzling_viewDidDisappear:(BOOL)animated{
    NSLog(@"%@ : %@",self,NSStringFromSelector(_cmd));
    [self swizzling_viewDidDisappear:animated];
}

@end
