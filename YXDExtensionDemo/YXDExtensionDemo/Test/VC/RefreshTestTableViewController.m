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
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.count = 10;
            [self.tableView setStatusSuccess];
        });
    } footerLoadingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.count < 50) {
                self.count += 10;
            } else {
                [self.tableView noticeFooterNoMoreData];
            }
            [self.tableView setStatusSuccess];
        });
    }];
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
