//
//  YXDLockScreenView.m
//
//  Created by dd .
//  Copyright (c) 2015年 YangXudong. All rights reserved.
//

#import "YXDLockScreenView.h"
#import <AudioToolbox/AudioToolbox.h>

typedef enum : NSUInteger {
    YXDLockScreenTextInputNewPassword,          //输入新密码
    YXDLockScreenTextInputNewPasswordAgain,     //再次输入新密码
    YXDLockScreenTextInputPasswordNotMatch,     //两次密码不匹配，需要重新输入
    YXDLockScreenTextInputPassword,             //输入密码
    YXDLockScreenTextTryAgain                   //输入密码错误，再试一次
} YXDLockScreenText;

typedef enum : NSUInteger {
    YXDLockScreenTypeLockScreen,                //正常锁屏状态
    YXDLockScreenTypeCreatePassword,            //创建密码状态
    YXDLockScreenTypeDeletePassword             //删除密码状态
} YXDLockScreenType;

//取出用户密码的key
static NSString     *kYXDLockScreenUserPasswordKey  = @"kYXDLockScreenUserPasswordKey";

//锁屏界面动画时间
static float        kYXDViewMoveAnimationDuration   = 0.25;

//界面震动动画时间
static float        kYXDViewShockAnimationDuration  = 0.05;

//界面震动移动距离
static int          kYXDViewShockDelta              = 5;

//lock view的tag
static int          kYXDLockViewTag                 = 10086;

@interface YXDLockScreenView ()

/**
 *  当前状态
 */
@property (nonatomic, assign) YXDLockScreenType lockScreenType;

//中间容器
@property (weak, nonatomic) IBOutlet UIView *view_contentView;

//用户输入的密码  用户不可见
@property (weak, nonatomic) IBOutlet UITextField *txf_password;

//提示信息
@property (weak, nonatomic) IBOutlet UILabel *lbl_message;

//四个密码图片所在的view  用来做震动
@property (weak, nonatomic) IBOutlet UIView *view_passwordImageView;

//取消锁屏按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_dislockButton;


//四个密码对应的图片
@property (weak, nonatomic) IBOutlet UIImageView *imv_passcode_1;
@property (weak, nonatomic) IBOutlet UIImageView *imv_passcode_2;
@property (weak, nonatomic) IBOutlet UIImageView *imv_passcode_3;
@property (weak, nonatomic) IBOutlet UIImageView *imv_passcode_4;

@property (nonatomic , strong) NSArray *arr_passcodeImageArray;



//临时存储设置的新密码
@property (nonatomic , strong) NSArray *arr_tempNewPassword;

@end


@implementation YXDLockScreenView

/**
 *  如果没有密码 则创建密码   如果有密码 则删除密码
 */
+ (void) modifyPassword {
    if ([YXDLockScreenView userHasPassword]) {
        //删除密码
        [YXDLockScreenView lockScreen:YES animated:YES lockScreenType:YXDLockScreenTypeDeletePassword];
    } else {
        //设置新密码
        [YXDLockScreenView lockScreen:YES animated:YES lockScreenType:YXDLockScreenTypeCreatePassword];
    }
}

#pragma mark - 验证

