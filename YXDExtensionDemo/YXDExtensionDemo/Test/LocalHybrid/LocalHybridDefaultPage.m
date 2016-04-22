//
//  LocalHybridDefaultPage.m
//  YXDExtensionDemo
//
//  Created by zjdd on 16/4/21.
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import "LocalHybridDefaultPage.h"

@implementation LocalHybridDefaultPage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.url = [[NSBundle mainBundle] pathForResource:@"LocalHybridDefaultPage" ofType:@"html"];
}

@end
