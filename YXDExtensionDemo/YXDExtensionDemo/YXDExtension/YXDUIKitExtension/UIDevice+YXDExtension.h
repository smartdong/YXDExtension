//
//  UIDevice+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright © 2015年 YangXudong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (YXDExtension)

+ (NSString *)name;
+ (NSString *)model;
+ (NSString *)localizedModel;
+ (NSString *)systemName;
+ (NSString *)systemVersion;
+ (NSString *)deviceModel;

@end
