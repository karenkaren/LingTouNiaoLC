//
//  LTNSuccessView.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/2/22.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNSuccessView.h"
#import "LTNPromptView.h"

@interface LTNSuccessView ()
{
    UIButton * _successButton;
    UIButton * _investButton;
    UIButton * _shareButton;
    UIButton * _inviteButton;
    
    ButtonActionBlock _clickButtonBlock;
    ButtonInvestBlock _clickGoInvestBlock;
    ButtonShareBlock _clickShareBlock;
    ButtonInviteBlock _clickInviteBlock;
}

@end

@implementation LTNSuccessView

- (instancetype)initWithSuccessTitle:(NSString *)successTitle buttonTitle:(NSString *)buttonTitle actionBlock:(ButtonActionBlock)actionBlock
{
    self = [super initWithFrame:[UIScreen mainScreen].applicationFrame];
    if (self) {
        _clickButtonBlock = actionBlock;
        [self setupUIWithSuccessTitle:successTitle buttonTitle:buttonTitle];
    }
    return self;
}

- (void)setupUIWithSuccessTitle:(NSString *)successTitle buttonTitle:(NSString *)buttonTitle
{
    // 成功图片
    UIImageView * successImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_success"]];
    successImageView.top = 80;
    successImageView.centerX = kScreenWidth * 0.5;
    [self addSubview:successImageView];
    
    // 成功label
    UILabel * successLabel = [Utility createLabel:[CustomerizedFont boldHeiti:18] color:HexRGB(0x3e3e3e)];
    successLabel.text = successTitle;
    [successLabel sizeToFit];
    successLabel.top = successImageView.bottom + 16;
    successLabel.centerX = kScreenWidth * 0.5;
    [self addSubview:successLabel];
    
    // 跳转按钮
    UIButton * successButton = [Utility createButtonWithTitle:buttonTitle color:HexRGB(0xffffff) font:[CustomerizedFont heiti:20] block:^(UIButton *btn) {
        if (_clickButtonBlock) {
            _clickButtonBlock(successButton);
        }
    }];
    successButton.backgroundColor = HexRGB(0xea5504);
    successButton.layer.cornerRadius = 5;
    successButton.layer.masksToBounds = YES;
    successButton.left = 22;
    successButton.width = kScreenWidth - successButton.left * 2;
    successButton.top = successLabel.bottom + kGeneralHeight * 0.5;
    [self addSubview:successButton];
    _successButton = successButton;

}

- (instancetype)initWithSuccessTitle:(NSString *)successTitle buttonTitle:(NSString *)buttonTitle  buttonInvestTitle:(NSString *)investTitle buttonShareTitle:(NSString *)shareTitle buttonInviteTitle:(NSString *)inviteTitle actionBlock:(ButtonActionBlock)actionBlock investBlock:(ButtonInvestBlock)investBlock shareBlock:(ButtonShareBlock)shareBlock inviteBlock:(ButtonInviteBlock)inviteBlock
{
    self = [super initWithFrame:[UIScreen mainScreen].applicationFrame];
    if (self) {
        _clickButtonBlock = actionBlock;
        _clickGoInvestBlock = investBlock;
        _clickShareBlock = shareBlock;
        _clickInviteBlock = inviteBlock;
        [self setupUIWithSuccessTitle:successTitle buttonTitle:buttonTitle buttonInvestTitle:investTitle buttonShareTitle:shareTitle buttonInviteTitle:(NSString *)inviteTitle];
    }
    return self;
}

