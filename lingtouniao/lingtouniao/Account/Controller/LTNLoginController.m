//
//  LTNLoginController.m
//  lingtouniao
//
//  Created by LiuFeifei on 15/11/11.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNLoginController.h"
#import "LTNRegisterController.h"
#import "LTNRetrieveController.h"
#import "LTNTextField.h"

#import "GesturePasswordController.h"
#import "MMBNetAddressSettingViewController.h"

#define kSide 18
#define kMargin DimensionBaseIphone6(30)
#define kLineHeight DimensionBaseIphone6(30)
#define kLineWidth 0.5
#define kFieldHeight DimensionBaseIphone6(49)
#define kCaptchaWidth DimensionBaseIphone6(98)

typedef NS_ENUM(NSUInteger, TagOfTextField) {
    TagOfUserNameTextField = 100,
    TagOfPasswordTextField,
    TagOfCapthaTextField,
};

@interface LTNLoginController ()<UITextFieldDelegate>

@property (nonatomic, strong) LTNTextField * userNameField;
@property (nonatomic, strong) LTNTextField * passwordField;
@property (nonatomic, strong) LTNTextField * captchaField;
@property (nonatomic, copy) NSString * machineNo;
@property (nonatomic, strong) UIImageView * pictureImageView;
@property (nonatomic, strong) UIButton * loginButton;
@property (nonatomic, strong) UIActivityIndicatorView * activityView;

@end

@implementation LTNLoginController


+(instancetype)loginControllerWithFinishBlock:(VoidBlock)finishLoginBlock{
    LTNLoginController *loginController = [[LTNLoginController alloc] init];
    loginController.finishLoginBlock = finishLoginBlock;
    return loginController;
}
 

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
//    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewWillAppear:(BOOL)animated{

    // Called when the view is about to made visible. Default does nothing
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    // 获取图片验证码
    [self getPicCaptcha];
    
    [self dissmissWithBackButton];
    
    //去除导航栏下方的横线
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(self.view.frame.size.width, 2)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // navigationBar title
    self.title = locationString(@"login_label_signin");

    // navigationBar right button
    UIColor * grayColor = kHexColor(@"#3a3a3a");
    CGSize size = kStringSize(locationString(@"login_label_register"), 16);
    CGFloat registerWidth = size.width + kGeneralHeight;
    UIButton * registerButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - registerWidth, 0, registerWidth, kGeneralHeight)];
    [registerButton setTitle:locationString(@"login_label_register") forState:UIControlStateNormal];
    [registerButton setTitleColor:grayColor forState:UIControlStateNormal];
    [registerButton.titleLabel setFont:kFont(16)];
    [registerButton addTarget:self action:@selector(registerAccount) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:registerButton];
    self.navigationItem.rightBarButtonItem.tintColor = grayColor;
    
    // 搭建UI
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

