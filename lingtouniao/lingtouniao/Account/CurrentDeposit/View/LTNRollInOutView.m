//
//  LTNRollInOutView.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/1/21.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNRollInOutView.h"
#import "LTNTextField.h"
#import "LTNPromptView.h"
#import "LTNAgreeView.h"

#define kSingleViewHeight 48

@interface LTNRollInOutView ()<UITextFieldDelegate>
{
    RollType _rollType;
    LTNMyCurrentDepositModel * _currentDepositInfo;
    UILabel * _dataLabel;
    BOOL _isHaveDian;
}

@property (nonatomic, strong) LTNTextField * amountTextField;
@property (nonatomic, strong) UIButton * rollInOutButton;
@property (nonatomic, assign) BOOL agree;

@end

@implementation LTNRollInOutView

- (instancetype)initWithType:(RollType)rollType currentDepositInfo:(LTNMyCurrentDepositModel *)currentDepositInfo target:(id)target
{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - SYSTEM_NAVIGATION_HEIGHT - StatusBarHeight)];
    if (self) {
        _rollType = rollType;
        _delegate = target;
        _currentDepositInfo = currentDepositInfo;
        [self setupUI];
    }
    return self;
}

#pragma mark 构建界面
- (void)setupUI
{
    NSString * title = _rollType ? locationString(@"my_current_account_out") : locationString(@"usable_balance");
    NSString * data = _rollType ? [NSString stringWithFormat:@"¥%.2f", _currentDepositInfo.current_hold_amount] : [NSString stringWithFormat:@"¥%.2f", [CurrentUser mine].accountInfo.usableBalance];
    double placeholderAmount = _rollType ? _currentDepositInfo.current_hold_amount : _currentDepositInfo.current_remain_amount;
    NSString * placeholder = [NSString stringWithFormat:@"%@¥%.2f", _rollType ? locationString(@"my_current_account_money_edit") : locationString(@"my_current_account_money_purchase"), placeholderAmount];
    
    // 可转入、转出额度
    UIView * usableBalanceView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, kScreenWidth, kSingleViewHeight * 2)];
    usableBalanceView.backgroundColor = [UIColor whiteColor];
    usableBalanceView.layer.borderColor = [HexRGB(0xe2e2e2) CGColor];
    usableBalanceView.layer.borderWidth = [Utility lineWidth];
    [self addSubview:usableBalanceView];
    
    UILabel * titleLabel = [Utility createLabel:kFont(18) color:HexRGB(0x3a3a3a)];
    titleLabel.text = title;
    [titleLabel sizeToFit];
    titleLabel.height = kSingleViewHeight;
    titleLabel.left = 24;
    [usableBalanceView addSubview:titleLabel];
    
    UILabel * dataLabel = [Utility createLabel:kFont(18) color:HexRGB(0x3a3a3a)];
    dataLabel.text = data;
    [dataLabel sizeToFit];
    dataLabel.height = kSingleViewHeight;
    dataLabel.right = usableBalanceView.width - 24;
    [usableBalanceView addSubview:dataLabel];
    _dataLabel = dataLabel;
    
    // 输入金额
    LTNTextField * amountTextField = [[LTNTextField alloc] initWithFrame:CGRectMake(0, titleLabel.bottom, usableBalanceView.width, kSingleViewHeight)];
    amountTextField.delegate = self;
    amountTextField.font = [CustomerizedFont boldHeiti:16];
    [amountTextField addLeftViewWithTitle:@"¥" leftMargin:24 leftWidth:44 leftViewMode:UITextFieldViewModeAlways];
    amountTextField.drawTopLine = YES;
    amountTextField.placeholder = placeholder;
    amountTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [usableBalanceView addSubview:amountTextField];
    self.amountTextField = amountTextField;
    
    // 温馨提示
    double annualIncomeRate = [[_currentDepositInfo.annual_income_rate componentsSeparatedByString:@"%"].firstObject doubleValue] * 0.01;
    NSInteger promptAmonut = ceil(3.6 / annualIncomeRate);
    NSString * rollInOutPrompt = [NSString stringWithFormat:locationString(@"current_account_out_tips"), (long)promptAmonut];
    LTNPromptView * promptView = [LTNPromptView promptWithIcon:@"icon_note_small" iconSpace:6 Text:rollInOutPrompt font:kFont(12) textWidth:kScreenWidth - 2 * 24];
    promptView.left = 24;
    promptView.top = usableBalanceView.bottom + 24;
    [self addSubview:promptView];
    
    // 同意按钮
    self.agree = YES;
    LTNAgreeView * agreeView = nil;
    if (!_rollType) {
        agreeView = [[LTNAgreeView alloc] initWithTitle:locationString(@"current_account_title2") protocol:locationString(@"invest_agreement") fontSize:12 target:self];
        agreeView.centerX = kScreenWidth * 0.5;
        agreeView.top = promptView.bottom + kGeneralHeight * 0.5;
        [self addSubview:agreeView];
    }
    
    // 提交按钮
    CGFloat rollInOutButtonY = (_rollType ? promptView.bottom : agreeView.bottom) + kGeneralHeight * 0.5;
    NSString * rollInOutButtonTitle = _rollType ? locationString(@"current_account_out_btn") : locationString(@"current_account_in_btn");
    UIButton * rollInOutButton = [Utility createButtonWithTitle:rollInOutButtonTitle color:[UIColor whiteColor] font:kFont(20) block:^(UIButton *btn) {
        // 判断有效位数
        if (![self.amountTextField validDecimal]) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:locationString(@"money_error") message:locationString(@"amount_digits_error") delegate:nil cancelButtonTitle:locationString(@"know") otherButtonTitles:nil];
            [alert show];
            return;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(rollInOutView:submitButton:submitRequestWithAmount:)]) {
            [self.delegate rollInOutView:self submitButton:self.rollInOutButton  submitRequestWithAmount:[self.amountTextField.text doubleValue]];
        }
    }];
    [rollInOutButton setDisenableBackgroundColor:HexRGB(0xcccccc) enableBackgroundColor:HexRGB(0xf88800)];
    rollInOutButton.enabled = NO;
    rollInOutButton.left = 10;
    rollInOutButton.top = rollInOutButtonY;
    rollInOutButton.width = kScreenWidth - 2 * rollInOutButton.left;
    rollInOutButton.layer.cornerRadius = 5;
    rollInOutButton.layer.masksToBounds = YES;
    [self addSubview:rollInOutButton];
    self.rollInOutButton = rollInOutButton;
    
    // 添加通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didChange:) name:UITextFieldTextDidChangeNotification object:nil];
}


