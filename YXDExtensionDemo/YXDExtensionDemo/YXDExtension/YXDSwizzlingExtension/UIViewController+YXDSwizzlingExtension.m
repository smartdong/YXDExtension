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
//        swizzling_exchangeMethod([UIViewController class], @selector(awakeFromNib), @selector(swizzling_awakeFromNib));
//        swizzling_exchangeMethod([UIViewController class], @selector(initWithNibName:bundle:), @selector(swizzling_initWithNibName:bundle:));
//        swizzling_exchangeMethod([UIViewController class] ,@selector(viewDidLoad),    @selector(swizzling_viewDidLoad));
//        swizzling_exchangeMethod([UIViewController class] ,@selector(viewWillAppear:), @selector(swizzling_viewWillAppear:));
//        swizzling_exchangeMethod([UIViewController class] ,@selector(viewDidAppear:), @selector(swizzling_viewDidAppear:));
//        swizzling_exchangeMethod([UIViewController class] ,@selector(viewWillDisappear:), @selector(swizzling_viewWillDisappear:));
//        swizzling_exchangeMethod([UIViewController class] ,@selector(viewDidDisappear:), @selector(swizzling_viewDidDisappear:));
//        swizzling_exchangeMethod([UIViewController class] ,@selector(dealloc),    @selector(swizzling_dealloc));
//    });
//}

#pragma mark - AwakeFromNib
- (void)swizzling_awakeFromNib{
    NSLog(@"%@ : %@",self,NSStringFromSelector(_cmd));
    [self swizzling_awakeFromNib];
}

#pragma mark - InitWithNibName:bundle:
- (instancetype)swizzling_initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    id instance = [self swizzling_initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (instance) {
        NSLog(@"%@ : %@",self,NSStringFromSelector(_cmd));
    }
    return instance;
}

#pragma mark - ViewDidLoad
- (void)swizzling_viewDidLoad{
    NSLog(@"%@ : %@",self,NSStringFromSelector(_cmd));
    [self swizzling_viewDidLoad];
}

#pragma mark - ViewWillAppear
- (void)swizzling_viewWillAppear:(BOOL)animated{
    NSLog(@"%@ : %@",self,NSStringFromSelector(_cmd));
    [self swizzling_viewWillAppear:animated];
}

#pragma mark - ViewDidAppear
- (void)swizzling_viewDidAppear:(BOOL)animated{
    NSLog(@"%@ : %@",self,NSStringFromSelector(_cmd));
    [self swizzling_viewDidAppear:animated];
}

#pragma mark - ViewWillDisappear
- (void)swizzling_viewWillDisappear:(BOOL)animated{
    NSLog(@"%@ : %@",self,NSStringFromSelector(_cmd));
    [self swizzling_viewWillDisappear:animated];
}

#pragma mark - ViewDidDisappear
- (void)swizzling_viewDidDisappear:(BOOL)animated{
    NSLog(@"%@ : %@",self,NSStringFromSelector(_cmd));
    [self swizzling_viewDidDisappear:animated];
}

#pragma mark - Dealloc
- (void)swizzling_dealloc{
    NSLog(@"%@ : %@",self,NSStringFromSelector(_cmd));
    [self swizzling_dealloc];
}

@end