- (void)back {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

#pragma mark 搭建页面
- (void)setupUI
{
    CGFloat width = kScreenWidth - kSide * 2;
    
    // 用户名输入框
    LTNTextField * userNameField = [[LTNTextField alloc] initWithFrame:CGRectMake(kSide, kMargin, width, kFieldHeight)];
    userNameField.delegate = self;
    userNameField.keyboardType = UIKeyboardTypeNumberPad;
    userNameField.limitedCount = 11;
    userNameField.tag = TagOfUserNameTextField;
    userNameField.drawBottomLine = YES;
    userNameField.placeholder = locationString(@"mobile_number_hint");
    [userNameField addLeftViewWithImageName:@"icon_username" leftMargin:12 leftViewMode:UITextFieldViewModeAlways];
    [userNameField addClearButtonWithRightMargin:0 imageName:@"icon_delete"];
    NSString * userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserNameKey];
    if (userName) {
        userNameField.text = userName;
    }
    [self.view addSubview:userNameField];
    self.userNameField = userNameField;
    
    // 密码输入框
    LTNTextField * passwordField = [[LTNTextField alloc] initWithFrame:CGRectMake(kSide, CGRectGetMaxY(userNameField.frame), width, kFieldHeight)];
    passwordField.delegate = self;
    passwordField.limitedCount = 18;
    passwordField.tag = TagOfPasswordTextField;
    passwordField.drawBottomLine = YES;
    passwordField.placeholder = locationString(@"new_password_hint");
    passwordField.secureTextEntry = YES;
    [passwordField addLeftViewWithImageName:@"icon_password" leftMargin:12 leftViewMode:UITextFieldViewModeAlways];
    [passwordField addRightViewWithImageName:@"icon_hide" selectImageName:@"icon_show" rightViewMode:UITextFieldViewModeAlways target:self action:@selector(showPassword:)];
    [passwordField addClearButtonWithRightMargin:0 imageName:@"icon_delete"];
    [self.view addSubview:passwordField];
    self.passwordField = passwordField;

    // 验证码输入框
    LTNTextField * captchaField = [[LTNTextField alloc] initWithFrame:CGRectMake(kSide, CGRectGetMaxY(passwordField.frame), width, kFieldHeight)];
    captchaField.delegate = self;
    captchaField.keyboardType = UIKeyboardTypeNumberPad;
    captchaField.limitedCount = CAPTCHA_LIMIT;
    captchaField.tag = TagOfCapthaTextField;
    captchaField.drawBottomLine = YES;
    captchaField.placeholder = locationString(@"verifycode_hint");
    [captchaField addLeftViewWithImageName:@"icon_captcha" leftMargin:12 leftViewMode:UITextFieldViewModeAlways];
    
    // 验证码输入框分隔线
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(width - 55 - kLineWidth, 0.5 * (kFieldHeight - kLineHeight), kLineWidth, kLineHeight)];
    lineView.backgroundColor = kHexColor(@"#e2e2e2");
    [captchaField addSubview:lineView];
    
    [captchaField addClearButtonWithRightMargin:CGRectGetWidth(captchaField.frame) - CGRectGetMaxX(lineView.frame) imageName:@"icon_delete"];
    [self.view addSubview:captchaField];
    self.captchaField = captchaField;
    
    // 获取图片验证码
    UIImageView * pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(captchaField.frame) - 55, CGRectGetMinY(captchaField.frame), 60, captchaField.frame.size.height - kLineWidth)];
    pictureImageView.image = [UIImage imageNamed:@"placeholder_refresh"];
    pictureImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPicture:)];
    [pictureImageView addGestureRecognizer:tap];
    [self.view addSubview:pictureImageView];
    self.pictureImageView = pictureImageView;
    
    // 获取图片验证码莲花状态
    UIActivityIndicatorView * activityView = [[UIActivityIndicatorView alloc] initWithFrame:pictureImageView.frame];
    activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [activityView startAnimating];
    activityView.hidesWhenStopped = YES;
    activityView.hidden = YES;
    [self.view addSubview:activityView];
    self.activityView = activityView;
    
    // 登录按钮
    UIButton * loginButton = [[UIButton alloc] initWithFrame:CGRectMake(kSide, CGRectGetMaxY(captchaField.frame) + 30, width, kGeneralHeight)];
    loginButton.layer.cornerRadius = 5;
    loginButton.layer.masksToBounds = YES;
    [loginButton setTitle:locationString(@"login_label_signin") forState:UIControlStateNormal];
    [loginButton setDisenableBackgroundColor:kHexColor(@"#cccccc") enableBackgroundColor:kHexColor(@"#ea5504")];
    loginButton.enabled = NO;
    [loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    self.loginButton = loginButton;
    
    // 忘记密码按钮
    CGSize retrieveSize = kStringSize(locationString(@"forgotten_password"), 16);
    UIButton * retrievePasswordButton = [[UIButton alloc] initWithFrame:CGRectMake(kSide, CGRectGetMaxY(loginButton.frame) + kGeneralHeight * 0.5, width, retrieveSize.height)];
    [retrievePasswordButton.titleLabel setFont:kFont(16)];
    [retrievePasswordButton setTitleColor:kHexColor(@"#0090ff") forState:UIControlStateNormal];
    [retrievePasswordButton setTitle:locationString(@"forgotten_password") forState:UIControlStateNormal];
    [retrievePasswordButton addTarget:self action:@selector(retrievePassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:retrievePasswordButton];
    
    
    
#if (defined(ADHOC) || defined(DEBUG))
    
    
    UIButton * severButton = [[UIButton alloc] initWithFrame:CGRectMake(kSide, CGRectGetMaxY(retrievePasswordButton.frame) + 30, width, kGeneralHeight)];
    severButton.layer.cornerRadius = 5;
    severButton.layer.masksToBounds = YES;
    [severButton setTitle:@"设置服务器" forState:UIControlStateNormal];
    [severButton setDisenableBackgroundColor:kHexColor(@"#cccccc") enableBackgroundColor:[UIColor blueColor]];
    [severButton addTarget:self action:@selector(setServer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:severButton];
    

    
#endif

}

-(void)setServer{
    MMBNetAddressSettingViewController *vc = [[MMBNetAddressSettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark 显示密码
- (void)showPassword:(UIButton *)button
{
    button.selected = !button.selected;
    // 默认未选中，为安全模式
    self.passwordField.secureTextEntry = !button.selected;
}

#pragma mark 获取图片验证码
- (void)getPicCaptcha
{
    if (![LTNNetManager sharedLTNNetManager].isAvailable) {
        [LTNUtilsHelper openNetwork:self];
        return;
    }
    self.activityView.hidden = NO;
    self.machineNo = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [LTNServerHelper getPictureCodeWithMachineNo:self.machineNo success:^(id response) {
        self.activityView.hidden = YES;
        NSData * data = (NSData *)response;
        UIImage * image = [UIImage imageWithData:data];
        if (image) {
            self.pictureImageView.image = image;
            DLog(@"%s, 成功获取图片验证码", __func__);
        }
    } failure:^(NSError *error) {
        self.activityView.hidden = YES;
        DLog(@"%s, 获取图片验证码失败", __func__);
    }];
}

#pragma mark 点击手势
- (void)tapPicture:(UITapGestureRecognizer *)tap
{
    [self getPicCaptcha];
}

#pragma mark 找回密码
- (void)retrievePassword
{
    LTNRetrieveController * retrieveController = [[LTNRetrieveController alloc] init];
        UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:retrieveController];
        [self presentViewController:navi animated:YES completion:^{
    
        }];
}


-(BOOL)shouldSetGesturePassword{
    
    if(self.ShouldSetGesturePassword)
        return YES;
    //不需要设置手势密码需要满足一下条件 ：1.本地已有帐号 2.该帐号和将要登陆的账号相同 3.已经有手势密码 这三个条件都满足才不需要设置手势密码
    NSString * userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserNameKey];
    
    if(userName&&
       [esString(userName) isEqualToString:esString(self.userNameField.text)]&&
       [GesturePasswordController existKeychainPassword])
        return NO;
    return YES;
    /*
    if(userName){
        if([esString(userName) isEqualToString:esString(self.userNameField.text)]){
            if([GesturePasswordController existKeychainPassword])
                return NO;
            else
                return YES;
        }else
            return YES;
        
    }else{
        return YES;
        
    }
     */
}


#pragma mark 用户登录
- (void)login:(UIButton *)loginButton
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
        self.passwordField.text = @"";
        [self.passwordField becomeFirstResponder];
        [LTNUtilsHelper boxShowWithMessage:locationString(@"password_info1")];
        return;
    }
    if (self.captchaField.text.length != CAPTCHA_LIMIT) {
        self.captchaField.text = @"";
        [self.captchaField becomeFirstResponder];
        [LTNUtilsHelper boxShowWithMessage:locationString(@"captcha_error")];
        [self getPicCaptcha];
        return;
    }
    
    [self.view endEditing:YES];
    // 输入的信息初步判断无误
    NSString * idfa = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    BOOL ShouldSetGesturePassword = [self shouldSetGesturePassword];//！！此判断必须要在本地保存用户名之前判断
   

    NSDictionary * dictionary = @{@"mobileNo" : self.userNameField.text,
                                  @"password" : self.passwordField.text,
                                  @"machineNo" : idfa,
                                  @"pictureCode" : self.captchaField.text};

    kWeakSelf
    [self apiForPath:kUserLoginUrl method:kPostMethod parameter:dictionary responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        kStrongSelf
        if (!error) {
            // 登录成功，跳转到“我的账户”页面
            [CurrentUser loginSuccess:data[@"sessionKey"]];
            
            [[NSUserDefaults standardUserDefaults] setBool:[data[@"isXS"] boolValue] forKey:@"FirstData"];
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshInvestPage];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshHomePage];
           // [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshAccountInfo];
            
             [[NSUserDefaults standardUserDefaults] setObject:self.userNameField.text forKey:kUserNameKey];
    
            [[NSUserDefaults standardUserDefaults] synchronize];

            //如果是新用户，或者没有手势密码  设置收拾密码
            if(ShouldSetGesturePassword){
                
                //ESWeakSelf;
                
                [LTNServerHelper retrieveAccountInfoWithFinishBlock:^{
                    
                }];
                [LTNServerHelper retrieveUserInfoWithFinishBlock:^(void){
                    
                }];

                GesturePasswordController *gesturePasswordController = [GesturePasswordController createGesturePasswordController:nil];
                [strongSelf.navigationController setViewControllers:@[gesturePasswordController] animated:YES];
            }else{
                [self getUserInfoAfterFinishLogin];
            }
        } else {
            self.captchaField.text = @"";
            [self getPicCaptcha];
        }
    }];
}

