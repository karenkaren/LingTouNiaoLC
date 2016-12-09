//
//  LTNRegisterController.m
//  lingtouniao
//
//  Created by LiuFeifei on 15/11/11.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNRegisterController.h"
#import "LTNTextField.h"
#import "LTNPromptView.h"
#import "LTNUtilsHelper.h"
#import "LTNServerConstant.h"
#import "BaseWebViewController.h"
#import "VerifyRealNameViewController.h"
#import "GesturePasswordController.h"
#import "LTNAlertView.h"
#import "LTNAgreeView.h"
#import "TalkingDataAppCpa.h"

#define kSide 18
#define kMargin DimensionBaseIphone6(30)
#define kLineHeight DimensionBaseIphone6(30)
#define kLineWidth 0.5
#define kFieldHeight DimensionBaseIphone6(49)
#define kCaptchaWidth DimensionBaseIphone6(114)

static int timeCount = 60;

typedef NS_ENUM(NSUInteger, TagOfTextField) {
    TagOfTelephoneTextField = 100,
    TagOfPasswordTextField,
    TagOfCapthaTextField
};

@interface LTNRegisterController ()<LTNAlertViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) LTNTextField * userNameField;
@property (nonatomic, strong) LTNTextField * passwordField;
@property (nonatomic, strong) UIButton * getCaptchaButton;
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, strong) UIButton * eyeButton;
@property (nonatomic, strong) LTNTextField * captchaField;
@property (nonatomic, assign) BOOL agree;
@property (nonatomic, strong) LTNTextField * refereeField;
@property (nonatomic, strong) UILabel * refereeLabel;
@property (nonatomic, strong) UIButton * registerButton;
@property (nonatomic, strong) LTNPromptView * promptView;
@property (nonatomic, strong) UIButton * refereeButton;



@end

@implementation LTNRegisterController

+(instancetype)registerControllerWithFinishBlock:(VoidBlock)finishRegisterBlock{
    LTNRegisterController *registerController= [[LTNRegisterController alloc] init];
    registerController.finishRegisterBlock=finishRegisterBlock;
    return registerController;
}

- (void)loadView
{
    self.view = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[PiwikTracker sharedInstance] sendViews:NSStringFromClass([self class]), self.title, nil];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self stopTimer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self dissmissWithBackButton];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    //去除导航栏下方的横线
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(self.view.frame.size.width, 2)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = locationString(@"login_label_register");

    // navigationBar left button
    UIButton * returnButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, kGeneralHeight)];
    [returnButton setImage:[UIImage imageNamed:@"nav_return"] forState:UIControlStateNormal];
    [returnButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:returnButton];
    
    [self setupUI];
    // 注册通知
    [self addNotifications];
}

- (void)addNotifications
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 监听方法
#pragma mark 返回
- (void)back
{
    [self.view endEditing:YES];
    kWeakSelf
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserNameKey] == nil) {
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:locationString(@"hint")
                                                        message:locationString(@"unregister_prompt") delegate:nil cancelButtonTitle:locationString(@"think_again") otherButtonTitles:locationString(@"unregister_drop_coupon"), nil];
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [weakSelf quitVC];
            }
        }];
    } else {
        [self quitVC];
    }
}

