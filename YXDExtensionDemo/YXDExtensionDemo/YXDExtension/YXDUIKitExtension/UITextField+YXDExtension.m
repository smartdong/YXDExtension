//
//  UITextField+YXDExtension.m
//  YXDExtensionDemo
//
//  Copyright © 2016年 YangXudong. All rights reserved.
//

#import "UITextField+YXDExtension.h"
#import "YXDSwizzlingExtensionDefine.h"

static NSString *const kYXDExtensionStringPoint                 = @".";
static NSString *const kYXDExtensionStringAllNumber             = @"0123456789";
static NSString *const kYXDExtensionStringAllLetter             = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
static NSString *const kYXDExtensionStringAllLetterAndNumber    = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

@implementation UITextField (YXDExtension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzling_exchangeMethod([self class], @selector(resignFirstResponder), @selector(swizzling_resignFirstResponder));
        swizzling_exchangeMethod([self class], @selector(becomeFirstResponder), @selector(swizzling_becomeFirstResponder));
    });
}

- (BOOL)swizzling_resignFirstResponder {
    BOOL result = [self swizzling_resignFirstResponder];
    [self layoutIfNeeded];
    return result;
}

- (BOOL)swizzling_becomeFirstResponder {
    BOOL result = [self swizzling_becomeFirstResponder];
    [self layoutIfNeeded];
    return result;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    [self setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
}

- (BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string maxLength:(NSInteger)maxLength type:(UITextFieldInputCharacterType)type {
    
    if ([string isEqualToString:@"\n"]) {
        return YES;
    }
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    if ((maxLength > 0) && ((self.text.length + string.length - range.length) > maxLength)) {
        return NO;
    }
    
    NSString *filter = nil;
    
    switch (type) {
        case UITextFieldInputCharacterTypeDefault:
        {
            return YES;
        }
            break;
        case UITextFieldInputCharacterTypeNumber:
        {
            filter = kYXDExtensionStringAllNumber;
        }
            break;
        case UITextFieldInputCharacterTypePhone:
        {
            if (!self.text.length && (string.integerValue != 1)) {
                return NO;
            }
            filter = kYXDExtensionStringAllNumber;
        }
            break;
        case UITextFieldInputCharacterTypeNaturalNumber:
        {
            if (!self.text.length && [string isEqualToString:@"0"]) {
                return NO;
            }
            filter = kYXDExtensionStringAllNumber;
        }
            break;
        case UITextFieldInputCharacterTypeDecimal:
        case UITextFieldInputCharacterTypeDecimalToOnePlace:
        case UITextFieldInputCharacterTypeDecimalToTwoPlaces:
        case UITextFieldInputCharacterTypeDecimalToThreePlaces:
        {
            BOOL inputPointString = [string isEqualToString:kYXDExtensionStringPoint];
            NSRange pointRange = [self.text rangeOfString:kYXDExtensionStringPoint];
            
            if (!self.text.length && inputPointString) {
                self.text = @"0.";
                return NO;
            } else if ([self.text isEqualToString:@"0"]) {
                if (inputPointString) {
                    self.text = @"0.";
                }
                return NO;
            } else if (inputPointString) {
                if (pointRange.length) {
                    return NO;
                }
                return YES;
            }
            
            if (pointRange.length) {
                NSInteger stringLengthBehindPoint = maxLength;
                switch (type) {
                    case UITextFieldInputCharacterTypeDecimalToOnePlace:
                    {
                        stringLengthBehindPoint = 1;
                    }
                        break;
                    case UITextFieldInputCharacterTypeDecimalToTwoPlaces:
                    {
                        stringLengthBehindPoint = 2;
                    }
                        break;
                    case UITextFieldInputCharacterTypeDecimalToThreePlaces:
                    {
                        stringLengthBehindPoint = 3;
                    }
                        break;
                    default:
                        break;
                }
                
                if ((self.text.length - pointRange.location) > stringLengthBehindPoint) {
                    return NO;
                }
            }
            
            filter = kYXDExtensionStringAllNumber;
        }
            break;
        case UITextFieldInputCharacterTypeLetter:
        {
            filter = kYXDExtensionStringAllLetter;
        }
            break;
        case UITextFieldInputCharacterTypeLetterAndNumber:
        {
            filter = kYXDExtensionStringAllLetterAndNumber;
        }
            break;
    }
    
    if (filter) {
        return [string isEqualToString:[[string componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:filter] invertedSet]] componentsJoinedByString:@""]];
    }
    
    return NO;
}

@end
