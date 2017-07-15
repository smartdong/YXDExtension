//
//  NSTimer+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import "NSTimer+YXDExtension.h"

@implementation NSTimer (YXDExtension)

+ (dispatch_source_t)countDownTimerForInterval:(NSUInteger)seconds repeatTimes:(NSUInteger)times action:(void (^)(NSUInteger))action completion:(void (^)(void))completion {
    __block NSUInteger count = times;
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    uint64_t nsec = (uint64_t)(seconds * NSEC_PER_SEC);
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 0), nsec, 0);
    
    dispatch_source_set_event_handler(timer, ^(){
        if (count == 0) {
            //cancel timer
            completion();
            dispatch_source_cancel(timer);
        } else {
            if (action) {
                action(count);
            }
            count--;
        }
    });
    dispatch_resume(timer);
    return timer;
}

+ (dispatch_source_t)repeatTimerForInterval:(NSTimeInterval)seconds action:(void (^)(void))action startImmdiately:(BOOL)startImmediately {
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    uint64_t nsec = (uint64_t)(seconds * NSEC_PER_SEC);
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 0), nsec, 0);
    
    dispatch_source_set_event_handler(timer, action);
    if (startImmediately) {
        dispatch_resume(timer);
    }
    return timer;
}

+ (dispatch_source_t)repeatTimerForInterval:(NSTimeInterval)seconds action:(void (^)(void))action {
    return [self repeatTimerForInterval:seconds action:action startImmdiately:YES];
}

+ (void)cancelTimer:(dispatch_source_t)timer {
    if (timer) {
        dispatch_source_cancel(timer);
#if !OS_OBJECT_USE_OBJC
        dispatch_release(timer);
#endif
    }
}

@end
