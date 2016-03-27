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
    
    NSDictionary *dataDic = @{
                              @"propertyString"             : @"string" ,
                              @"propertyNumber"             : @(1) ,
                              @"propertyArray"              : @[@"1",@"2"] ,
                              @"propertyDictionary"         : @{@"key":@"value"} ,
                              @"propertyClass"              : [TestClass class] ,
                              @"propertyBlock"              : ^{NSLog(@"I'm a block");},
                              @"propertyObject"             : [TestClass new] ,
                              @"propertySEL"                : @"SEL" ,
                              @"propertyInteger"            : @(1) ,
                              @"propertyFloat"              : @(1.2) ,
                              @"propertyBool"               : @YES ,
                              
                              @"propertyMutableString"      : [NSMutableString stringWithString:@"MutableString"] ,
                              @"propertyMutableArray"       : [NSMutableArray arrayWithArray:@[@"1"]] ,
                              @"propertyMutableDictionary"  : [NSMutableDictionary dictionaryWithDictionary:@{@"1":@"2"}] ,
                              @"propertyInt"                : @(1) ,
                              @"propertyDouble"             : @(1.2345678) ,
                              @"propertyBoolean"            : @YES ,
                              @"propertyViewController"     : [UIViewController new] ,
                              @"propertyDate"               : [NSDate date] ,
                              @"propertyBlockWithArgs"      :  ^(NSString *name){NSLog(@"I'm %@",name);},
                              @"propertySize" : NSStringFromCGSize(CGSizeMake(100, 100)) ,
                              };
    
    NSLog(@"testClass : %@",[[TestClass objectWithData:dataDic] descriptionWithPropertyValues]);
    
//    ClassA *clsA = [ClassA new];
//    clsA.name = @"clsA";
//
//    ClassB *clsB = [ClassB new];
//    clsB.name = @"clsB";
//
//    ClassB *clsB2 = [ClassB new];
//    clsB2.name = @"clsB2";
    
//    [YXDCommonFunction printTimeCost:^{
//        TestClass *testClass1 = [TestClass objectWithData:@{
//                                                            @"name" : @"test",
//                                                            @"tureAge" : @"18" ,
//                                                            @"classA" : @{
//                                                                    @"name" : @"clsA" ,
//                                                                    @"classB" : @{
//                                                                            @"name" : @"cls2B"
//                                                                            },
//                                                                    },
//                                                            @"classB" : @[clsB,clsB2],
//                                                            @"classC" : @[@{@"key1":@{@"v1":@"v2"}},@{@"key2":@"value2"}],
//                                                            @"classD" : @[@"1",@"2"],
//                                                            @"returnData" : @{@"hehe":@"haha",@"hengheng":@{@"a":@"b"}}
//                                                            }];
//        NSLog(@"testClass1 : %@",[testClass1 descriptionWithPropertyValues]);
        
//        NSLog(@"testClass1 json : %@",testClass1.jsonString);
//        
//        TestClass *testClass2 = [TestClass objectWithJSONString:testClass1.jsonString];
//        
//        NSLog(@"testClass2 json : %@",testClass2.jsonString);
//    }];

//    NSArray *arr1 = @[testClass1,testClass2];
//    
//    NSString *arrJSON = [TestClass jsonStringFromObjectArray:arr1];
//    NSLog(@"arrJSON : %@",arrJSON);
//    
//    NSArray *arr2 = [TestClass objectArrayFromJSONString:arrJSON];
//    NSLog(@"arr2 : %@",[[arr2 description] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"]);
    
//    [YXDCommonFunction printTimeCost:^{
//        for (int i = 0; i < 10000; i++) {
//            TestClass *testClass1 = [TestClass objectWithData:@{
//                                                                @"name" : @"test",
//                                                                @"tureAge" : @"18" ,
//                                                                @"classA" : @{
//                                                                        @"name" : @"clsA" ,
//                                                                        @"classB" : @{
//                                                                                @"name" : @"cls2B"
//                                                                                },
//                                                                        },
//                                                                @"classB" : @[clsB,clsB2],
//                                                                @"classC" : @[@{@"key1":@{@"v1":@"v2"}},@{@"key2":@"value2"}],
//                                                                @"classD" : @[@"1",@"2"],
//                                                                @"returnData" : @{@"hehe":@"haha",@"hengheng":@{@"a":@"b"}}
//                                                                }];
//            
//            TestClass *testClass2 = [TestClass objectWithJSONString:testClass1.jsonString];
//            NSString *arrJSON = [TestClass jsonStringFromObjectArray:@[testClass1,testClass2]];
//            NSArray *arr = [TestClass objectArrayFromJSONString:arrJSON];
//        }
//    }];
}

@end
