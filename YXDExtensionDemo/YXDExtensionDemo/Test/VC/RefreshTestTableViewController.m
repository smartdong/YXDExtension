//
//  RefreshTestTableViewController.m
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import "RefreshTestTableViewController.h"
#import "UITableView+YXDExtension.h"

@interface RefreshTestTableViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation RefreshTestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView registerDefaultCell];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithDefaultIdentifier];
    cell.textLabel.text = [NSString stringWithFormat:@"index row : %d",(int)indexPath.row];
    return cell;
}

@end
