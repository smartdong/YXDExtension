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
#import "City.h"
#import "YXDNetworkManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self jsonToObjectTest];
//    [self playGifTest];
//    [self fmdbHelperTest];
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    
//    [self downloadTest];
//}
//
//-(void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    
//    [[YXDNetworkManager sharedInstance] cancelAllTasks];
//}

- (void)downloadTest {
//    http://porn.yangxudong.me/resource/imgs/giftest.gif
//    http://porn.yangxudong.me/resource/data/resource.zip
    
    [[YXDNetworkManager sharedInstance] downloadWithURL:@"http://porn.yangxudong.me/resource/data/resource.zip"
                                              directory:[kDocuments.URL URLByAppendingPathComponent:@"H5"]
                                          loadingStatus:@"正在下载"
                                             completion:^(NSURL *filePath, NSError *error) {
                                                 NSLog(@"path : %@ \n error : %@",filePath.relativeString,error);
                                             }];
}

- (void)fmdbHelperTest {
    NSError *error = nil;
    NSArray *arr1 = [City selectAllObjectsWithError:&error];
    NSArray *arr2 = [City selectObjectsWithConditions:@[@"cityID < 50"] orderBy:@"cityID" asc:NO limit:@(5) error:&error];
    if (error) {
        NSLog(@"error : %@",error);
    } else {
        NSLog(@"arr1 : %@ \narr2 : %@",arr1,arr2);
    }
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
            arr = nil;
        }
    }];
}

- (void)playGifTest {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 200, 30, 60)];
    [self.view addSubview:imageView];
    [imageView startAnimatingWithGifImageName:@"loading"];
}

@end
