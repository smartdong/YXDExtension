//
//  YXDBaseViewController.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "YXDBaseViewController.h"

@implementation YXDBaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if (self.navigationController.viewControllers.firstObject != self) {
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"xxx"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
//    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ : %@",self,NSStringFromSelector(_cmd));
}

#pragma mark - Actions

//- (void)popViewController {
//    [self.navigationController popViewControllerAnimated:YES];
//}

@end
