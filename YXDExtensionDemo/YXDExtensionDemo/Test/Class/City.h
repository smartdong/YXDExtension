//
//  City.h
//  YXDExtensionDemo
//
//  Created by zjdd on 16/4/12.
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXDFMDBHelper.h"

@interface City : NSObject //<YXDFMDBHelperObjectProtocol>

//@property (nonatomic, copy) NSString *primaryID;

@property (nonatomic, copy) NSNumber *cityID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pinyin;

@end
