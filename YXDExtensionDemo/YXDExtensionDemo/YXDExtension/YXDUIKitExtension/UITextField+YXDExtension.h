//
//  UITextField+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,UITextFieldInputCharacterType) {
    UITextFieldInputCharacterTypeNumber,                //数字
    UITextFieldInputCharacterTypeNaturalNumber,         //自然数
    UITextFieldInputCharacterTypeDecimal,               //小数
    UITextFieldInputCharacterTypeDecimalToOnePlace,     //一位小数
    UITextFieldInputCharacterTypeDecimalToTwoPlaces,    //两位小数
    UITextFieldInputCharacterTypeLetter,                //字母
    UITextFieldInputCharacterTypeLetterAndNumber,       //字母加数字
};

@interface UITextField (YXDExtension)

/**
 *  根据输入类型和限制长度来判断是否允许输入
 *
 *  @param type   输入类型 (UITextFieldInputCharacterType)
 *  @param length 输入长度 (大于0表示限制 小于等于0则表示不限制)
 *  @param string 将要输入的文本
 *
 *  @return 是否允许
 */
- (BOOL)shouldChangeCharactersWithType:(UITextFieldInputCharacterType)type
                                length:(NSInteger)length
                     replacementString:(NSString *)string;

@end