//#pragma mark 输入金额小数点后位数大于2位判读
//- (BOOL)validDecimal
//{
//    NSString * decimalPart = [[self.amountTextField.text componentsSeparatedByString:@"."] lastObject];
//    return decimalPart.length > 2 && [decimalPart integerValue] > 0 ? NO : YES;
//}

#pragma mark 通知代理
- (void)agreeViewWillShowProtocol
{
    DLog(@"显示详情");
    if (self.delegate && [self.delegate respondsToSelector:@selector(rollInOutViewWillShowInvestProtocol)]) {
        [self.delegate rollInOutViewWillShowInvestProtocol];
    }
}

- (void)agreeViewWillAgreeProtocol:(BOOL)agree
{
    self.agree = agree;
    [self changeButtonStatus];
}

#pragma mark 输入金额判断
- (void)didChange:(NSNotification *)notification
{
    double amount = [self.amountTextField.text doubleValue];
    if (!_rollType && self.amountTextField.text.length > 0 && amount < 1) {
        [LTNUtilsHelper boxShowWithMessage:locationString(@"current_acount_toast3")];
        self.amountTextField.text = @"";
    }
    [self changeButtonStatus];
}

- (void)changeButtonStatus
{
    if (self.agree && self.amountTextField.text.length > 0) {
        self.rollInOutButton.enabled = YES;
        return;
    }
    self.rollInOutButton.enabled = NO;
}

- (void)refreshUI
{
    if (!_rollType) {
        _dataLabel.text = [NSString stringWithFormat:@"¥%.2f", [CurrentUser mine].accountInfo.usableBalance];
        [_dataLabel sizeToFit];
        _dataLabel.height = kSingleViewHeight;
        _dataLabel.right = kScreenWidth - 24;
    }
}

//textField.text 输入之前的值         string 输入的字符
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        _isHaveDian = NO;
    }
    
    if (textField.text.length >= 10 && ![string isEqualToString:@""]) {
        [LTNUtilsHelper boxShowWithMessage:locationString(@"amount_form_error4")];
        textField.text = [textField.text substringWithRange:NSMakeRange(0, 10)];
        return NO;
    }
    
    if ([string length] > 0)
    {
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.')//数据格式正确
        {
            //首字母不能为0和小数点
            if([textField.text length] == 0){
//                if(single == '.'){
//                    [self alertView:@"亲，第一个数字不能为小数点"];
//                    [textField1.text stringByReplacingCharactersInRange:range withString:@""];
//                    return NO;
//                    
//                }
                if (single == '0') {
                    if (_rollType) {
                        return YES;
                    }
                    [LTNUtilsHelper boxShowWithMessage:locationString(@"amount_form_error2")];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            if (single == '.')
            {
                if(!_isHaveDian)//text中还没有小数点
                {
                    _isHaveDian=YES;
                    return YES;
                }else
                {
                    [LTNUtilsHelper boxShowWithMessage:locationString(@"amount_form_error5")];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            else
            {
                if (_isHaveDian)//存在小数点
                {
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    NSInteger tt = range.location - ran.location;
                    if (tt <= 2){
                        return YES;
                    }else{
                        [LTNUtilsHelper boxShowWithMessage:locationString(@"amount_form_error6")];
                        return NO;
                    }
                }
                else
                {
                    return YES;
                }
            }
        } else {//输入的数据格式不正确
            [LTNUtilsHelper boxShowWithMessage:locationString(@"amount_form_error3")];
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }  
    
}

@end
