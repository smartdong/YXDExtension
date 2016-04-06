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

typedef void(^TestClassBlock)(NSString *string, NSError *error);

@interface TestClass : YXDBaseObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSNumber *age;

@property (nonatomic, strong) ClassA *classA;

@property (nonatomic, strong) NSArray<ClassB *> *arrayClassB;

@property (nonatomic, strong) NSArray<NSDictionary *> *arrayC;

@property (nonatomic, strong) NSArray<NSString *> *arrayD;

@property (nonatomic, strong) NSMutableDictionary *data;

@property (nonatomic, strong) NSDate *date;

@end
