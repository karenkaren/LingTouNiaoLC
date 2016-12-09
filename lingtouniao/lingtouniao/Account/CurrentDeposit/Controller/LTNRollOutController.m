//
//  LTNRollOutController.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/1/20.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNRollOutController.h"
#import "LTNRollInOutView.h"
#import "LTNRollOutSuccessController.h"

@interface LTNRollOutController ()<LTNRollInOutViewDelegate>

@end

@implementation LTNRollOutController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = locationString(@"current_account_out_title");
    LTNRollInOutView * rollOutView = [[LTNRollInOutView alloc] initWithType:RollOut currentDepositInfo:self.currentDepositInfo target:self];
    [self.view addSubview:rollOutView];
}

- (void)rollInOutView:(LTNRollInOutView *)rollInOutView submitButton:(UIButton *)sumbitButton submitRequestWithAmount:(double)amount
{
    DLog(@"转出%.2f", amount);
    if (amount > self.currentDepositInfo.current_hold_amount) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:locationString(@"roll_out_amount_error_title") message:locationString(@"current_acount_toast5") delegate:nil cancelButtonTitle:locationString(@"know") otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (amount <= 0) {
        [LTNUtilsHelper boxShowWithMessage:locationString(@"amount_type_error")];
        return;
    }
    
    NSMutableDictionary * dicM = [NSMutableDictionary dictionaryWithDictionary:@{@"order_amount" : @(amount)}];
    kWeakSelf
    sumbitButton.enabled = NO;
    [self apiForPath:kCurrentRollOutUrl method:kPostMethod parameter:dicM responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        sumbitButton.enabled = YES;
        if (!error) {
            LTNRollOutSuccessController * successController = [[LTNRollOutSuccessController alloc] init];
            [weakSelf.navigationController pushViewController:successController animated:YES];
        }
    }];
}


@end
