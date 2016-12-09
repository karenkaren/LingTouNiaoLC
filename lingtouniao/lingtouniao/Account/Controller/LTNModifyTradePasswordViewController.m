//
//  LTNModifyTradePasswordViewController.m
//  lingtouniao
//
//  Created by peijingwu on 12/30/15.
//  Copyright © 2015 lingtouniao. All rights reserved.
//

#import "LTNModifyTradePasswordViewController.h"
#import "ObjectManager.h"
#import "NSStringUtil.h"
#import "InputView.h"

@interface LTNModifyTradePasswordViewController ()

@property (nonatomic) UITextField *oldPasswod;
@property (nonatomic) UITextField *curPasswod;

@end

@implementation LTNModifyTradePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = locationString(@"modify_trade_password");
    
    InputView *inputV = [[InputView alloc] initWithStyle:InPutPageStlyeNormal];
    [self.view addSubview:inputV];
    
    _oldPasswod = inputV.usernameTextField;
    _curPasswod = inputV.passwordTextField;
    _curPasswod.keyboardType = _oldPasswod.keyboardType;
    _oldPasswod.secureTextEntry = YES;
    _curPasswod.secureTextEntry = YES;

    self.oldPasswod.placeholder = locationString(@"modify_trade_pwd_original");
    self.curPasswod.placeholder = locationString(@"modify_trade_pwd_new");
    
    UIButton *btn = inputV.commitBtn;
    [btn setTitle:self.title forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:COLOR_MAIN size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    btn.tappedBlock = ^(UIButton *btn) {
        [self modifyPasswd];
    };
    
    UILabel *label = [Utility createLabel:[CustomerizedFont heiti:14] color:kDisabledColor];
    label.numberOfLines = 0;
    label.text = locationString(@"modify_trade_pwd_tip");
    label.textColor = [UIColor blackColor];
    label.size = CGSizeMake(btn.width, 0);
    [label sizeToFit];
    label.left = kHorizontalMargin;
    label.top = btn.bottom + 20;
    [self.view addSubview:label];
}

- (void)modifyPasswd {
    NSArray *recipients = @[@"10690569687"];
    NSString *oldPasswd = safeEmpty(self.oldPasswod.text);
    NSString *curPasswd = safeEmpty(self.curPasswod.text);

    [[ObjectManager sharedInstance] sendSMSMsg:[NSString stringWithFormat:@"GGMM#%@#%@", safeEmpty(oldPasswd), safeEmpty(curPasswd)] recipients:recipients onVC:self];
}

@end