//输入变化
- (void) action_textDidChanged {
    
    NSString *text = _txf_password.text;
    
    if (text.length <= 4) {
        [self action_changePasscodeCount:(int)text.length];
    } else {
        return;
    }
    
    if (text.length == 4) {
        
        if (self.lockScreenType == YXDLockScreenTypeLockScreen) {
            
            //锁屏状态
            if ([self action_verifyPasscode:text]) {
                //正确
                [self action_dislockScreen];
            } else {
                //失败
                [self action_verifyFailedWithMessageText:YXDLockScreenTextTryAgain];
            }
            
        } else if (self.lockScreenType == YXDLockScreenTypeCreatePassword) {
            
            //创建密码
            
            if (self.arr_tempNewPassword) {
                //验证第二次输入的密码是否匹配第一次
                
                for (int i = 0; i < 4; i++) {
                    
                    NSString *a_pc = _arr_tempNewPassword[i];
                    NSString *pc = [text substringWithRange:NSMakeRange(i,1)];
                    
                    if (![a_pc isEqualToString:pc]) {
                        [self action_verifyFailedWithMessageText:YXDLockScreenTextInputPasswordNotMatch];
                        self.arr_tempNewPassword = nil;
                        return;
                    }
                }

                [self action_dislockScreen];
                
                [[NSUserDefaults standardUserDefaults] setObject:_arr_tempNewPassword forKey:kYXDLockScreenUserPasswordKey];
                [[NSUserDefaults standardUserDefaults] synchronize];

                [[NSNotificationCenter defaultCenter] postNotificationName:YXDCreatePasswordNotification object:nil];
                
            } else {
                //创建新密码
                
                //记录当前密码
                NSMutableArray *arr = [NSMutableArray array];
                
                for (int i = 0; i < 4; i++) {
                    NSString *pc = [text substringWithRange:NSMakeRange(i, 1)];
                    [arr addObject:pc];
                }
                
                self.arr_tempNewPassword = [NSArray arrayWithArray:arr];
                
                [self action_resetAllPassCodeImage:NO];
                [self action_setMessageTextWithType:YXDLockScreenTextInputNewPasswordAgain];
                _txf_password.text = nil;
            }
            
        } else if (self.lockScreenType == YXDLockScreenTypeDeletePassword) {
            
            //删除密码
            
            if ([self action_verifyPasscode:text]) {
                //正确
                [self action_dislockScreen];
                
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kYXDLockScreenUserPasswordKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:YXDDeletePasswordNotification object:nil];
                
            } else {
                //失败
                [self action_verifyFailedWithMessageText:YXDLockScreenTextTryAgain];
            }
        }
    }
}

//验证失败
- (void) action_verifyFailedWithMessageText:(YXDLockScreenText)lockScreenText {
    
    _txf_password.text = nil;
    
    [self action_setMessageTextWithType:lockScreenText];
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    CGPoint orginCenter = _view_passwordImageView.center;
    
    [UIView animateWithDuration:kYXDViewShockAnimationDuration
                     animations:^{
                         _view_passwordImageView.center = CGPointMake(orginCenter.x - kYXDViewShockDelta, orginCenter.y);
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:kYXDViewShockAnimationDuration
                                          animations:^{
                                              _view_passwordImageView.center = CGPointMake(orginCenter.x + kYXDViewShockDelta, orginCenter.y);
                                          }
                                          completion:^(BOOL finished) {
                                              [UIView animateWithDuration:kYXDViewShockAnimationDuration
                                                               animations:^{
                                                                   _view_passwordImageView.center = CGPointMake(orginCenter.x - kYXDViewShockDelta, orginCenter.y);
                                                               }
                                                               completion:^(BOOL finished) {
                                                                   [UIView animateWithDuration:kYXDViewShockAnimationDuration
                                                                                    animations:^{
                                                                                        _view_passwordImageView.center = CGPointMake(orginCenter.x + kYXDViewShockDelta, orginCenter.y);
                                                                                    }
                                                                                    completion:^(BOOL finished) {
                                                                                        [UIView animateWithDuration:kYXDViewShockAnimationDuration
                                                                                                         animations:^{
                                                                                                             _view_passwordImageView.center = CGPointMake(orginCenter.x, orginCenter.y);
                                                                                                         }
                                                                                                         completion:^(BOOL finished) {
                                                                                                             [self action_resetAllPassCodeImage:NO];
                                                                                                             _txf_password.text = nil;
                                                                                                         }];
                                                                                    }];
                                                               }];
                                          }];
                     }];
}

