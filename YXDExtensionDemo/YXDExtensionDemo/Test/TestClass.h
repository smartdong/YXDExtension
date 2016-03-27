//
//  TestClass.h
//  YXDExtensionDemo
//
//  Created by zjdd on 15/12/7.
//  Copyright © 2015年 YangXudong. All rights reserved.
//

#import "YXDBaseObject.h"
#import <UIKit/UIKit.h>

@class ClassA;
@class ClassB;

typedef void(^TestClassBlock)(NSString *string, NSError *error);

@interface TestClass : YXDBaseObject

//@property (nonatomic, copy) NSString *name;
//
//@property (nonatomic, strong) NSNumber *age;
//
//@property (nonatomic, strong) ClassA *classA;
//
//@property (nonatomic, strong) NSArray<ClassB *> *arrayClassB;
//
//@property (nonatomic, strong) NSArray<NSDictionary *> *arrayC;
//
//@property (nonatomic, strong) NSArray<NSString *> *arrayD;
//
//@property (nonatomic, strong) NSMutableDictionary *data;

#pragma mark - Test Property

//下面是支持的类型
@property (nonatomic, strong) NSString              *propertyString;
@property (nonatomic, strong) NSNumber              *propertyNumber;
@property (nonatomic, strong) NSArray               *propertyArray;
@property (nonatomic, strong) NSDictionary          *propertyDictionary;
@property (nonatomic, assign) Class                 *propertyClass;
@property (nonatomic, strong) dispatch_block_t       propertyBlock;
@property (nonatomic, strong) NSObject              *propertyObject;
@property (nonatomic, assign) SEL                   *propertySEL;
@property (nonatomic, assign) NSInteger              propertyInteger;
@property (nonatomic, assign) CGFloat                propertyFloat;
@property (nonatomic, assign) BOOL                   propertyBool;

//下面是测试捣乱的类型
@property (nonatomic, strong) NSMutableString       *propertyMutableString;
@property (nonatomic, strong) NSMutableArray        *propertyMutableArray;
@property (nonatomic, strong) NSMutableDictionary   *propertyMutableDictionary;
@property (nonatomic, assign) int                    propertyInt;
@property (nonatomic, assign) double                 propertyDouble;
@property (nonatomic, assign) Boolean                propertyBoolean;
@property (nonatomic, strong) UIViewController      *propertyViewController;
@property (nonatomic, strong) NSDate                *propertyDate;
@property (nonatomic, strong) TestClassBlock         propertyBlockWithArgs;
@property (nonatomic, assign) CGSize                 propertySize;

@end
