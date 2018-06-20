//
//  YXDBaseViewController.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "YXDBaseViewController.h"
#import "UITableView+YXDExtension.h"

@interface YXDBaseViewController ()

@end

@implementation YXDBaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.navigationController.viewControllers.firstObject == self) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if (self.showBackItem || (self.navigationController.viewControllers.firstObject != self)) {
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"xxx"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
//    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ : %@",self,NSStringFromSelector(_cmd));
}

#pragma mark - Actions

- (void)tableViewConfig {
    if (!self.tableView) {
        if ([self.view isKindOfClass:[UITableView class]]) {
            self.tableView = (UITableView *)self.view;
        } else {
            for (UIView *view in self.view.subviews) {
                if ([view isKindOfClass:[UITableView class]]) {
                    self.tableView = (UITableView *)view;
                    break;
                }
            }
        }
        
        self.tableView.dataSource   = (id<UITableViewDataSource>)self;
        self.tableView.delegate     = (id<UITableViewDelegate>)self;
    }
    
    [self.tableView hideFooterView];
    
    if (self.tableView.style == UITableViewStyleGrouped) {
        [self.tableView hideGroupHeaderView];
    }
}

- (void)collectionViewConfig {
    if (!self.collectionView) {
        if ([self.view isKindOfClass:[UICollectionView class]]) {
            self.collectionView = (UICollectionView *)self.view;
        } else {
            for (UIView *view in self.view.subviews) {
                if ([view isKindOfClass:[UICollectionView class]]) {
                    self.collectionView = (UICollectionView *)view;
                    break;
                }
            }
        }
        
        self.collectionView.dataSource  = (id<UICollectionViewDataSource>)self;
        self.collectionView.delegate    = (id<UICollectionViewDelegate>)self;
    }
}

- (void)popViewController {
    if (self.navigationController.viewControllers.firstObject == self) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