//quit this viewController
//it maybe presented in InvestimentVC
//or maybe pushed from LoginVC
- (void)quitVC {
    
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

#pragma mark - 搭建页面
- (void)setupUI
{
    CGFloat width = kScreenWidth - kSide * 2;
    
    // 手机号输入框
    LTNTextField * userNameField = [[LTNTextField alloc] initWithFrame:CGRectMake(kSide, kMargin, width, kFieldHeight)];
    userNameField.tag = TagOfTelephoneTextField;
    userNameField.delegate = self;
    userNameField.limitedCount = 11;
    userNameField.drawBottomLine = YES;
    userNameField.placeholder = locationString(@"register_placeholder_telephone");
    userNameField.keyboardType = UIKeyboardTypeNumberPad;
    [userNameField addLeftViewWithImageName:@"icon_mobileno" leftMargin:12 leftViewMode:UITextFieldViewModeAlways];
    [userNameField addClearButtonWithRightMargin:0 imageName:@"icon_delete"];
    NSString * userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserNameKey];
    if (userName) {
        userNameField.text = userName;
    }
    [self.view addSubview:userNameField];
    self.userNameField = userNameField;
    
    // 密码输入框
    LTNTextField * passwordField = [[LTNTextField alloc] initWithFrame:CGRectMake(kSide, CGRectGetMaxY(userNameField.frame), width, kFieldHeight)];
    passwordField.tag = TagOfPasswordTextField;
    passwordField.delegate = self;
    passwordField.limitedCount = 18;
    passwordField.drawBottomLine = YES;
    passwordField.placeholder = locationString(@"new_password_hint");
    passwordField.secureTextEntry = YES;
    [passwordField addLeftViewWithImageName:@"icon_password" leftMargin:12 leftViewMode:UITextFieldViewModeAlways];
    [passwordField addRightViewWithImageName:@"icon_hide" selectImageName:@"icon_show" rightViewMode:UITextFieldViewModeAlways target:self action:@selector(showPassword:)];
    [passwordField addClearButtonWithRightMargin:0 imageName:@"icon_delete"];
    [self.view addSubview:passwordField];
    self.passwordField = passwordField;
    
    // 短信验证输入框
    LTNTextField * captchaField = [[LTNTextField alloc] initWithFrame:CGRectMake(kSide, CGRectGetMaxY(passwordField.frame), width, kFieldHeight)];
    captchaField.tag = TagOfCapthaTextField;
    captchaField.delegate = self;
    captchaField.limitedCount = CAPTCHA_LIMIT;
    captchaField.drawBottomLine = YES;
    captchaField.placeholder = locationString(@"register_placeholder_mobile_code");
    captchaField.keyboardType = UIKeyboardTypeNumberPad;
    [captchaField addLeftViewWithImageName:@"icon_captcha" leftMargin:12 leftViewMode:UITextFieldViewModeAlways];
    // 短信验证码输入框分隔线
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(width - kCaptchaWidth - kLineWidth, 0.5 * (kFieldHeight - kLineHeight), kLineWidth, kLineHeight)];
    lineView.backgroundColor = kHexColor(@"#e2e2e2");
    
    [captchaField addClearButtonWithRightMargin:CGRectGetWidth(captchaField.frame) - CGRectGetMaxX(lineView.frame) imageName:@"icon_delete"];
    [captchaField addSubview:lineView];
    [self.view addSubview:captchaField];
    self.captchaField = captchaField;
    
    // 获取短信验证码
    UIButton * getCaptchaButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(captchaField.frame) - kCaptchaWidth, CGRectGetMinY(captchaField.frame), kCaptchaWidth, captchaField.frame.size.height - kLineWidth)];
    [getCaptchaButton.titleLabel setFont:kFont(15)];
    [getCaptchaButton setTitle:locationString(@"get_verify_code") forState:UIControlStateNormal];
    [getCaptchaButton setTitleColor:kHexColor(@"#0090ff") forState:UIControlStateNormal];
    [getCaptchaButton setTitleColor:kHexColor(@"#cccccc") forState:UIControlStateDisabled];
    [getCaptchaButton addTarget:self action:@selector(getVerificationCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getCaptchaButton];
    self.getCaptchaButton = getCaptchaButton;
    
    // 阅读并同意协议
    LTNAgreeView * agreeView = [[LTNAgreeView alloc] initWithTitle:locationString(@"read_agreement") protocol:locationString(@"niaoren_agreement") fontSize:12 target:self];
    agreeView.centerX = kScreenWidth * 0.5;
    agreeView.top = captchaField.bottom + DimensionBaseIphone6(16);
    [self.view addSubview:agreeView];
    
    // 推荐人button
    CGSize refereeSize = kStringSize(locationString(@"have_recommend"), 16);
    UIButton * refereeButton = [[UIButton alloc] initWithFrame:CGRectMake(kSide, CGRectGetMaxY(agreeView.frame) + kGeneralHeight * 0.5, width, refereeSize.height)];
    [refereeButton setTitleColor:kHexColor(@"#0090ff") forState:UIControlStateNormal];
    [refereeButton setTitle:locationString(@"have_recommend") forState:UIControlStateNormal];
    [refereeButton addTarget:self action:@selector(referee:) forControlEvents:UIControlEventTouchUpInside];
    refereeButton.titleLabel.font = kFont(16);
    [self.view addSubview:refereeButton];
    self.refereeButton = refereeButton;
    
    // 推荐邀请码
    LTNTextField * refereeField = [[LTNTextField alloc] initWithFrame:CGRectMake(kSide, CGRectGetMaxY(refereeButton.frame) + DimensionBaseIphone6(16), width, kFieldHeight)];
    refereeField.drawTopLine = YES;
    refereeField.drawBottomLine = YES;
    refereeField.limitedCount = 11;
    refereeField.placeholder = locationString(@"recomment_code");
    [refereeField addLeftViewWithImageName:@"icon_recommend"leftMargin:DimensionBaseIphone6(12) leftViewMode:UITextFieldViewModeAlways];
    [refereeField addClearButtonWithRightMargin:0 imageName:@"icon_delete"];
    refereeField.hidden = YES;
    [self.view addSubview:refereeField];
    self.refereeField = refereeField;
    
    // 注册按钮
    UIButton * registerButton = [[UIButton alloc] initWithFrame:CGRectMake(kSide, CGRectGetMaxY(refereeButton.frame) + kFieldHeight * 0.5, width, kFieldHeight)];
    registerButton.layer.cornerRadius = 5;
    registerButton.layer.masksToBounds = YES;
    registerButton.enabled = NO;
    [registerButton setTitle:locationString(@"complete_register") forState:UIControlStateNormal];
    [registerButton setBackgroundImage:[UIImage imageWithColor:kHexColor(@"#ea5504") size:registerButton.bounds.size] forState:UIControlStateNormal];
    [registerButton setBackgroundImage:[UIImage imageWithColor:kHexColor(@"#cccccc") size:registerButton.bounds.size] forState:UIControlStateDisabled];
    [registerButton addTarget:self action:@selector(completeRegister:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    self.registerButton = registerButton;
    
    // 温馨提示
    LTNPromptView * promptView = [LTNPromptView promptWithIcon:@"icon_note_small" iconSpace:6 Text:locationString(@"register_prompt") font:kFont(12) textWidth:DimensionBaseIphone6(237)];
    CGPoint promptCenter = CGPointMake(kScreenWidth * 0.5,  CGRectGetMaxY(registerButton.frame) + (kFieldHeight + promptView.bounds.size.height) * 0.5);
    promptView.center = promptCenter;
    [self.view addSubview:promptView];
    self.promptView = promptView;
}

#pragma mark 同意协议、显示协议delegate
- (void)agreeViewWillShowProtocol
{
    DLog(@"显示详情");
    NSString * urlString = kH5AcceptUrl;
    BaseWebViewController * webController = [[BaseWebViewController alloc] initWithURL:urlString];
    [self.navigationController pushViewController:webController animated:YES];
}

- (void)agreeViewWillAgreeProtocol:(BOOL)agree
{
    self.agree = agree;
    if (self.userNameField.text.length > 0 && self.passwordField.text.length > 0 && self.captchaField.text.length > 0 && agree) {
        self.registerButton.enabled = YES;
        return;
    }
    self.registerButton.enabled = NO;
}

#pragma mark 推荐人信息
- (void)referee:(UIButton *)refereeButton
{
    self.refereeField.hidden = NO;
    refereeButton.selected = !refereeButton.selected;
    if (!refereeButton.selected) {
        self.refereeField.text = @"";
    }
    CGRect registerButtonFrame = self.registerButton.frame;
    CGRect refereeFieldFrame = self.refereeField.frame;
    CGRect refereeLableFrame = self.refereeLabel.frame;
    CGRect promptViewFrame = self.promptView.frame;
    
    UIScrollView * scroll = (UIScrollView *)self.view;
    if (refereeButton.selected) {
        
        refereeFieldFrame.size.height = kFieldHeight;
        refereeLableFrame.size.height = kFieldHeight;
        registerButtonFrame.origin.y += kFieldHeight + 16;
        promptViewFrame.origin.y += kFieldHeight + 16;
        kWeakSelf
        [UIView animateWithDuration:0.1f animations:^{
            weakSelf.refereeField.frame = refereeFieldFrame;
            weakSelf.registerButton.frame = registerButtonFrame;
            weakSelf.promptView.frame = promptViewFrame;
        } completion:^(BOOL finished) {
            [scroll setContentSize:CGSizeMake(kScreenWidth, CGRectGetMaxY(self.promptView.frame) + 20)];
            [self.refereeField becomeFirstResponder];
        }];
    } else {
        refereeFieldFrame.size.height = 0;
        refereeLableFrame.size.height = 0;
        registerButtonFrame.origin.y -= kFieldHeight + 16;
        promptViewFrame.origin.y -= kFieldHeight + 16;
        kWeakSelf
        [UIView animateWithDuration:0.1f animations:^{
            weakSelf.refereeField.frame = refereeFieldFrame;
            weakSelf.registerButton.frame = registerButtonFrame;
            weakSelf.promptView.frame = promptViewFrame;
        } completion:^(BOOL finished) {
            [scroll setContentSize:CGSizeMake(kScreenWidth, kScreenHeight - NavigationBarHeight - 20)];
        }];
    }
}

#pragma mark 完成注册
- (void)completeRegister:(UIButton *)button
{
    if (![LTNNetManager sharedLTNNetManager].isAvailable) {
        [LTNUtilsHelper openNetwork:self];
        return;
    }
    
    if (![self.userNameField isTelphoneNum]) {
        [self.userNameField becomeFirstResponder];
        [LTNUtilsHelper boxShowWithMessage:locationString(@"get_correct_mobile")];
        return;
    }

    if (![self.passwordField checkPassword]) {
        [self.passwordField becomeFirstResponder];
        [LTNUtilsHelper boxShowWithMessage:locationString(@"password_info1")];
        return;
    }
    if (self.captchaField.text.length != CAPTCHA_LIMIT) {
        [self.captchaField becomeFirstResponder];
        [LTNUtilsHelper boxShowWithMessage:locationString(@"captcha_error")];
        return;
    }
    
    if (self.refereeButton.selected && ![self.refereeField isTelphoneNum]) {
        [self.refereeField becomeFirstResponder];
        [LTNUtilsHelper boxShowWithMessage:locationString(@"register_toast2")];
        return;
    }
    
    [self.view endEditing:YES];
    [LTNUtilsHelper boxShowLoadWithMessage:locationString(@"feed_back_submit")];
    [[NSUserDefaults standardUserDefaults] setObject:self.userNameField.text forKey:kUserNameKey];

    kWeakSelf
    [LTNServerHelper registerWithMobileNo:self.userNameField.text password:self.passwordField.text mobileCode:self.captchaField.text referee:self.refereeField.text agreeProtocol:self.agree success:^(id response) {
        [LTNUtilsHelper removeLoadMessageBox];
        // 如果服务器端确保完成注册，保存sessionKey
        [CurrentUser loginSuccess:response[@"sessionKey"]];
        // 渠道跟踪
        [TalkingDataAppCpa onRegister:self.userNameField.text];

        if (response[@"resultMessage"]) {
            [LTNUtilsHelper boxShowWithMessage:response[@"resultMessage"]];
        }
        [LTNServerHelper retrieveUserInfoWithFinishBlock:nil];
        [LTNServerHelper retrieveAccountInfoWithFinishBlock:nil];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshInvestPage];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshHomePage];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshAccountInfo];
        [[NSUserDefaults standardUserDefaults] synchronize];

        // 注册成功  手势密码
        GesturePasswordController *gesturePasswordController= [GesturePasswordController createGesturePasswordController:^{
            kStrongSelf
            
            LTNAlertView * oauthAlertView = [[LTNAlertView alloc] initWithTitle:locationString(@"cong_register_success") message:locationString(@"register_success_prompt") delegate:self cancelButtonTitle:locationString(@"user_auth_cancel") otherButtonTitle:locationString(@"user_auth_now")];
            oauthAlertView.delegate = strongSelf;
            //[oauthAlertView show];
            [oauthAlertView showToController:self];
        }];
        GestureNavigationController * navController = [[GestureNavigationController alloc] initWithRootViewController:gesturePasswordController];
        [self presentViewController:navController animated:YES completion:nil];
        
        
        NSString *userMobile=esString(self.userNameField.text);
        [PiwikTracker sharedInstance].userID = userMobile;
        [PiwikTracker sharedInstance1].userID = userMobile;
        NSArray *piwikArr=@[
                            @[@"user_id",userMobile],
                            @[@"result",@"1"],
                            @[@"reason",@""],
                            @[@"source",@"ios"],
    
                            ];
        piwikEvent(@"register",piwikArr);
        
    } failure:^(NSError *error) {
        [LTNUtilsHelper removeLoadMessageBox];
        [LTNUtilsHelper boxShowWithMessage:error.localizedDescription duration:2.0f];
   
        
        NSArray *piwikArr=@[
                            @[@"user_id",esString(self.userNameField.text)],
                                 @[@"result",@"0"],
                                 @[@"reason",esString(error.description)],
                                 @[@"source",@"ios"],
                                 
                                 ];
        piwikEvent(@"register",piwikArr);
    }];
}


