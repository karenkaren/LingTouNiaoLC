//
//  LTNRetrieveController.m
//  lingtouniao
//
//  Created by LiuFeifei on 15/11/27.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNRetrieveController.h"
#import "LTNModifyController.h"
#import "LTNTextField.h"


#define kMargin DimensionBaseIphone6(15)
#define kFieldHeight DimensionBaseIphone6(49)
#define kCaptchaWidth DimensionBaseIphone6(105)
#define kLineHeight DimensionBaseIphone6(30)
#define kLineWidth 0.5

static int timeCount = 60;

typedef NS_ENUM(NSUInteger, TagOfTextField) {
    TagOfUserNameTextField = 100,
    TagOfCapthaTextField,
    TagOfIdCardTextField
};

@interface LTNRetrieveController ()<UITextFieldDelegate>

@property (nonatomic, strong) LTNTextField * userNameField;
@property (nonatomic, strong) UIButton * getCaptchaButton;
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, strong) LTNTextField * captchaField;
@property (nonatomic, strong) UIButton * confirmButton;
@property (nonatomic, strong) LTNTextField * idCardField;

@end


@implementation LTNResetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = locationString(@"reset_password");
}

@end


@implementation LTNRetrieveController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self dissmissWithBackButton];
    //去除导航栏下方的横线
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(self.view.frame.size.width, 2)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [self.view endEditing:YES];
    [self stopTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = locationString(@"get_password");
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
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 搭建页面
- (void)setupUI
{
    LTNTextField * userNameField = [[LTNTextField alloc] initWithFrame:CGRectMake(0, kMargin, kScreenWidth, kFieldHeight)];
    userNameField.tag = TagOfUserNameTextField;
    userNameField.delegate = self;
    userNameField.keyboardType = UIKeyboardTypeNumberPad;
    userNameField.limitedCount = 11;
    userNameField.drawTopLine = YES;
    userNameField.drawBottomLine = YES;
    userNameField.backgroundColor = kRGBAColor(255, 255, 255, 0.99);
    userNameField.keyboardType = UIKeyboardTypeNumberPad;
    [userNameField addLeftViewWithTitle:locationString(@"mobile_num") leftMargin:kGeneralHeight * 0.5 leftWidth:kCaptchaWidth leftViewMode:UITextFieldViewModeAlways];
    [userNameField addClearButtonWithRightMargin:0 imageName:@"icon_delete"];
    userNameField.placeholder = locationString(@"mobile_number_forgetpwd_hint");
    NSString * userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserNameKey];
    if (userName) {
        userNameField.text = userName;
    }
    [self.view addSubview:userNameField];
    self.userNameField = userNameField;
    
    LTNTextField * captchaField = [[LTNTextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(userNameField.frame), kScreenWidth, kFieldHeight)];
    captchaField.tag = TagOfCapthaTextField;
    captchaField.backgroundColor = kRGBAColor(255, 255, 255, 0.99);
    captchaField.delegate = self;
    captchaField.limitedCount = CAPTCHA_LIMIT;
    captchaField.keyboardType = UIKeyboardTypeNumberPad;
    captchaField.drawBottomLine = YES;
    [captchaField addLeftViewWithTitle:locationString(@"captcha") leftMargin:kGeneralHeight * 0.5 leftWidth:kCaptchaWidth leftViewMode:UITextFieldViewModeAlways];
    [captchaField addClearButtonWithRightMargin:kCaptchaWidth  imageName:@"icon_delete"];
    captchaField.placeholder = locationString(@"register_placeholder_mobile_code");
    [self.view addSubview:captchaField];
    self.captchaField = captchaField;
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(captchaField.frame) - kCaptchaWidth - kLineWidth, (kFieldHeight - kLineHeight) * 0.5, kLineWidth, kLineHeight)];
    lineView.backgroundColor = kHexColor(@"#e2e2e2");
    [captchaField addSubview:lineView];
    
    UIButton * getCaptchaButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(captchaField.frame) - kCaptchaWidth, CGRectGetMinY(captchaField.frame), kCaptchaWidth, kFieldHeight - kLineWidth)];
    [getCaptchaButton setTitleColor:kHexColor(@"#0090ff") forState:UIControlStateNormal];
    [getCaptchaButton setTitleColor:kHexColor(@"#cccccc") forState:UIControlStateDisabled];
    [getCaptchaButton setTitle:locationString(@"get_verify_code") forState:UIControlStateNormal];
    [getCaptchaButton.titleLabel setFont:kFont(15)];
    [getCaptchaButton addTarget:self action:@selector(getVerificationCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getCaptchaButton];
    self.getCaptchaButton = getCaptchaButton;
    
    LTNTextField * idCardField = [[LTNTextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(captchaField.frame) + kMargin, kScreenWidth, kFieldHeight)];
    idCardField.tag = TagOfIdCardTextField;
    idCardField.delegate = self;
    idCardField.hidden = YES;
    idCardField.autocorrectionType = UITextAutocorrectionTypeNo;
    idCardField.limitedCount = 18;
    idCardField.drawTopLine = YES;
    idCardField.drawBottomLine = YES;
    idCardField.backgroundColor = [UIColor whiteColor];
    [idCardField addLeftViewWithTitle:locationString(@"identity_card") leftMargin:kGeneralHeight * 0.5 leftWidth:kCaptchaWidth leftViewMode:UITextFieldViewModeAlways];
    [idCardField addClearButtonWithRightMargin:0 imageName:@"icon_delete"];
    [self.view addSubview:idCardField];
    self.idCardField = idCardField;
    
    UIButton * confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(captchaField.frame) + kMargin * 2, kScreenWidth - 20 * 2, kGeneralHeight)];
    confirmButton.layer.cornerRadius = 5;
    confirmButton.layer.masksToBounds = YES;
    [confirmButton setTitle:locationString(@"btn_confirm") forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageWithColor:kHexColor(@"#cccccc") size:CGSizeMake(kScreenWidth - kMargin * 2, kGeneralHeight)] forState:UIControlStateDisabled];
    [confirmButton setBackgroundImage:[UIImage imageWithColor:kHexColor(@"#ea5504") size:CGSizeMake(kScreenWidth - kMargin * 2, kGeneralHeight)] forState:UIControlStateNormal];
    confirmButton.enabled = NO;
    [confirmButton addTarget:self action:@selector(clickConfirm:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
    self.confirmButton = confirmButton;
}

#pragma mark - textField delegate
#pragma mark textField按回车
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    LTNTextField * lastTextField = self.idCardField.hidden ? self.captchaField : self.idCardField;
    NSInteger textFieldCount = self.idCardField.hidden ? 2 : 3;
    if (textField.tag == lastTextField.tag && self.confirmButton.enabled) {
        [self clickConfirm:self.confirmButton];
        return YES;
    }
    NSInteger tag = (textField.tag + 1) % TagOfUserNameTextField % textFieldCount + TagOfUserNameTextField;
    UITextField * nextField = [self.view viewWithTag:tag];
    [nextField becomeFirstResponder];
    return YES;
}

