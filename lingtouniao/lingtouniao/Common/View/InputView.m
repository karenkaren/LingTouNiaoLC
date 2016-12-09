//
//  LoginView.m
//  haowan
//
//  Created by wupeijing on 3/27/15.
//  Copyright (c) 2015 iyaya. All rights reserved.
//

#import "InputView.h"

#define kBigTitleColor [UIColor blackColor]

@implementation InputView

- (instancetype)initWithStyle:(InPutPageStlye)style {
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGRect frame = CGRectMake(0, 0, bounds.size.width, 280);
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];

        _usernameTextField = [self createTextField:[CustomerizedFont heiti:14] color:kBigTitleColor borderstyle:UITextBorderStyleNone isPassword:NO];
        _usernameTextField.keyboardType = UIKeyboardTypePhonePad;
        _passwordTextField = [self createTextField:[CustomerizedFont heiti:14] color:kBigTitleColor borderstyle:UITextBorderStyleNone isPassword:YES];

        _commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 45)];
        self.commitBtn.backgroundColor = COLOR_MAIN;
        [self.commitBtn setTintColor:[UIColor whiteColor]];
        self.commitBtn.layer.cornerRadius = 5;
        self.commitBtn.clipsToBounds = YES;
        self.commitBtn.titleLabel.font = [CustomerizedFont heiti:16];
        [self.commitBtn setBackgroundImage:[Utility createImageFromColor:kDisabledColor] forState:UIControlStateDisabled];

        [self configureFor:style];

        self.usernameTextField.top = 30;
        self.passwordTextField.top = self.usernameTextField.bottom + 0.5;
        self.commitBtn.top = self.passwordTextField.bottom + 30;

        UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        line1.backgroundColor = HexRGB(0xe2e2e2);
        line1.top = _usernameTextField.top - 0.5;
        UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        line2.backgroundColor = HexRGB(0xe2e2e2);
        line2.top = self.usernameTextField.bottom;
        UIView * line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        line3.backgroundColor = HexRGB(0xe2e2e2);
        line3.top = self.passwordTextField.bottom;
        
        [self addSubview:self.usernameTextField];
        [self addSubview:self.passwordTextField];
        [self addSubview:self.commitBtn];
        [self addSubview:line1];
        [self addSubview:line2];
        [self addSubview:line3];
    }
    return self;
}

- (UITextField *)createTextField:(UIFont *)font color:(UIColor *)color borderstyle:(UITextBorderStyle)style isPassword:(BOOL)isPassword {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 45)];
    textField.font = font;
    textField.textColor = color;
    textField.borderStyle = style;
    [textField setSecureTextEntry:isPassword];
    textField.backgroundColor = [UIColor whiteColor];

    return textField;
}

/**
 *    create a left view with image
 *
 *    @param frame
 *    @param imgName   mage name under bunder
 *    @param textField
 */
- (void)createAccessoryViewWithFrom:(CGRect) frame name:(NSString *)imgName onTextField:(UITextField *)textField {
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
    imgView.image = [UIImage imageNamed:imgName];
    imgView.contentMode = UIViewContentModeCenter;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = imgView;
}

- (void)configureFor:(InPutPageStlye)style {
    self.usernameTextField.width = self.width - 2 * 0;
    self.passwordTextField.width = self.width - 2 * 0;
    self.commitBtn.width = self.usernameTextField.width - 2 * kHorizontalMargin;
    [self.commitBtn setTitle:locationString(@"login_label_signin") forState:UIControlStateNormal];

    if (style == InPutPageStlyeNormal) {
        [self createAccessoryViewWithFrom:CGRectMake(0, 0, 22, 44) name:nil onTextField:self.usernameTextField];
        [self createAccessoryViewWithFrom:CGRectMake(0, 0, 22, 44) name:nil onTextField:self.passwordTextField];
        self.passwordTextField.secureTextEntry = NO;
    }
//    } else if (style == VerifyPhonePage) {
//        [self createAccessoryViewWithFrom:CGRectMake(0, 0, 44, 45) name:kPhoneIcon onTextField:self.usernameTextField];
//        self.passwordTextField.secureTextEntry = NO;
//        [self createAccessoryViewWithFrom:CGRectMake(0, 0, 14, 45) name:nil onTextField:self.passwordTextField];
//    } else if (style == SetPasswordPage) {
//        self.usernameTextField.secureTextEntry = YES;
//        self.usernameTextField.keyboardType = self.passwordTextField.keyboardType;
//        [self createAccessoryViewWithFrom:CGRectMake(0, 0, 44, 45) name:kSecureIcon onTextField:self.passwordTextField];
//        [self createAccessoryViewWithFrom:CGRectMake(0, 0, 44, 45) name:kSecureIcon onTextField:self.usernameTextField];
//    } else if (style == AdvicePage) {
//        self.passwordTextField.secureTextEntry = NO;
//        self.passwordTextField.keyboardType = UIKeyboardTypeEmailAddress;
//           [self.commitBtn setTitle:@"提交" forState:UIControlStateNormal];
//        [self createAccessoryViewWithFrom:CGRectMake(0, 0, 44, 45) name:kPhoneIcon onTextField:self.usernameTextField];
//        [self createAccessoryViewWithFrom:CGRectMake(0, 0, 44, 45) name:KIc_advice_email onTextField:self.passwordTextField];
//    }
    self.usernameTextField.left = self.passwordTextField.left = 0;
    self.commitBtn.left = kHorizontalMargin;
}

@end

