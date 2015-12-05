//
//  YXDBaseScrollView.h
//  YXDExtensionDemo
//
//  Created by YangXudong on 15/9/27.
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YXDBaseScrollViewState) {
    YXDBaseScrollViewStateUndefined = 0,
    YXDBaseScrollViewStateLoading   = 1,
    YXDBaseScrollViewStateSuccess   = 2,
    YXDBaseScrollViewStateEmpty     = 3,
    YXDBaseScrollViewStateFailed    = 4
};

@interface YXDBaseScrollView : UIScrollView

@property (nonatomic, copy) dispatch_block_t pullLoadingBlock;  //下拉刷新的block 如果不设置则表示不需要下拉刷新
@property (nonatomic, copy) dispatch_block_t footerLoadingBlock;//上提加载的block 如果不设置则表示不需要上提加载 且如果没有设置pullLoadingBlock时无效

@property (nonatomic, assign) BOOL reloadDataWhenTouchFailedOrEmptyImage;//当失败或者结果为空时 点击图片或标签是否重新加载数据 默认为 YES

- (void)setTitle:(NSString *)title imageName:(NSString *)imageName forState:(YXDBaseScrollViewState)state; //仅 YXDBaseScrollViewStateEmpty 和 YXDBaseScrollViewStateFailed 有效

//获取当前状态
- (YXDBaseScrollViewState)currentState;

//设置完pullLoadingBlock以后 调用此方法开始刷新
- (void)startLoading;

@end