#pragma mark 显示密码
- (void)showPassword:(UIButton *)button
{
    // 默认未选中，为安全模式
    self.passwordField.secureTextEntry = button.selected;
    button.selected = !button.selected;
}

#pragma mark 发送验证码
- (void)getVerificationCode
{
    if (![LTNNetManager sharedLTNNetManager].isAvailable) {
        [LTNUtilsHelper openNetwork:self];
        return;
    }
    
    // 手机号需要正确
    if ([self.userNameField isTelphoneNum]) {
        [self startTimer];
        [LTNServerHelper getMobileCodeForRegisterWithMobileNo:self.userNameField.text success:^(id response) {
            DLog(@"%s, %@", __func__, response);
            // 如果已经注册，则提示用户
//            if (!([response[@"resultCode"] integerValue] == 0)) {
//                [self stopTimer];
//                NSString * message = response[@"resultMessage"];
//                [LTNUtilsHelper boxShowWithMessage:message duration:2.0f];
//            }
        } failure:^(NSError *error) {
//            [self stopTimer];
            DLog(@"%s, %@", __func__, error.localizedDescription);
        }];
    } else {
        // 如果输入的不是手机号，则提示用户
        [self.userNameField becomeFirstResponder];
        [LTNUtilsHelper boxShowWithMessage:locationString(@"get_correct_mobile") duration:2.0f];
    }
}