- (void)setupUIWithSuccessTitle:(NSString *)successTitle buttonTitle:(NSString *)buttonTitle buttonInvestTitle:(NSString *)investTitle buttonShareTitle:(NSString *)shareTitle buttonInviteTitle:(NSString *)inviteTitle
{
    // 成功图片
    UIImageView * successImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_success"]];
    successImageView.top = 80;
    successImageView.centerX = kScreenWidth * 0.5;
    [self addSubview:successImageView];
    
    // 成功label
    UILabel * successLabel = [Utility createLabel:[CustomerizedFont boldHeiti:18] color:HexRGB(0x3e3e3e)];
    successLabel.text = successTitle;
    [successLabel sizeToFit];
    successLabel.top = successImageView.bottom + 16;
    successLabel.centerX = kScreenWidth * 0.5;
    [self addSubview:successLabel];
    
    
    //继续投资
    UIButton * investButton = [Utility createButtonWithTitle:investTitle color:HexRGB(0xffffff) font:[CustomerizedFont heiti:20] block:^(UIButton *btn) {
        if (_clickGoInvestBlock) {
            _clickGoInvestBlock(investButton);
        }
    }];
    investButton.layer.borderWidth =0.5;
    investButton.layer.borderColor = [UIColor colorWithHexString:@"#ea5504"].CGColor;
    investButton.layer.cornerRadius = 5;
    investButton.clipsToBounds =YES;
    [investButton setTitleColor:[UIColor colorWithHexString:@"#ea5504"] forState:UIControlStateNormal];
    investButton.left = 22;
    investButton.width = (kScreenWidth - investButton.left * 2 - 15)/2;
    investButton.top = successLabel.bottom + kGeneralHeight + 18;
    [self addSubview:investButton];
    _investButton = investButton;
    
    // 返回按钮
    UIButton * successButton = [Utility createButtonWithTitle:buttonTitle color:HexRGB(0xffffff) font:[CustomerizedFont heiti:20] block:^(UIButton *btn) {
        if (_clickButtonBlock) {
            _clickButtonBlock(successButton);
        }
    }];
    successButton.layer.borderWidth =0.5;
    successButton.layer.borderColor = [UIColor colorWithHexString:@"#ea5504"].CGColor;
    successButton.layer.cornerRadius = 5;
    successButton.clipsToBounds =YES;
    [successButton setTitleColor:[UIColor colorWithHexString:@"#ea5504"] forState:UIControlStateNormal];
    successButton.left = investButton.right + 15;
    successButton.width = (kScreenWidth - investButton.left * 2 - 15)/2;
    successButton.top = successLabel.bottom +  kGeneralHeight + 18;
   
    [self addSubview:successButton];
    _successButton = successButton;
    
    //邀请好友投资 分享
    UIButton * shareButton = [Utility createButtonWithTitle:shareTitle color:HexRGB(0xffffff) font:[CustomerizedFont heiti:20] block:^(UIButton *btn) {
        if (_clickShareBlock) {
            _clickShareBlock(shareButton);
        }
    }];
    shareButton.backgroundColor = [UIColor colorWithHexString:@"#ea5504"];
    shareButton.layer.cornerRadius = 5;
    shareButton.layer.masksToBounds = YES;
    shareButton.left = 22;
    shareButton.width = kScreenWidth - shareButton.left * 2;
    shareButton.top = investButton.bottom + kGeneralHeight * 0.5;
    [self addSubview:shareButton];
    _shareButton = shareButton;

    
    //邀请好友合伙人
    UIButton *inviteButton = [Utility createButtonWithTitle:inviteTitle color:[UIColor colorWithHexString:@"#4a90e2"] font:[CustomerizedFont heiti:14] block:^(UIButton *btn) {
        if (_clickInviteBlock) {
            _clickInviteBlock(inviteButton);
        }
    }];
    inviteButton.top =shareButton.bottom + 10;
    inviteButton.left = (kScreenWidth - 195)*0.5;
    inviteButton.width = 195;
    [self addSubview:inviteButton];
    _investButton = inviteButton;
    
    UIView *line = [[UIView alloc]init];
    line.left = inviteButton.left +5;
    line.width = inviteButton.width -10;
    line.top = inviteButton.bottom -5;
    line.height = 0.5;
    line.backgroundColor = [UIColor colorWithHexString:@"#4a90e2"];
    [self addSubview:line];
    
    
    
}

#pragma mark setter方法
- (void)setPrompt:(NSString *)prompt
{
    _prompt = prompt;
    if (prompt && ![prompt isEqualToString:@""]) {
        // 提示
        CGFloat promptMargin = 29;
        LTNPromptView * promptView = [LTNPromptView promptWithIcon:@"icon_note_small" iconSpace:6 Text:prompt font:kFont(12) textWidth:kScreenWidth - 2 * promptMargin];
        promptView.left = promptMargin;
        promptView.top = _successButton.bottom + kGeneralHeight * 0.5;
        [self addSubview:promptView];
    }
}

- (void)setButtonBackgroundColor:(UIColor *)buttonBackgroundColor
{
    _buttonBackgroundColor = buttonBackgroundColor;
    if (buttonBackgroundColor) {
        [_successButton setBackgroundColor:buttonBackgroundColor];
    }
}

- (void)setButtonTitleColor:(UIColor *)buttonTitleColor
{
    _buttonTitleColor = buttonTitleColor;
    if (buttonTitleColor) {
        [_successButton setTitleColor:buttonTitleColor forState:UIControlStateNormal];
    }
}

@end
