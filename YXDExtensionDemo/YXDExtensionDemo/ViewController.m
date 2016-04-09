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
    
//    [self jsonToObjectTest];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 200, 30, 60)];
    [self.view addSubview:imageView];
    [imageView startAnimatingWithGifImageName:@"loading"];
}

- (void)jsonToObjectTest {
    ClassA *clsA = [ClassA new];
    clsA.name = @"clsA";
    
    ClassB *clsB = [ClassB new];
    clsB.name = @"clsB";
    
    ClassB *clsB2 = [ClassB new];
    clsB2.name = @"clsB2";
    
    [YXDCommonFunction printTimeCost:^{
        for (int i = 0; i < 10000; i++) {
            TestClass *testClass1 = [TestClass objectWithData:@{
                                                                @"name" : @"test",
                                                                @"tureAge" : @"18" ,
                                                                @"classA" : @{
                                                                        @"name" : @"clsA" ,
                                                                        @"classB" : @{
                                                                                @"name" : @"cls2B"
                                                                                },
                                                                        },
                                                                @"classB" : @[clsB,clsB2],
                                                                @"classC" : @[@{@"key1":@{@"v1":@"v2"}},@{@"key2":@"value2"}],
                                                                @"classD" : @[@"1",@"2"],
                                                                @"returnData" : @{@"hehe":@"haha",@"hengheng":@{@"a":@"b"}},
                                                                @"date" : @([[NSDate date] timeIntervalSince1970]),
                                                                @"readonlyTest" : @(213),
                                                                }];
            TestClass *testClass2 = [TestClass objectWithJSONString:testClass1.jsonString];
            NSString *arrJSON = [TestClass jsonStringFromObjectArray:@[testClass1,testClass2]];
            NSArray *arr = [TestClass objectArrayFromJSONString:arrJSON];
        }
    }];
}

@end
