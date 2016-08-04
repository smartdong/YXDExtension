//
//  ViewController.m
//  YXDExtensionDemo
//
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "ViewController.h"
#import "YXDExtensionHeader.h"
#import "YXDFileManager.h"
#import "TestClass.h"
#import "ClassA.h"
#import "ClassB.h"
#import "City.h"
#import "GirlFriend.h"
#import "YXDFilterView.h"
#import "YXDFMDBHelper.h"

@interface ViewController ()<YXDFilterViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) YXDFilterView *filterView;

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self jsonToObjectTest];
//    [self playGifTest];
//    [self imageCornerTest];
//    [self fmdbHelperTest];
//    [self filterViewTest];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [self downloadTest];
//    [self HUDTest];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
//    [SVProgressHUD dismiss];
//    [[YXDNetworkManager sharedInstance] cancelAllTasks];
}

- (void)HUDTest {
    [YXDHUDManager showWithDuration:3 completion:^{
        NSLog(@"1");
    }];
    
    [YXDHUDManager showWithDuration:4 completion:^{
        NSLog(@"2");
    }];

    [YXDHUDManager showWithDuration:2 completion:^{
        NSLog(@"3");
    }];
    
    [YXDHUDManager showSuccessAndAutoDismissWithTitle:@"呵呵" completion:^{
        NSLog(@"4");
    }];
}

- (void)unzipWithZipFilePath:(NSString *)zipFilePath destinationPath:(NSString *)destinationPath {
    [YXDFileManager unzipFileAtPath:zipFilePath toDestination:destinationPath];
}

- (void)downloadTest {
//    http://porn.yangxudong.me/resource/imgs/giftest.gif
//    http://porn.yangxudong.me/resource/data/resource.zip
    
    NSLog(@"开始下载");
    
    [[YXDNetworkManager sharedInstance] downloadWithURL:@"http://porn.yangxudong.me/resource/data/resource.zip"
                                              directory:[kDocuments.URL URLByAppendingPathComponent:@"H5"]
                                          loadingStatus:@"正在下载"
                                             completion:^(NSURL *filePath, NSError *error) {
                                                 NSLog(@"path : %@ \n error : %@",filePath.relativeString,error);
                                                 [self unzipWithZipFilePath:filePath.relativePath destinationPath:[NSString stringWithFormat:@"%@/H5/Test",kDocuments]];
                                             }];
    
//    [[YXDNetworkManager sharedInstance] downloadWithURLArray:@[
//                                                               @"http://porn.yangxudong.me/resource/imgs/test.jpg",
//                                                               @"http://porn.yangxudong.me/resource/imgs/giftest.gif",
//                                                               @"http://porn.yangxudong.me/resource/data/resource.zip",
//                                                               ]
//                                                   directory:[kDocuments.URL URLByAppendingPathComponent:@"dls"]
//                                                  completion:^(NSArray<NSURL *> *filePaths, NSError *error) {
//                                                      if (error) {
//                                                          NSLog(@"error : %@",error.localizedDescription);
//                                                      }
//                                                      
//                                                      if (filePaths.count) {
//                                                          NSLog(@"下载完成:");
//                                                          for (NSURL *fp in filePaths) {
//                                                              NSLog(@"path : %@",fp.relativePath);
//                                                          }
//                                                      }
//                                                  }];
}