#pragma mark textField内容变化
- (void)didChange:(NSNotification *)notification
{
    if (!self.idCardField.hidden && [self.idCardField.text isEqualToString:@""]) {
        self.confirmButton.enabled = NO;
        return;
    }
    self.confirmButton.enabled = (self.userNameField.text.length > 0 && self.captchaField.text.length > 0) ? YES : NO;
}

#pragma mark textField清空
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.confirmButton.enabled = NO;
    return YES;
}

#pragma mark 获取短信验证码
- (void)getVerificationCode
{
    if (![LTNNetManager sharedLTNNetManager].isAvailable) {
        [LTNUtilsHelper openNetwork:self];
        return;
    }
    
    // 手机号需要正确
    if ([self.userNameField isTelphoneNum]) {
        [self startTimer];
        [LTNServerHelper getMobileCodeForRetrieveWithMobileNo:self.userNameField.text success:^(id response) {
            if ([response[@"resultCode"] integerValue] == 0) {
                // 如果用户已经进行了实名验证，需要输入身份证号码
                if ([response[@"data"][@"certification"] intValue]) {
                    if (self.idCardField.hidden) {
                        self.idCardField.hidden = NO;
                        self.confirmButton.enabled = NO;
                        CGRect idCardFrame = self.idCardField.frame;
                        CGRect  confirmFrame = self.confirmButton.frame;
                        idCardFrame.size.height = kGeneralHeight;
                        confirmFrame.origin.y += idCardFrame.size.height + kMargin;
                        kWeakSelf
                        [UIView animateWithDuration:0.1f animations:^{
                            weakSelf.idCardField.frame = idCardFrame;
                            weakSelf.confirmButton.frame = confirmFrame;
                        }];
                    }
                }
            }
        } failure:^(NSError *error) {
            // 有错误不需要处理
//            [self stopTimer];
//            [LTNUtilsHelper boxShowWithMessage:error.localizedDescription];
            DLog(@"%s, %@", __func__, error.localizedDescription);
        }];
    } else {
        [LTNUtilsHelper boxShowWithMessage:locationString(@"get_correct_mobile")];
    }
}

