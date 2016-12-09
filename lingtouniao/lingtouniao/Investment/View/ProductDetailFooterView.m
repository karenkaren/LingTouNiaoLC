//
//  ProductDetailFooterView.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/9/24.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "ProductDetailFooterView.h"

#define kSide 10
#define kMargin 20

@interface ProductDetailFooterView ()<UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UIButton * purchaseOnceButton;
@property (nonatomic, assign) FooterType footerType;
@property (nonatomic, strong) UILabel * accountLabel;

@end

@implementation ProductDetailFooterView

- (instancetype)initWithType:(FooterType)footerType delegate:(id<ProductDetailFooterViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.footerType = footerType;
        self.delegate = delegate;
        [self setupUIWithType:footerType];
    }
    return self;
}

#pragma mark - 设置ui
- (void)setupUIWithType:(FooterType)footerType
{
    switch (footerType) {
        case FooterTypeOfNormal:
            [self setupNormal];
            break;
        case FooterTypeOfLogin:
            [self setupLogin];
            break;
        case FooterTypeOfTYB:
            [self setupTYB];
            break;
        case FooterTypeOfXSB:
            [self setupXSB];
            break;
        default:
            self.height = 0;
            break;
    }
}

- (void)setupNormal
{
    // 如果是非体验标
    self.frame = CGRectMake(0, kScreenHeight - 75 - 64, kScreenWidth, 75);
    self.backgroundColor = kRGBColor(255, 253, 227);
    
    UITextField * amountTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 49, self.bounds.size.width * 2.0 / 3, 49)];
    amountTextField.delegate = self;
    amountTextField.backgroundColor = [UIColor whiteColor];
    amountTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSide, 49)];
    amountTextField.leftViewMode = UITextFieldViewModeAlways;
    amountTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:amountTextField];
    self.amountTextField = amountTextField;
    
    CGFloat purchaseX = CGRectGetMaxX(amountTextField.frame);
    CGFloat purchaseY = CGRectGetMinY(amountTextField.frame);
    CGFloat purchaseW = self.bounds.size.width - CGRectGetWidth(amountTextField.frame);
    UIButton * purchaseButton = [[UIButton alloc] initWithFrame:CGRectMake(purchaseX, purchaseY, purchaseW, 49)];
    purchaseButton.backgroundColor = HexRGB(0xea5504);
    [purchaseButton setTitle:locationString(@"btn_confirm_yes") forState:UIControlStateNormal];
    [purchaseButton addTarget:self action:@selector(purchseProduct:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:purchaseButton];
    
    UILabel * accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGRectGetMinY(amountTextField.frame))];
    accountLabel.font = [CustomerizedFont systemFontOfSize:12];
    accountLabel.textColor = HexRGB(0xea5504);
    accountLabel.layer.borderWidth = 0.5;
    accountLabel.layer.borderColor = [HexRGB(0xfaecce) CGColor];
    [self addSubview:accountLabel];
    self.accountLabel = accountLabel;
    [self refreshNormal];
    UIButton * purchaseOnceButton = [Utility createButtonWithTitle:locationString(@"product_details_max_money") color:kHexColor(@"#0090ff") font:[CustomerizedFont systemFontOfSize:12] block:^(UIButton *btn) {
        // 一次性全投
        if (self.delegate && [self.delegate respondsToSelector:@selector(purchaseOnce:)]) {
            [self.delegate purchaseOnce:btn];
        }
    }];
    purchaseOnceButton.frame = CGRectMake(purchaseButton.left, 0, purchaseButton.width, accountLabel.height);
    [self addSubview:purchaseOnceButton];
    self.purchaseOnceButton = purchaseOnceButton;
}

- (void)setupLogin
{
    self.frame = CGRectMake(0, kScreenHeight - 60 - 64, kScreenWidth, 60);
    self.backgroundColor = BACKGROUND_COLOR;
    
    CGFloat width = self.bounds.size.width * 0.5 - kMargin * 2;
    NSArray * enterTypes = @[@(FooterEnterTypeOfLogin), @(FooterEnterTypeOfRegister)];
    NSArray * buttonTitles = @[locationString(@"login_label_signin"), locationString(@"login_label_register")];
    CGFloat y = (self.bounds.size.height - kGeneralHeight) * 0.5;
    for (int i = 0; i < 2; i++) {
        UIButton * button = [Utility createButtonWithTitle:buttonTitles[i] color:[UIColor whiteColor] font:kFont(18) block:^(UIButton *btn) {
            FooterEnterType enterType = [enterTypes[i] integerValue];
            if (self.delegate && [self.delegate respondsToSelector:@selector(enterPlatformWithFooterEnterType:)]) {
                [self.delegate enterPlatformWithFooterEnterType:enterType];
            }
        }];
        button.frame = CGRectMake(kMargin * (i * 2 + 1) + width * i, y, width, kGeneralHeight);
        button.backgroundColor = HexRGB(0xf88800);
        button.layer.cornerRadius = 10;
        button.layer.masksToBounds = YES;
        [self addSubview:button];
    }
}

