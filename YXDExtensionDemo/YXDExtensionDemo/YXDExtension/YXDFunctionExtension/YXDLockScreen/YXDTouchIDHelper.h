//
//  YXDTouchIDHelper.h
//
//  Created by dd .
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXDTouchIDHelper : NSObject

+ (void) useTouchIDWithMessage:(NSString *)message
                       success:(void(^)())successBlock
                        failed:(void(^)())failedBlock;

+ (BOOL) canUseTouchID;

@end
