//
//  YXDTouchIDHelper.m
//
//  Created by dd .
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "YXDTouchIDHelper.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation YXDTouchIDHelper

+(void)useTouchIDWithMessage:(NSString *)message
                     success:(void (^)())successBlock
                      failed:(void (^)())failedBlock {
    
    LAContext *context = [LAContext new];
//    context.localizedFallbackTitle = @"";
    
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
            localizedReason:message
                      reply:^(BOOL success, NSError *error) {
                          
                          if (success) {
                              if (successBlock) {
                                  successBlock();
                              }
                          } else {
                              if (failedBlock) {
                                  failedBlock();
                              }
                          }
    }];
}

+(BOOL)canUseTouchID {
    return [[LAContext new] canEvaluatePolicy: LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
}

@end
