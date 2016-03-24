//
//  NSObject+YXDSwizzlingExtension.m
//  YXDExtensionDemo
//
//  Created by zjdd on 15/12/7.
//  Copyright © 2015年 YangXudong. All rights reserved.
//

#import "NSObject+YXDSwizzlingExtension.h"
#import "YXDSwizzlingExtensionDefine.h"
#import "NSObject+YXDExtension.h"

@implementation NSObject (YXDSwizzlingExtension)

//黑魔法不能乱用 改写description方法容易造成循环调用
//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        swizzling_exchangeMethod([NSObject class], @selector(description), @selector(swizzling_description));
//    });
//}

- (NSString *)swizzling_description{
    return [NSString stringWithFormat:@"%@ %@",[self swizzling_description],[self allPropertyValues]];
}

@end