-(void)getUserInfoAfterFinishLogin{
    [LTNServerHelper retrieveAccountInfoWithFinishBlock:^{
        
        if(self.navigationController.finishBlock){
                        
            self.navigationController.finishBlock();
        }
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    [LTNServerHelper retrieveUserInfoWithFinishBlock:^(void){
        
    }];
}

#pragma mark 注册用户
- (void)registerAccount
{
    LTNRegisterController * registerController = [LTNRegisterController registerControllerWithFinishBlock:self.finishLoginBlock];
    [self.navigationController pushViewController:registerController animated:YES];
}

#pragma mark textField delegate
#pragma mark textField按回车
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == TagOfCapthaTextField && self.loginButton.enabled) {
        [self login:self.loginButton];
        return YES;
    }
    NSInteger tag = (textField.tag + 1) % TagOfUserNameTextField % 3 + TagOfUserNameTextField;
    UITextField * nextField = [self.view viewWithTag:tag];
    [nextField becomeFirstResponder];
    return YES;
}

#pragma mark textField内容变化
- (void)didChange:(NSNotification *)notification
{
    if (self.userNameField.text.length > 0 && self.passwordField.text.length > 0 && self.captchaField.text.length > 0) {
        self.loginButton.enabled = YES;
        return;
    }
    self.loginButton.enabled = NO;
}

#pragma mark textField清空
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.loginButton.enabled = NO;
    return YES;
}

@end
