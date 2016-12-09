//
//  LTNModifyController.m
//  lingtouniao
//
//  Created by LiuFeifei on 15/11/27.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNModifyController.h"
#import "LTNTextField.h"
#import "LTNPromptView.h"
#import "LTNUtilsHelper.h"
#import "LTNLoginController.h"


#define kSide 18
#define kMargin 15
#define kFieldHeight 49

typedef NS_ENUM(NSUInteger, TagOfTextField) {
    TagOfModifyPwdField = 100,
    TagOfModifyPwdAgainField
};

@interface LTNModifyController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton * confirmModifyButton;
@property (nonatomic, strong) LTNTextField * modifyPwdField;
@property (nonatomic, strong) LTNTextField * modifyPwdAgainField;

@end

@implementation LTNModifyController

    
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    //去除导航栏下方的横线
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(self.view.frame.size.width, 2)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = locationString(@"password_reset");
    self.view.backgroundColor = kHexColor(@"#f9f9f9");
    
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

- (void)setupUI
{
    LTNTextField * modifyPwdField = [[LTNTextField alloc] initWithFrame:CGRectMake(0, kMargin, kScreenWidth, kFieldHeight)];
    modifyPwdField.tag = TagOfModifyPwdField;
    modifyPwdField.backgroundColor = [UIColor whiteColor];
    modifyPwdField.drawTopLine = YES;
    modifyPwdField.drawBottomLine = YES;
    modifyPwdField.secureTextEntry = YES;
    modifyPwdField.placeholder = locationString(@"modify_password1");
    [modifyPwdField addLeftViewWithTitle:@"" leftMargin:kGeneralHeight * 0.5 leftWidth:kGeneralHeight * 0.5 leftViewMode:UITextFieldViewModeAlways];
    [modifyPwdField addClearButtonWithRightMargin:0 imageName:@"icon_delete"];
    modifyPwdField.delegate = self;
    [self.view addSubview:modifyPwdField];
    self.modifyPwdField = modifyPwdField;
    
    LTNTextField * modifyPwdAgainField = [[LTNTextField alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(modifyPwdField.frame), kScreenWidth, kFieldHeight)];
    modifyPwdAgainField.tag = TagOfModifyPwdAgainField;
    modifyPwdAgainField.backgroundColor = [UIColor whiteColor];
    modifyPwdAgainField.drawBottomLine = YES;
    modifyPwdAgainField.secureTextEntry = YES;
    modifyPwdAgainField.placeholder = locationString(@"modify_password2");
    [modifyPwdAgainField addLeftViewWithTitle:@"" leftMargin:kGeneralHeight * 0.5 leftWidth:kGeneralHeight * 0.5 leftViewMode:UITextFieldViewModeAlways];
    [modifyPwdAgainField addClearButtonWithRightMargin:0 imageName:@"icon_delete"];
    modifyPwdAgainField.delegate = self;
    [self.view addSubview:modifyPwdAgainField];
    self.modifyPwdAgainField = modifyPwdAgainField;
    
    LTNPromptView * promptView = [LTNPromptView promptWithIcon:@"icon_note_small" iconSpace:6 Text:locationString(@"password_info1") font:kFont(12) textWidth:kScreenWidth - 2 * kSide];
    CGRect promptFrame = promptView.bounds;
    promptFrame.origin.x = kSide;
    promptFrame.origin.y = CGRectGetMaxY(modifyPwdAgainField.frame) + kMargin;
    promptView.frame = promptFrame;
    [self.view addSubview:promptView];
    
    UIButton * confirmModifyButton = [[UIButton alloc] initWithFrame:CGRectMake(kSide, CGRectGetMaxY(promptView.frame) + 0.5 * kGeneralHeight, kScreenWidth - 2 * kSide, kGeneralHeight)];
    confirmModifyButton.layer.cornerRadius = 5;
    confirmModifyButton.layer.masksToBounds = YES;
    [confirmModifyButton setTitle:locationString(@"password_reset_confirm") forState:UIControlStateNormal];
    [confirmModifyButton setBackgroundImage:[UIImage imageWithColor:kHexColor(@"#cccccc") size:CGSizeMake(kScreenWidth - kSide * 2, kFieldHeight)] forState:UIControlStateDisabled];
    [confirmModifyButton setBackgroundImage:[UIImage imageWithColor:kHexColor(@"#ea5504")  size:CGSizeMake(kScreenWidth - kSide * 2, kFieldHeight)] forState:UIControlStateNormal];
    confirmModifyButton.enabled = NO;
    [confirmModifyButton addTarget:self action:@selector(clickConfirmModify:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmModifyButton];
    self.confirmModifyButton = confirmModifyButton;
}

#pragma mark - textField代理方法
#pragma mark textField按回车
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == TagOfModifyPwdAgainField && self.confirmModifyButton.enabled) {
        [self clickConfirmModify:self.confirmModifyButton];
        return YES;
    }
    NSInteger tag = (textField.tag + 1) % TagOfModifyPwdField % 2 + TagOfModifyPwdField;
    UITextField * nextField = [self.view viewWithTag:tag];
    [nextField becomeFirstResponder];
    return YES;
}

#pragma mark textField内容变化
- (void)didChange:(NSNotification *)notification
{
    if (self.modifyPwdField.text.length > 0 && self.modifyPwdAgainField.text.length > 0) {
        self.confirmModifyButton.enabled = YES;
        return;
    }
    self.confirmModifyButton.enabled = NO;
}

#pragma mark textField清空
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.confirmModifyButton.enabled = NO;
    return YES;
}

#pragma mark 确认修改密码
- (void)clickConfirmModify:(UIButton *)button
{
    if (![LTNNetManager sharedLTNNetManager].isAvailable) {
        [LTNUtilsHelper openNetwork:self];
        return;
    }
    if(![self.modifyPwdField.text isEqualToString:self.modifyPwdAgainField.text]) {
        [LTNUtilsHelper boxShowWithMessage:locationString(@"password_not_match")];
    } else {
        if ([self.modifyPwdField checkPassword]) {
            [LTNUtilsHelper boxShowLoadWithMessage:locationString(@"feed_back_submit")];
            [LTNServerHelper retrievePasswordWithMobileNo:self.telephoneNo newPassword:self.modifyPwdAgainField.text mobileCode:self.mobileCode idCard:self.idCardNo success:^(id response) {
                [LTNUtilsHelper removeLoadMessageBox];
                // 修改密码成功，跳转到登录页面
            	//[LTNServerHelper logoutSuccess:nil failure:nil];
            	[CurrentUser mine].sessionKey = nil;
                [self dismissViewControllerAnimated:NO completion:nil];
                if(self.navigationController.finishBlock)
                    self.navigationController.finishBlock();
                
                //[self.navigationController popToRootViewControllerAnimated:YES];
            } failure:^(NSError * error) {
                [LTNUtilsHelper removeLoadMessageBox];
                [LTNUtilsHelper boxShowWithMessage:error.localizedDescription];
            }];
        } else {
            [LTNUtilsHelper boxShowWithMessage:locationString(@"password_info1")];
        }
    }
}

@end
