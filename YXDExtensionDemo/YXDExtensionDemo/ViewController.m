//
//  ViewController.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "ViewController.h"
#import "YXDExtensionHeader.h"
#import "TestClass.h"
#import "ClassA.h"
#import "ClassB.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ClassA *clsA = [ClassA new];
    clsA.name = @"clsA";
    
    ClassB *clsB = [ClassB new];
    clsB.name = @"clsB";
    
    TestClass *testClass = [TestClass objectWithData:@{
                                                       @"name" : @"test",
                                                       @"tureAge" : @"18" ,
                                                       @"classA" : @{
                                                               @"name" : @"clsA" ,
                                                               @"classB" : @{
                                                                       @"name" : @"cls2B"
                                                                       },
                                                               },
                                                       @"classB" : @[clsB]
                                                       }];
    NSLog(@"test class : %@",testClass);
}

@end
