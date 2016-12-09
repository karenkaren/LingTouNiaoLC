//
//  CrowdfundingInvestSummaryController.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/9/29.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "CrowdfundingInvestSummaryController.h"
#import "CrowdfundingSuccessController.h"

@interface CrowdfundingInvestSummaryController ()

@end

@implementation CrowdfundingInvestSummaryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认支付";
    if (self.isRealObject) {
        _titleArray = @[@[locationString(@"purchase_money"), locationString(@"object_award"), locationString(@"bird_coin_deduction"), locationString(@"used_coupon")],@[locationString(@"due_date"), locationString(@"actually_pay_money")]];
    } else {
        _titleArray = @[@[locationString(@"purchase_money"), locationString(@"toreceive_balance"), locationString(@"bird_coin_deduction"), locationString(@"used_coupon")],@[locationString(@"due_date"), locationString(@"actually_pay_money")]];
    }
}

- (void)confirmBuyProduct:(UIButton *)sender
{
    // 参数字典
    NSDictionary * parameters = @{
                                  @"productId" :[NSNumber numberWithInteger:_productId],
                                  @"orderAmount" : @(_investAmount),
                                  @"birdCoin" : [NSNumber numberWithDouble:_birdCoin],
                                  @"userCouponId" :[NSNumber numberWithLong:_userCouponId],
                                  @"stepId" : @(self.stepId)
                                  };
    
    sender.enabled = NO;
    kWeakSelf
    [self apiForPath:kProductZcOrderSubmitUrl method:kPostMethod parameter:parameters responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        sender.enabled = YES;
        kStrongSelf
        [strongSelf buyProducCompleteWithResponse:response data:data error:error];
    }];
}

- (void)gotoInvestSuccessWithGoldenEgg:(BOOL)hasGoldenEgg investAmount:(double)investAmount
{
    CrowdfundingSuccessController *vc = [[CrowdfundingSuccessController alloc] init];
    vc.investment = investAmount;
    vc.hasGoldenEgg = hasGoldenEgg;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
