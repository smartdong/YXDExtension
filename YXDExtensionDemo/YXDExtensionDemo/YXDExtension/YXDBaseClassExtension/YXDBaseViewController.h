//
//  YXDBaseViewController.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXDBaseViewController : UIViewController

@property (nonatomic, assign) BOOL showBackItem;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (void)tableViewConfig;
- (void)collectionViewConfig;

- (void)popViewController;

@end