//验证密码是否正确
- (BOOL) action_verifyPasscode:(NSString *)passcode {
    
    if (passcode.length < 4) {
        return NO;
    }
    
    NSArray *passcodeArray = [YXDLockScreenView userPassword];
    
    if (passcodeArray.count != 4) {
        NSLog(@"error: %@ %@ 密码为空或者不是四位!",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
        return YES;
    }
    
    for (int i = 0; i < 4; i++)  {
        
        NSString *pc = passcodeArray[i];
        NSString *a_pc = [passcode substringWithRange:NSMakeRange(i, 1)];
        
        if (![pc isEqualToString:a_pc]) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark -

/**
 *  是否需要 锁屏/解锁   并选择是否需要动画
 *
 *  @param lockScreen 锁屏/解锁
 *  @param animated   是否需要动画
 */
+ (void) lockScreen:(BOOL)lockScreen animated:(BOOL)animated {
    [YXDLockScreenView lockScreen:lockScreen animated:animated lockScreenType:YXDLockScreenTypeLockScreen];
}

+ (void) lockScreen:(BOOL)lockScreen animated:(BOOL)animated lockScreenType:(YXDLockScreenType)lockScreenType {
    
    UIWindow *mainWindow = [[[UIApplication sharedApplication] windows] firstObject];
    
    if (lockScreen) {
        
        //锁屏
        YXDLockScreenView *lockView = [YXDLockScreenView lockScreenView];
        
        lockView.lockScreenType = lockScreenType;
        
        if (lockScreenType != YXDLockScreenTypeLockScreen) {
            lockView.btn_dislockButton.hidden = NO;
        }
        
        if (lockScreenType == YXDLockScreenTypeCreatePassword) {
            [lockView action_setMessageTextWithType:YXDLockScreenTextInputNewPassword];
        }
        
        if (animated) {
            lockView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, ([UIScreen mainScreen].bounds.size.height + lockView.frame.size.height/2));
        }
        
        [mainWindow addSubview:lockView];
        
        [UIView animateWithDuration:kYXDViewMoveAnimationDuration
                         animations:^{
                             lockView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
                         } completion:nil];
        
    } else {
        
        //解锁
        YXDLockScreenView *lockView = nil;
        
        for (UIView *view in mainWindow.subviews) {
            if (view.tag == kYXDLockViewTag) {
                //找到一个lock view
                lockView = (YXDLockScreenView *)view;
                break;
            }
        }
        
        //如果当前lock view不是锁屏用的  则需要查看是否还有锁屏用的lock view
        if (lockView.lockScreenType != YXDLockScreenTypeLockScreen) {
            for (UIView *view in mainWindow.subviews) {
                if ((view.tag == kYXDLockViewTag) && (((YXDLockScreenView *)view).lockScreenType == YXDLockScreenTypeLockScreen)) {
                    lockView = (YXDLockScreenView *)view;
                    break;
                }
            }
        }
        
        [lockView endEditing:YES];
        
        if (animated) {
            [UIView animateWithDuration:kYXDViewMoveAnimationDuration
                             animations:^{
                                 lockView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, ([UIScreen mainScreen].bounds.size.height + lockView.frame.size.height/2));
                             } completion:^(BOOL finished) {
                                 [lockView removeFromSuperview];
                             }];
        } else {
            [lockView removeFromSuperview];
        }
    }
}

/**
 *  是否在锁屏状态
 */
+ (BOOL) isLocking {
    
    UIWindow *mainWindow = [[[UIApplication sharedApplication] windows] firstObject];

    for (UIView *view in mainWindow.subviews) {
        if ((view.tag == kYXDLockViewTag) && (((YXDLockScreenView *)view).lockScreenType == YXDLockScreenTypeLockScreen)) {
            return YES;
        }
    }
    
    return NO;
}

/**
 *  用户是否设有密码
 */
+ (BOOL) userHasPassword {
    return [YXDLockScreenView userPassword]?YES:NO;
}

/**
 *  用户密码
 *
 *  @return 密码数组 共四位 NSString对象
 */
+ (NSArray *) userPassword {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kYXDLockScreenUserPasswordKey];
}