- (void)setupTYB
{
    self.frame = CGRectMake(0, kScreenHeight - kGeneralHeight - 64, kScreenWidth, kGeneralHeight);
    UIButton * button = [[UIButton alloc] initWithFrame:self.bounds];
    button.backgroundColor = [UIColor colorWithHexString:@"#ea5504"];
    [button setTitle:locationString(@"product_item_buy") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(purchseProduct:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)setupXSB
{
    [self setupNormal];
    [self refreshXSB];
    self.purchaseOnceButton.hidden = YES;
}

#pragma mark - private methods
#pragma mark 点击确定购买
- (void)purchseProduct:(UIButton *)button
{
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    button.enabled = NO;
    [self performSelector:@selector(judgeValidity:) withObject:button afterDelay:1.0];
}

- (void)judgeValidity:(UIButton *)button
{
    button.enabled = YES;
    if (!(self.footerType == FooterTypeOfTYB)) {
        // 判断是否实名
        if (![CurrentUser verifyedRealName]) {
            // 未实名
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:locationString(@"hint") message:locationString(@"realname_text") delegate:self cancelButtonTitle:locationString(@"cancel") otherButtonTitles:locationString(@"goto_verifyed_real_name"), nil];
            alert.tag = 100;
            [alert show];
            return;
        }
        
        //判断是否有钱，没钱再判断是否邦卡
        if([CurrentUser mine].accountInfo.usableBalance<=0){
            if (![CurrentUser bindedBankCard]) {
                // 未绑卡
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:locationString(@"hint") message:locationString(@"should_bound_bank") delegate:self cancelButtonTitle:locationString(@"cancel") otherButtonTitles:locationString(@"bind_bank_now1"), nil];
                alert.tag = 200;
                [alert show];
                return;
            }
        }
                //pc端和手机端可以同时登陆，在进行提现操作的时候先进行账户金额的刷新
        [LTNServerHelper retrieveAccountInfoWithFinishBlock:^{
            [self refreshWithFooterType:self.footerType];
        }];
        
        // 判断输入金额
        if (![self.amountTextField isPureDouble]) {
            [LTNUtilsHelper boxShowWithMessage:locationString(@"amount_type_error")];
            return;
        }
        
        if (![self.amountTextField isInterger]) {
            [LTNUtilsHelper boxShowWithMessage:locationString(@"amount_should_interger")];
            return;
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(purchseProduct:)]) {
        [self.delegate purchseProduct:button];
    }
}

#pragma mark 刷新控件
- (void)refreshWithFooterType:(FooterType)footerType
{
    if (self.footerType != footerType) {
        self.footerType = footerType;
        [self removeAllSubviews];
        [self setupUIWithType:footerType];
    }
    switch (footerType) {
        case FooterTypeOfNormal:
            [self refreshNormal];
            break;
        case FooterTypeOfXSB:
            [self refreshXSB];
            break;
        case FooterTypeOfTYB:
            [self refreshTYB];
            break;
        case FooterTypeOfLogin:
            [self refreshLogin];
            break;
        default:
            self.height = 0;
            break;
    }
}

- (void)refreshLogin
{
    
}

- (void)refreshNormal
{
    double usableBalance = [CurrentUser mine].accountInfo.usableBalance;
    double birdCoin = [CurrentUser mine].accountInfo.birdCoin;
    NSString * accountText = [NSString stringWithFormat:locationString(@"product_usable_balance_and_bird_coin"), usableBalance, birdCoin];
    self.accountLabel.text = accountText;
}

- (void)refreshXSB
{
    double usableBalance = [CurrentUser mine].accountInfo.usableBalance;
    NSString * accountText = [NSString stringWithFormat:locationString(@"product_usable_balance"), usableBalance];
    self.accountLabel.text = accountText;
}

- (void)refreshTYB
{
    
}

#pragma mark 移除所有子试图
- (void)removeAllSubviews
{
    if (self.subviews.count > 0) {
        for (UIView * subview in self.subviews) {
            [subview removeFromSuperview];
        }
    }
}

#pragma mark - text field delegate
//textField.text 输入之前的值         string 输入的字符
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length >= 10 && ![string isEqualToString:@""]) {
        [LTNUtilsHelper boxShowWithMessage:locationString(@"amount_form_error1")];
        textField.text = [textField.text substringWithRange:NSMakeRange(0, 10)];
        return NO;
    }
    
    if ([string length] > 0) {
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if (single >= '0' && single <= '9')//数据格式正确
        {
            //首字母不能为0
            if([textField.text length] == 0 && single == '0'){
                [LTNUtilsHelper boxShowWithMessage:locationString(@"amount_form_error2")];
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            } else
                return YES;
        } else {//输入的数据格式不正确
            [LTNUtilsHelper boxShowWithMessage:locationString(@"amount_form_error3")];
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    } else
        return YES;
}

#pragma mark alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        switch (alertView.tag) {
            case 100:
                [LTNCore verifyRealNameViewController:nil];
                break;
            case 200:
                [LTNCore boundBankCardViewController:nil];
                break;
            default:
                break;
        }
    }
}

@end
