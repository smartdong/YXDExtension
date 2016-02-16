//
//  TestClass.m
//  YXDExtensionDemo
//
//  Created by zjdd on 15/12/7.
//  Copyright © 2015年 YangXudong. All rights reserved.
//

#import "TestClass.h"
#import "ClassB.h"

@implementation TestClass

-(NSDictionary *)propertyMap {
    return @{
             @"arrayClassB" : @{@"classB" : [ClassB class]} ,
             @"arrayC"      : @{@"classC" : [NSDictionary class]} ,
             @"arrayD"      : @{@"classD" : [NSString class]} ,
             @"age"         : @"tureAge" ,
             @"data"        : @"returnData",
             };
}

@end
