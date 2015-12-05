//
//  YXDBaseScrollView.m
//  YXDExtensionDemo
//
//  Created by YangXudong on 15/9/27.
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#define YXDBaseScrollViewStateTitleEmpty        @"暂无内容"
#define YXDBaseScrollViewStateTitleFailed       @"加载失败,点击重试"

#import "YXDBaseScrollView.h"

@interface YXDBaseScrollView ()

@property (nonatomic, assign) YXDBaseScrollViewState state;
@property (nonatomic, assign) YXDBaseScrollViewState lastState;

@end

@implementation YXDBaseScrollView

#pragma mark -

-(void)startLoading {
    if (!self.pullLoadingBlock) {
        return;
    }
    
    self.state = YXDBaseScrollViewStateLoading;
    
    
}

-(YXDBaseScrollViewState)currentState {
    return _state;
}

#pragma mark -

- (void)setState:(YXDBaseScrollViewState)state {
    
    if (_state == state) {
        return;
    }
    
    _lastState = _state;
    _state = state;
    
    switch (state) {
        case YXDBaseScrollViewStateLoading:
        {
            if (_lastState == YXDBaseScrollViewStateSuccess) {
                return;
            }
            
            //显示加载中的view
            
        }
            break;
        case YXDBaseScrollViewStateSuccess:
        {
            
        }
            break;
        case YXDBaseScrollViewStateEmpty:
        {
            
        }
            break;
        case YXDBaseScrollViewStateFailed:
        {
            
        }
            break;
        default:
            break;
    }
}

-(void)setPullLoadingBlock:(dispatch_block_t)pullLoadingBlock {
    _pullLoadingBlock = pullLoadingBlock;
    
    //设置下拉刷新
    [self setUpPullLoadingMethod];
    
    //初始化加载状态view
    [self setUpLoadingView];
}

-(void)setFooterLoadingBlock:(dispatch_block_t)footerLoadingBlock {
    if (!self.pullLoadingBlock) {
        return;
    }
    
    _footerLoadingBlock = footerLoadingBlock;
    
    //设置上提加载
    [self setUpFooterLoadingMethod];
}

#pragma mark -

- (void)setTitle:(NSString *)title imageName:(NSString *)imageName forState:(YXDBaseScrollViewState)state {
    
}

#pragma mark - 

- (void)setUpLoadingView {
    
}

- (void)setUpPullLoadingMethod {
    
}

- (void)setUpFooterLoadingMethod {
    
}

#pragma mark - Init 

-(instancetype)init {
    self = [super init];
    
    _state = YXDBaseScrollViewStateUndefined;
    _lastState = YXDBaseScrollViewStateUndefined;
    
    return self;
}

@end
