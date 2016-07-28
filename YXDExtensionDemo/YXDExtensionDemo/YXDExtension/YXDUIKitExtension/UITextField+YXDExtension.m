//
//  UITextField+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import "UITextField+YXDExtension.h"

static NSString *const kYXDExtensionStringAllNumber             = @"0123456789";
static NSString *const kYXDExtensionStringAllLetter             = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
static NSString *const kYXDExtensionStringAllLetterAndNumber    = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

@implementation UITextField (YXDExtension)

- (BOOL)shouldChangeCharactersWithType:(UITextFieldInputCharacterType)type
                                length:(NSInteger)length
                     replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"]) {
        return YES;
    }
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    if ((length > 0) && ((self.text.length + string.length) > length)) {
        return NO;
    }
    
    //TODO:判断输入条件
    
//    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:kYXDExtensionStringAllNumber] invertedSet];
//    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
//    BOOL basic = [string isEqualToString:filtered];
//    return basic;
    
    return YES;
}

@end