#pragma mark 发送验证码时间相关
- (void)startTimer
{
    self.getCaptchaButton.enabled = NO;
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(upateTime) userInfo:nil repeats:YES];
    }
    [self.timer fire];
}

- (void)stopTimer
{
    if(self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if(self.getCaptchaButton){
        self.getCaptchaButton.enabled = YES;
        [self.getCaptchaButton setTitle:locationString(@"reget_verify_code") forState:UIControlStateNormal];
        timeCount = 60;
    }
    
}
- (void)upateTime
{
    NSString * timeString = [NSString stringWithFormat:locationString(@"resendable_after_seconds"), timeCount--];
    [self.getCaptchaButton setTitle:timeString forState:UIControlStateDisabled];
    if (timeCount == 0) {
        [self stopTimer];
    }
}

#pragma mark - 实名认证alert代理方法
- (void)alertView:(LTNAlertView *)alertView clickedButtonAtIndex:(NSInteger)index
{
    if (index) {
        DLog(@"%s, 开始验证", __func__);
        VerifyRealNameViewController * verifyRealNameViewController = [VerifyRealNameViewController verifyRealNameControllerWithFinishBlock:^{
            if(self.finishRegisterBlock)
                self.finishRegisterBlock();
            
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];

        }];
        [self.navigationController pushViewController:verifyRealNameViewController animated:YES];
        
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    if(self.navigationController.finishBlock)
        self.navigationController.finishBlock();
    /*
    if(self.finishRegisterBlock)
        self.finishRegisterBlock();
     */
}

#pragma mark - textField代理方法
#pragma mark textField按回车
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == TagOfCapthaTextField && self.registerButton.enabled) {
        [self completeRegister:self.registerButton];
        return YES;
    }
    NSInteger tag = (textField.tag + 1) % TagOfTelephoneTextField % 3 + TagOfTelephoneTextField;
    UITextField * nextField = [self.view viewWithTag:tag];
    [nextField becomeFirstResponder];
    return YES;
}

#pragma mark textField内容变化
- (void)didChange:(NSNotification *)notification
{
    if (self.userNameField.text.length > 0 && self.passwordField.text.length > 0 && self.captchaField.text.length > 0 && self.agree) {
        self.registerButton.enabled = YES;
        return;
    }
    self.registerButton.enabled = NO;
}

#pragma mark textField清空
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.registerButton.enabled = NO;
    return YES;
}


@end
