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
             @"age" : @"tureAge" ,
             };
}

@end
