//
//  ClassA.h
//  YXDExtensionDemo
//
//  Created by zjdd on 15/12/7.
//  Copyright © 2015年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ClassB;

@interface ClassA : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) ClassB *classB;

@end