- (void)fmdbHelperTest {
//    NSError *error = nil;
//    NSArray *arr1 = [City selectAllObjectsWithError:&error];
//    NSArray *arr2 = [City selectObjectsWithConditions:@[@"cityID < 50"] orderBy:@"cityID" asc:NO limit:@(5) error:&error];
//    if (error) {
//        NSLog(@"error : %@",error);
//    } else {
//        NSLog(@"arr1 : %@ \narr2 : %@",arr1,arr2);
//    }
    
    GirlFriend *gf1 = [GirlFriend new];
    gf1.name = @"Honey";
    gf1.age = @(18);
    gf1.height = @(168);
    gf1.weight = @(48);
    gf1.size = @"C";
    
    GirlFriend *gf2 = [GirlFriend new];
    gf2.name = @"Loli";
    gf2.age = @(12);
    gf2.height = @(150);
    gf2.weight = @(35);
    gf2.size = @"A";
    
    NSError *error = nil;
    
    BOOL suc = [@[gf1,gf2] insertWithError:&error];
    
    if (!suc || error) {
        NSLog(@"insert error : %@",error.localizedDescription);
    } else {
        NSArray *girlFriends = [GirlFriend selectAllObjectsWithError:&error];
        NSLog(@"girl friends : %@ \n error : %@",girlFriends,error);
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

- (void)imageCornerTest {
    
    UIColor *bgColor = mRGBColor(244, 244, 244);
    CGSize size = CGSizeMake(60, 60);
    
    UIImage *img1 = [UIImage imageWithColor:[UIColor redColor] size:size];
    UIImage *img2 = [UIImage imageWithColor:[UIColor greenColor] size:size];
    UIImage *img3 = [UIImage imageWithColor:[UIColor blueColor] size:size];
    
    UIImageView *imv1 = [[UIImageView alloc] initWithFrame:CGRectMake(50, 300, size.width, size.height)];
    UIImageView *imv2 = [[UIImageView alloc] initWithFrame:CGRectMake(150, 300, size.width, size.height)];
    UIImageView *imv3 = [[UIImageView alloc] initWithFrame:CGRectMake(250, 300, size.width, size.height)];
    
    imv1.backgroundColor = bgColor;
    imv2.backgroundColor = bgColor;
    imv3.backgroundColor = bgColor;
    
    imv1.image = [img1 roundedWithMaskType:UIImageRoundedCornerMaskTypeTopRight];
    imv2.image = [img2 roundedWithMaskType:UIImageRoundedCornerMaskTypeBottomRight | UIImageRoundedCornerMaskTypeTopLeft];
    imv3.image = [img3 roundedImage];
    
    [self.view addSubview:imv1];
    [self.view addSubview:imv2];
    [self.view addSubview:imv3];
}

#pragma mark - Text Field Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"------\n range.location : %lu \n range.length : %lu \n string : %@ \n\n",(unsigned long)range.location,(unsigned long)range.length,string);
    return [textField shouldChangeCharactersInRange:range replacementString:string maxLength:10 type:UITextFieldInputCharacterTypeDefault];
}

#pragma mark - Filter View

- (void)filterViewTest {
    UIView *filterViewContainer = [[UIView alloc] initWithFrame:CGRectMake(30, 100, mScreenWidth - 30 * 2, 300)];
    filterViewContainer.backgroundColor = mRGBColor(250, 250, 250);
    [self.view addSubview:filterViewContainer];
    
    self.filterView = [YXDFilterView filterViewWithSuperView:filterViewContainer delegate:self];
}

// Rows count in section (This count is NOT include special row)
- (NSInteger)filterView:(YXDFilterView *)filterView numberOfRowsInSection:(NSInteger)section {
    return [[@{
              @(0) : @[@"短标题1",@"特殊短标题2"],
              @(1) : @[@"长标题1",@"长标题2",@"长标题3",@"长标题4"],
              @(2) : @[@"特别长的标题1",@"特别长的标题2",@"特别长的标题3",@"特别长的标题4",@"特别长的标题5",@"特别长的标题6"],
              } objectForKey:@(section)] count];
}

// Header title
- (NSString *)filterView:(YXDFilterView *)filterView titleForHeaderInSection:(NSInteger)section {
    return [@[
             @"短标题",
             @"长标题",
             @"特别长的标题",
             ] objectAtIndex:section];
}

// Row title
- (NSString *)filterView:(YXDFilterView *)filterView titleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [@{
              @(0) : @[@"短标题1",@"特殊短标题2"],
              @(1) : @[@"长标题1",@"长标题2",@"长标题3",@"长标题4"],
              @(2) : @[@"特别长的标题1",@"特别长的标题2",@"特别长的标题3",@"特别长的标题4",@"特别长的标题5",@"特别长的标题6"],
              } objectForKey:@(indexPath.section)][indexPath.row];
}

// Select row event (If isSpecialRow is ture , the indexPath.row == -1)
- (void)filterView:(YXDFilterView *)filterView didSelectRowAtIndexPath:(NSIndexPath *)indexPath isSpecialRow:(BOOL)isSpecialRow {
    NSLog(@"didSelectRowAtIndexPath, section : %ld  row : %ld . %@",(long)indexPath.section,(long)indexPath.row,isSpecialRow?@"isSpecialRow":@"notSpecialRow");
}

// Default nil , not shown . Set title to show special row.
- (nullable NSString *)filterView:(YXDFilterView *)filterView specialRowTitleInSection:(NSInteger)section {
    return [@[
              @"全部短标题",
              @"",
              @"全部特别长的标题",
              ] objectAtIndex:section];
}

// Default 1 / (sections count) . 0 < percentage <= 1
- (CGFloat)filterView:(YXDFilterView *)filterView headerWidthPercentageInSection:(NSInteger)section {
    return [[@[
              @"0.3",
              @"0.3",
              @"0.4",
              ] objectAtIndex:section] floatValue];
}

// Default 1
- (NSInteger)numberOfSectionsInFilterView:(YXDFilterView *)filterView {
    return 3;
}

//// Default 50
//- (CGFloat)rowHeightForFilterView:(YXDFilterView *)filterView {
//    return 88;
//}
//
//// Default 14
//- (NSInteger)titleFontSizeForFilterView:(YXDFilterView *)filterView {
//    return 12;
//}

//// Default lightGrayColor
//- (UIColor *)normalTitleColorForFilterView:(YXDFilterView *)filterView {
//    return [UIColor redColor];
//}
//
//// Default orangeColor
//- (UIColor *)selectedTitleColorForFilterView:(YXDFilterView *)filterView {
//    return [UIColor yellowColor];
//}

@end
