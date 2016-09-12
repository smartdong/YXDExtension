//
//  NSTimer+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (YXDExtension)

+ (dispatch_source_t)countDownTimerForInterval:(NSUInteger)seconds repeatTimes:(NSUInteger)times action:(void (^)(NSUInteger count))action completion:(void (^)(void))completion;
+ (void)cancelTimer:(dispatch_source_t)timer;
+ (dispatch_source_t)repeatTimerForInterval:(NSTimeInterval)seconds action:(void (^)(void))action startImmdiately:(BOOL)startImmediately;
+ (dispatch_source_t)repeatTimerForInterval:(NSTimeInterval)seconds action:(void (^)(void))action;

@end