#pragma mark 提交手机号、身份证号、短信验证码审核
- (void)clickConfirm:(UIButton *)confirmBtn
{
    [self.view endEditing:YES];
    if (![LTNNetManager sharedLTNNetManager].isAvailable) {
        [LTNUtilsHelper openNetwork:self];
        return;
    }
    
    if (![self.userNameField isTelphoneNum]) {
        [self.userNameField becomeFirstResponder];
        [LTNUtilsHelper boxShowWithMessage:locationString(@"get_correct_mobile")];
        return;
    }

    if (self.captchaField.text.length != CAPTCHA_LIMIT) {
        self.captchaField.text = @"";
        [self.captchaField becomeFirstResponder];
        [LTNUtilsHelper boxShowWithMessage:locationString(@"get_correct_verifycode")];
        return;
    }
    
    if (!self.idCardField.hidden && ![self.idCardField isValidateIDCardNumber]) {
        [self.idCardField becomeFirstResponder];
        [LTNUtilsHelper boxShowWithMessage:locationString(@"get_correct_idcard")];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.userNameField.text forKey:kUserNameKey];

    [LTNUtilsHelper boxShowLoadWithMessage:locationString(@"feed_back_submit")];
    [LTNServerHelper verifyMobilCodeWithMobileNo:self.userNameField.text mobilCode:self.captchaField.text idCard:self.idCardField.text success:^(id response) {
        [LTNUtilsHelper removeLoadMessageBox];
        LTNModifyController * modifyController = [[LTNModifyController alloc] init];
        modifyController.mobileCode = self.captchaField.text;
        modifyController.telephoneNo = self.userNameField.text;
        modifyController.idCardNo = self.idCardField.text;
        [self.navigationController pushViewController:modifyController animated:YES];
    } failure:^(NSError *error) {
        [LTNUtilsHelper removeLoadMessageBox];
        [LTNUtilsHelper boxShowWithMessage:error.localizedDescription duration:2.0f];
        DLog(@"%s, %@", __func__, error.localizedDescription);
    }];
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
    self.getCaptchaButton.enabled = YES;
    [self.getCaptchaButton setTitle:locationString(@"reget_verify_code") forState:UIControlStateNormal];
    timeCount = 60;
}

- (void)upateTime
{
    NSString * timeString = [NSString stringWithFormat:locationString(@"resendable_after_seconds"), timeCount--];
    [self.getCaptchaButton setTitle:timeString forState:UIControlStateDisabled];
    if (timeCount == 0) {
        [self stopTimer];
    }
}

@end
