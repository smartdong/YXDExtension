//
//  RefreshTestTableViewController.m
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import "RefreshTestTableViewController.h"
#import "UITableView+YXDExtension.h"
#import "UIScrollView+YXDExtension.h"

@interface RefreshTestTableViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) NSInteger count;

@end

@implementation RefreshTestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView registerDefaultCell];
    
    [self.tableView addLoadStatusViewWithPullLoadingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.count = 10;
            [self.tableView setStatusSuccess];
//            [self.tableView setStatusFail];
        });
    } footerLoadingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.count < 50) {
                self.count += 10;
            } else {
                [self.tableView noticeFooterNoMoreData];
            }
            [self.tableView setStatusSuccess];
        });
    }];
    
    [self.tableView setTitle:@"没有内容了啊啊" imageName:@"imgNoInformation" forStatus:YXDLoadStatusEmpty];
    [self.tableView setTitle:@"加载失败了啊喂" imageName:@"imgNoInformation" forStatus:YXDLoadStatusFailed];
    
//    [self.tableView setTitle:nil imageName:@"imgNoInformation" forStatus:YXDLoadStatusEmpty];
//    [self.tableView setTitle:nil imageName:@"imgNoInformation" forStatus:YXDLoadStatusFailed];
    
//    [self.tableView setTitle:@"没有内容了啊啊" imageName:nil forStatus:YXDLoadStatusEmpty];
//    [self.tableView setTitle:@"加载失败了啊喂" imageName:nil forStatus:YXDLoadStatusFailed];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView triggerLoading];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithDefaultIdentifier];
    cell.textLabel.text = [NSString stringWithFormat:@"index row : %d",(int)indexPath.row];
    return cell;
}

@end
