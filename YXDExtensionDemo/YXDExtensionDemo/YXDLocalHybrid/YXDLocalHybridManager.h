//
//  YXDLocalHybridManager.h
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXDLocalHybridManager : NSObject

@property (nonatomic, assign, readonly, getter=isUpdating) BOOL updating;
@property (nonatomic, assign, readonly, getter=isUpdated) BOOL updated;

- (UIViewController *)rootViewController;

+ (instancetype)sharedInstance;

@end
