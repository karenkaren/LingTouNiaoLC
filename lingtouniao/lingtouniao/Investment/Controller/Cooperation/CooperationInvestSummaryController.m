//
//  CooperationInvestSummaryController.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/9/24.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "CooperationInvestSummaryController.h"
#import "CooperationHeaderCell.h"
#import "CooperationSuccessController.h"

NSString * const ChargeCell = @"ChargeCell";
NSString * const CooperationCell = @"CooperationCell";

@interface CooperationInvestSummaryController ()

@end

@implementation CooperationInvestSummaryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认支付";
    _titleArray = @[@[locationString(@"purchase_money"), locationString(@"bird_coin_deduction")], @[locationString(@"actually_pay_money")]];
}

#pragma - mark TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _birdCoin ? 3 : 2;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        CooperationHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:CooperationCell];
        if (cell == nil) {
            cell = [[CooperationHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CooperationCell];
            cell.data = self.detailParams;
        }
        return cell;
    }
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ChargeCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ChargeCell];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#3a3a3a"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0];
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#3a3a3a"];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = _titleArray[indexPath.section][indexPath.row - 1];
        if (indexPath.row == 1) {
            cell.detailTextLabel.text =[NSString stringWithFormat:locationString(@"amount_yuan_decimal"),_investAmount];
        }
        else if (indexPath.row == 2)
        {
            if (_birdCoin > 0 ) {
                // 已用鸟币
                cell.detailTextLabel.text = [NSString stringWithFormat:locationString(@"amount_niaobi_decimal"),_birdCoin];
            } else {
                cell.textLabel.text = _titleArray[indexPath.row];
                cell.detailTextLabel.text = [NSString stringWithFormat:locationString(@"amount_yuan_decimal"),_realPayAmout];
            }
        }
    } else {
        cell.textLabel.text = _titleArray[indexPath.section][indexPath.row];
        cell.detailTextLabel.text = [NSString stringWithFormat:locationString(@"amount_yuan_decimal"),_realPayAmout];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section == 0 && indexPath.row == 0) ? kCooperationHeaderHeight : 49.0f;
}

- (void)confirmBuyProduct:(UIButton *)sender
{
    // 参数字典
    NSDictionary * parameters = @{
                                  @"productId" :[NSNumber numberWithInteger:_productId],
                                  @"orderAmount" : @(_investAmount),
                                  @"birdCoin" : [NSNumber numberWithDouble:_birdCoin],
                                  @"userCouponId" :[NSNumber numberWithLong:_userCouponId]
                                  };
    
    sender.enabled = NO;
    kWeakSelf
    [self apiForPath:kUserOrderconfirmUrl method:kPostMethod parameter:parameters responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        sender.enabled = YES;
        kStrongSelf
        [strongSelf buyProducCompleteWithResponse:response data:data error:error];
    }];
}

- (void)gotoInvestSuccessWithGoldenEgg:(BOOL)hasGoldenEgg investAmount:(double)investAmount
{
    CooperationSuccessController *vc = [[CooperationSuccessController alloc] init];
    vc.investment = investAmount;
    vc.hasGoldenEgg = hasGoldenEgg;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
