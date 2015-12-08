//
//  TestClass.h
//  YXDExtensionDemo
//
//  Created by zjdd on 15/12/7.
//  Copyright © 2015年 YangXudong. All rights reserved.
//

#import "YXDBaseObject.h"

@class ClassA;
@class ClassB;

@interface TestClass : YXDBaseObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSNumber *age;

@property (nonatomic, strong) ClassA *classA;

@property (nonatomic, strong) NSArray<ClassB *> *arrayClassB;

@end
