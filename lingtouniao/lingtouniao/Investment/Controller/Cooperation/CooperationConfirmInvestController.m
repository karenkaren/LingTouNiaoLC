//
//  CooperationConfirmInvestController.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/9/24.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "CooperationConfirmInvestController.h"
#import "CooperationHeaderView.h"
#import "CooperationInvestSummaryController.h"
#import "CooperationHeaderCell.h"

#define kChargeCell @"ChargeCell"
#define kCooperationCell @"CooperationCell"

@interface CooperationConfirmInvestController ()

@end

@implementation CooperationConfirmInvestController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"加入互助";
    CooperationHeaderView * tableHeaderView = [[CooperationHeaderView alloc] init];
    tableHeaderView.data = self.detailParams;
//    self.tableView.tableHeaderView = tableHeaderView;
}

- (void)setUpFooterView {
    
    [super setUpFooterView];
    [self.invest_agreement_Button setTitle:locationString(@"huiyuangongye_agreement") forState:UIControlStateNormal];
    
    
}

/**
 *  收益信托协议
 *
 */
- (IBAction)agreementClick:(id)sender {
    //TODO: use url from server side
    BaseWebViewController *baseWebViewController = [[BaseWebViewController alloc] initWithURL:kH5HuiyuanUrl];
    [self.navigationController pushViewController:baseWebViewController animated:YES];
    
}



- (void)setDetailParams:(NSDictionary *)detailParams
{
    _detailParams = detailParams;
    self.productId = [detailParams[@"productId"] integerValue];
    self.investAmount = [NSString stringWithFormat:@"%.2f", [detailParams[@"singleLimitAmount"] doubleValue]];
}

-(void)loadData
{
    [self showWaitingIcon];
    __weak typeof(self) weakself = self;
    __weak typeof(_tableView) weakTableView = _tableView;
    [self.submitOrderModel GET_cooperationBuyWithProductId:[NSString stringWithFormat:@"%ld",self.productId] andInvestAmount:self.investAmount Success:^(BOOL isSuccess) {
        if (isSuccess) {
            [weakself dismissWaitingIcon];
            [weakTableView reloadData];
        }
    } failure:^(NSString *error) {
        [weakself dismissWaitingIcon];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.submitOrderModel.orderPrepareModel.birdCoin == 0 ? 2 : 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        CooperationHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:kCooperationCell];
        if (cell == nil) {
            cell = [[CooperationHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCooperationCell];
            cell.data = self.detailParams;
        }
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kChargeCell];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kChargeCell];
            cell.selectionStyle = UITableViewCellEditingStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:15.0];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
        }
        
        if(indexPath.row == 1){
            cell.textLabel.text = locationString(@"purchase_money");
            cell.detailTextLabel.text = [NSString stringWithFormat:locationString(@"amount_yuan_text"),self.investAmount];
            
        }
        else if (indexPath.row == 2)
        {
            NSString * birdCoin = [NSString stringWithFormat:@"%.2f", self.submitOrderModel.orderPrepareModel.birdCoin];
            cell.textLabel.text =[NSString stringWithFormat:locationString(@"use_bird_money"),birdCoin,birdCoin];
            UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
            [switchview setOn:self.isSwitch animated:NO];
            [switchview addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchview;
        }
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row ? 49.0f : kCooperationHeaderHeight;
}

#pragma 订单支付跳转
-(void)payClick:(id)sender
{
    [self.view endEditing:YES];
    [self showWaitingIcon];
    if ([CurrentUser mine].userInfo.agreementTZ) {
        [self gotoSummaryPage];
    } else {
        NSDictionary *dict = @{@"agreement_type" : @"ZTBB0G00"};
        kWeakSelf
        _payButtonView.payButton.enabled = NO;
        [self apiForPath:kUserAgreeMianMiUrl method:kPostMethod parameter:dict responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
            _payButtonView.payButton.enabled = YES;
            [weakSelf dismissWaitingIcon];
            if (!error) {
                //goto grant page
                _payButtonView.payButton.enabled = YES;
                CustomizedBackWebViewController * baseWebViewController = [[CustomizedBackWebViewController alloc] initWithURL:[data valueForKey:@"url"]];
                [weakSelf.navigationController pushViewController:baseWebViewController animated:YES];
            }
        }];
    }
}

//购买预览页
- (void)gotoSummaryPage {
    [self dismissWaitingIcon];
    
    CooperationInvestSummaryController * vc = [[CooperationInvestSummaryController alloc] initOrderDataProductId:self.productId ProductExpireDate:self.submitOrderModel.orderPrepareModel.productExpireDate InvestAmount:[self.investAmount doubleValue] waitProfit:[self getWaitProfit] birdCoin:_coin couponDes:couponDes realPayAmout:self.realPayAmout userCouponId:userCouponId presentCode:[self selectPresentCode]];
    vc.detailParams = self.detailParams;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
