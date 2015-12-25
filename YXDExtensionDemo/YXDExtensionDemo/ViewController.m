//
//  ViewController.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "ViewController.h"
#import "YXDExtensionHeader.h"
//#import "TestClass.h"
//#import "ClassA.h"
//#import "ClassB.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    ClassA *clsA = [ClassA new];
//    clsA.name = @"clsA";
//    
//    ClassB *clsB = [ClassB new];
//    clsB.name = @"clsB";
//    
//    ClassB *clsB2 = [ClassB new];
//    clsB2.name = @"clsB2";
    
//    TestClass *testClass1 = [TestClass objectWithData:@{
//                                                       @"name" : @"test",
//                                                       @"tureAge" : @"18" ,
//                                                       @"classA" : @{
//                                                               @"name" : @"clsA" ,
//                                                               @"classB" : @{
//                                                                       @"name" : @"cls2B"
//                                                                       },
//                                                               },
//                                                       @"classB" : @[clsB,clsB2]
//                                                       }];
//    NSLog(@"testClass1 : %@",testClass1);
//    
//    NSLog(@"testClass1 json : %@",testClass1.jsonString);
//    
//    TestClass *testClass2 = [TestClass objectWithJSONString:testClass1.jsonString];
//    
//    NSLog(@"testClass2 json : %@",testClass2.jsonString);
//    
//    NSArray *arr1 = @[testClass1,testClass2];
//    
//    NSString *arrJSON = [TestClass jsonStringFromObjectArray:arr1];
//    NSLog(@"arrJSON : %@",arrJSON);
//    
//    NSArray *arr2 = [TestClass objectArrayFromJSONString:arrJSON];
//    NSLog(@"arr2 : %@",[[arr2 description] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"]);
    
    
//    NSTimeInterval begin = [[NSDate date] timeIntervalSince1970];
//    
//    for (int i = 0; i < 10000; i++) {
//        TestClass *testClass1 = [TestClass objectWithData:@{
//                                                            @"name" : @"test",
//                                                            @"tureAge" : @"18" ,
//                                                            @"classA" : @{
//                                                                    @"name" : @"clsA" ,
//                                                                    @"classB" : @{
//                                                                            @"name" : @"cls2B"
//                                                                            },
//                                                                    },
//                                                            @"classB" : @[clsB,clsB2]
//                                                            }];
//        
//        TestClass *testClass2 = [TestClass objectWithJSONString:testClass1.jsonString];
//        NSString *arrJSON = [TestClass jsonStringFromObjectArray:@[testClass1,testClass2]];
//        NSArray *arr = [TestClass objectArrayFromJSONString:arrJSON];
//    }
//    
//    NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
//    
//    NSLog(@"cost time : %lf",(end - begin));
}

@end