/**
 *  获得一个锁屏界面
 */
+ (YXDLockScreenView *) lockScreenView {
    
    YXDLockScreenView *lockScreenView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    
    lockScreenView.tag = kYXDLockViewTag;

    lockScreenView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    [lockScreenView addTarget:lockScreenView action:@selector(action_showKeyboard) forControlEvents:UIControlEventTouchUpInside];
    
    lockScreenView.view_contentView.center = CGPointMake(lockScreenView.frame.size.width/2, lockScreenView.frame.size.height/3);
    
    [lockScreenView.txf_password becomeFirstResponder];
    
    [lockScreenView action_setMessageTextWithType:YXDLockScreenTextInputPassword];
    
    lockScreenView.arr_passcodeImageArray = @[lockScreenView.imv_passcode_1,
                                              lockScreenView.imv_passcode_2,
                                              lockScreenView.imv_passcode_3,
                                              lockScreenView.imv_passcode_4];
    
    [[NSNotificationCenter defaultCenter] addObserver:lockScreenView
                                             selector:@selector(action_dislockScreenNotification)
                                                 name:YXDDisLockScreenNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:lockScreenView
                                             selector:@selector(action_textDidChanged)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    
    return lockScreenView;
}

/**
 *  移除通知
 */
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  执行解锁方法
 */
- (void) action_dislockScreenNotification {
    [self performSelectorOnMainThread:@selector(action_dislockScreen) withObject:nil waitUntilDone:NO];
}

/**
 *  屏幕解锁
 */
- (void) action_dislockScreen {
    [YXDLockScreenView lockScreen:NO animated:YES];
}

/**
 *  关闭锁屏界面的按钮事件
 */
- (IBAction)action_dislockScreenButtonAction {
    [self action_dislockScreen];
}

/**
 *  点击背景 如果当前没有弹出键盘 则弹出键盘
 */
- (void) action_showKeyboard {
    if (!self.txf_password.editing) {
        [self.txf_password becomeFirstResponder];
    }
}

/**
 *  更换文字信息
 */
- (void) action_setMessageTextWithType:(YXDLockScreenText)textType {
    
    NSString *message = nil;
    
    switch (textType) {
        case YXDLockScreenTextInputNewPassword:
            message = @"请输入新密码";
            break;
        case YXDLockScreenTextInputNewPasswordAgain:
            message = @"请再次输入新密码";
            break;
        case YXDLockScreenTextInputPasswordNotMatch:
            message = @"两次密码不匹配，请重新输入新密码";
            break;
        case YXDLockScreenTextInputPassword:
            message = @"请输入密码";
            break;
        case YXDLockScreenTextTryAgain:
            message = @"密码错误,请重新输入";
            break;
        default:
            break;
    }
    
    _lbl_message.text = message;
}

/**
 *  更换图片
 *
 *  @param isPasscode 如果是密码  全部更换成圆
 */
- (void) action_resetAllPassCodeImage:(BOOL)isPasscode {
    if (isPasscode) {
        for (UIImageView *imv in self.arr_passcodeImageArray) {
            imv.image = [UIImage imageNamed:@"image_circle.png"];
        }
    } else {
        for (UIImageView *imv in self.arr_passcodeImageArray) {
            imv.image = [UIImage imageNamed:@"image_line.png"];
        }
    }
}

/**
 *  更换图片
 *
 *  @param count      更换几个圆
 */
- (void) action_changePasscodeCount:(int)count {
    for (UIImageView *imv in _arr_passcodeImageArray) {
        if ([_arr_passcodeImageArray indexOfObject:imv] < count) {
            imv.image = [UIImage imageNamed:@"image_circle.png"];
        } else {
            imv.image = [UIImage imageNamed:@"image_line.png"];
        }
    }
}

@end
