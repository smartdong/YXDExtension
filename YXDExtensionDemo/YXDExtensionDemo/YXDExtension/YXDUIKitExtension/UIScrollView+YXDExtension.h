//
//  UIScrollView+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YXDLoadStatus) {
    YXDLoadStatusLoading   = 1,
    YXDLoadStatusSuccess   = 2,
    YXDLoadStatusEmpty     = 3,
    YXDLoadStatusFailed    = 4,
};

@interface UIScrollView (YXDExtension)

- (void)triggerLoading;
- (void)setStatusSuccess;
- (void)setStatusFail;
- (void)setStatusEmpty;

- (void)noticeFooterNoMoreData;

//无 pullLoadingBlock 时 此方法无效
- (void)addLoadStatusViewWithPullLoadingBlock:(dispatch_block_t)pullLoadingBlock footerLoadingBlock:(dispatch_block_t)footerLoadingBlock;

//仅 YXDLoadStatusEmpty 和 YXDLoadStatusFailed 有效
- (void)setTitle:(NSString *)title imageName:(NSString *)imageName forStatus:(YXDLoadStatus)status;

@end
