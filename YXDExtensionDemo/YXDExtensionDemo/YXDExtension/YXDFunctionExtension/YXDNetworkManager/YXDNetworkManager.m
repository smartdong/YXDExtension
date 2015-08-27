//
//  YXDNetworkManager.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "YXDNetworkManager.h"
#import "AFNetworking.h"
#import "YXDHUDManager.h"

@interface YXDNetworkManager ()

@property (nonatomic, strong) AFHTTPRequestOperationManager  *requsetManager;

@end

@implementation YXDNetworkManager





































#pragma mark - Init

+(instancetype)sharedInstance {
    static YXDNetworkManager *networkManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkManager = [[YXDNetworkManager new] commonInit];
    });
    
    return networkManager;
}

- (instancetype) commonInit {
    self.requsetManager = [AFHTTPRequestOperationManager new];
    self.requsetManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"application/json",@"text/plain",@"text/javascript",nil];
    self.requsetManager.requestSerializer.timeoutInterval = 15; //设置超时
    return self;
}

@end
