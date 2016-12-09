//
//  LTNRollInController.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/1/20.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNRollInController.h"
#import "LTNRollInOutView.h"
#import "CustomizedBackWebViewController.h"
#import "LTNRollInSummaryViewController.h"

@interface LTNRollInController ()<LTNRollInOutViewDelegate, UIAlertViewDelegate>

{
    UIAlertView * _rechargeAlertView;//充值弹窗
    LTNRollInOutView * _rollInView;
    double _amount;
}

@end

@implementation LTNRollInController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    BOOL autoClick = [[[NSUserDefaults standardUserDefaults] valueForKey:kAutoClick] boolValue];
    if (autoClick) {
        [CurrentUser mine].userInfo.agreementTZ = YES;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAutoClick];
        [self gotoSummaryPage];
        return;
    }

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"needToRefreshAccountInfo"]) {
        [LTNServerHelper retrieveAccountInfoWithFinishBlock:^{
            [_rollInView refreshUI];
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = locationString(@"current_account_in_title");
    LTNRollInOutView * rollInView = [[LTNRollInOutView alloc] initWithType:RollIn currentDepositInfo:self.currentDepositInfo target:self];
    [self.view addSubview:rollInView];
    _rollInView = rollInView;
}

- (void)rollInOutViewWillShowInvestProtocol
{
    NSString * urlString = kH5AcceptCurrentUrl;
    BaseWebViewController * webController = [[BaseWebViewController alloc] initWithURL:urlString];
    webController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webController animated:YES];
}

- (void)rollInOutView:(LTNRollInOutView *)rollInOutView submitButton:(UIButton *)sumbitButton submitRequestWithAmount:(double)amount
{
    _amount = amount;
    // 输入金额大于可用余额
    if (amount > [CurrentUser mine].accountInfo.usableBalance) {
        _rechargeAlertView = [[UIAlertView alloc] initWithTitle:locationString(@"usable_balance_insufficient_title") message:locationString(@"usable_balance_insufficient_message") delegate:self cancelButtonTitle:locationString(@"cancel") otherButtonTitles:locationString(@"deposit"), nil];
        [_rechargeAlertView show];
        return;
    }
    
    if ([CurrentUser mine].userInfo.agreementTZ) {
        [self gotoSummaryPage];
        return;
    } else {
        NSDictionary *dict = @{@"agreement_type" : @"ZTBB0G00"};
        kWeakSelf
        [self apiForPath:kUserAgreeMianMiUrl method:kPostMethod parameter:dict responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
            if (!error) {
                //goto grant page
                BaseWebViewController *baseWebViewController = [[CustomizedBackWebViewController alloc] initWithURL:[data valueForKey:@"url"]];
                [weakSelf.navigationController pushViewController:baseWebViewController animated:YES];
            }
        }];
        return;
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView == _rechargeAlertView) {
        if (buttonIndex == 1)
        {
            [LTNCore rechargeViewController:^() {
                [LTNServerHelper retrieveAccountInfoWithFinishBlock:^(){
                    [_rollInView refreshUI];
                }];
            }];
        }
    }
}

//转入预览页
- (void)gotoSummaryPage {
    LTNRollInSummaryViewController *vc = [[LTNRollInSummaryViewController alloc] init];
    double incomeRate = [[self.currentDepositInfo.annual_income_rate componentsSeparatedByString:@"%"].firstObject doubleValue] / 100;
    double revenue = incomeRate * (_amount + self.currentDepositInfo.current_hold_amount) / 360;
    vc.params = [@{@"amount" : @(_amount), @"holdAmount" : @(self.currentDepositInfo.current_hold_amount + _amount), @"revenue" : @(revenue)} mutableCopy];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
