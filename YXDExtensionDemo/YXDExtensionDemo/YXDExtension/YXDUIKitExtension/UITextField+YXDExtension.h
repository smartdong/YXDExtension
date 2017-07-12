//
//  UITextField+YXDExtension.h
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,UITextFieldInputCharacterType) {
    UITextFieldInputCharacterTypeDefault,               //默认 不限制
    UITextFieldInputCharacterTypeNumber,                //数字
    UITextFieldInputCharacterTypePhone,                 //手机号
    UITextFieldInputCharacterTypeNaturalNumber,         //自然数
    UITextFieldInputCharacterTypeDecimal,               //小数
    UITextFieldInputCharacterTypeDecimalToOnePlace,     //一位小数
    UITextFieldInputCharacterTypeDecimalToTwoPlaces,    //两位小数
    UITextFieldInputCharacterTypeDecimalToThreePlaces,  //三位小数
    UITextFieldInputCharacterTypeLetter,                //字母
    UITextFieldInputCharacterTypeLetterAndNumber,       //字母加数字
};

@interface UITextField (YXDExtension)

- (void)setPlaceholderColor:(UIColor *)placeholderColor;

/**
 *  根据输入类型和限制长度来判断是否允许输入
 *
 *  @param range     改变范围
 *  @param string    输入文本
 *  @param maxLength 输入长度 (大于0表示限制 小于等于0则表示不限制)
 *  @param type      输入类型 (UITextFieldInputCharacterType)
 *
 *  @return 是否允许
 */
- (BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string maxLength:(NSInteger)maxLength type:(UITextFieldInputCharacterType)type;

@end
