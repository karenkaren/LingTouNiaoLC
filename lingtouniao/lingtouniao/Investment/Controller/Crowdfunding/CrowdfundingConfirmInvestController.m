//
//  CrowdfundingConfirmInvestController.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/9/29.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "CrowdfundingConfirmInvestController.h"
#import "CrowdfundingInvestSummaryController.h"
#import "SGActionView.h"

@interface CrowdfundingConfirmInvestController ()

// 众筹档位
@property (nonatomic, assign) NSInteger stepId;
// 众筹类型
@property (nonatomic, copy) NSString * productType;

@end

@implementation CrowdfundingConfirmInvestController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"加入众筹";
    
    
    
}

- (void)setDetailParams:(NSDictionary *)detailParams
{
    _detailParams = detailParams;
    self.stepId = [detailParams[@"stepId"] integerValue];
    self.productType = [detailParams[@"productType"] uppercaseString];
    self.productId = [detailParams[@"productId"] integerValue];
    self.investAmount = [NSString stringWithFormat:@"%.2f", [self.detailParams[@"amount"] doubleValue]];
    
    self.useBirdCoinTag=esBool(self.detailParams[@"useBridcoinTag"]);
    self.useCouponTag=esBool(self.detailParams[@"useCouponTag"]);
}

-(void)loadData
{
    [self showWaitingIcon];
    __weak typeof(self) weakself = self;
    __weak typeof(_tableView) weakTableView = _tableView;
    [self.submitOrderModel GET_crowdfingBuyWithProductId:[NSString stringWithFormat:@"%ld",self.productId] andInvestAmount:self.investAmount stepId:self.stepId Success:^(BOOL isSuccess) {
        if (isSuccess) {
            
            __strong typeof(self) strongSelf =weakself;
            if(strongSelf){
            [strongSelf dismissWaitingIcon];
            [strongSelf.coupounArray removeAllObjects];
            [strongSelf.coupounArray addObjectsFromArray:strongSelf.submitOrderModel.coupounArray];
            [weakTableView reloadData];
            }
        }
    } failure:^(NSString *error) {
        [weakself dismissWaitingIcon];
    }];
}


/**
 *  选择其他理财金券
 *
 *  @param button <#button description#>
 */
-(void)otherCouponClick:(UIButton *)button
{
    
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:self.coupounArray.count];
    NSMutableArray *descArray = [NSMutableArray arrayWithCapacity:self.coupounArray.count];
    NSMutableArray *itemSubTitlesArray = [NSMutableArray arrayWithCapacity:self.coupounArray.count];
    for (FinanciaCouponModel  *financiaCouponModel in self.coupounArray) {
        [itemArray addObject:[NSString stringWithFormat:@"%@", financiaCouponModel.couponName]];
        [descArray addObject:[NSString stringWithFormat:@"%@", financiaCouponModel.desc]];
        [itemSubTitlesArray addObject:[NSString stringWithFormat:locationString(@"choose_coupon_title"),financiaCouponModel.couponDate]];
    }
    
    NSString *actionViewTitle;
    if(self.coupounArray.count>0){
        actionViewTitle=locationString(@"choose_other_coupon");
    }else{
        actionViewTitle=locationString(@"have_coupon_code");
    }
    [SGActionView showSheetWithTitle:actionViewTitle
                          itemTitles:itemArray
                          descTitles:descArray
                       itemSubTitles:itemSubTitlesArray
                       selectedIndex:_selectedIndex
                  isShowExchangeView:NO
                      selectedHandle:nil
     ];
    
    
    
}







-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.coupounArray.count== 0 ? 1:2;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellId = [NSString stringWithFormat:@"section_%ld",(long)indexPath.section];
    
    if (indexPath.section == 0 ) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
            cell.selectionStyle = UITableViewCellEditingStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:15.0];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
        }
        
        if(indexPath.row == 0){
            cell.textLabel.text = locationString(@"amount_should_pay");
            cell.detailTextLabel.text = [NSString stringWithFormat:locationString(@"amount_yuan_text"),self.investAmount];
        }
        else if (indexPath.row == 1)
        {
            NSString * award = nil;
            if ([self.submitOrderModel.orderPrepareModel.productType isEqualToString:@"A"]) {
                cell.textLabel.text = locationString(@"object_award");
                award = (self.submitOrderModel.orderPrepareModel.stepAward && ![self.submitOrderModel.orderPrepareModel.stepAward isEqualToString:@""]) ? self.submitOrderModel.orderPrepareModel.stepAward : @"--";
            } else {
                cell.textLabel.text = locationString(@"toreceive_balance");
                award = self.submitOrderModel.orderPrepareModel.revenue ? [NSString stringWithFormat:@"%.2f元", self.submitOrderModel.orderPrepareModel.revenue] : @"--";
            }
            
            if([self selectCoupon]) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@＋%.2f元",award,[self revenueAndAdditional]];
            }else
            {
                if (self.submitOrderModel.orderPrepareModel.stepAward && ![self.submitOrderModel.orderPrepareModel.stepAward isEqualToString:@""]) {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.submitOrderModel.orderPrepareModel.stepAward];
                } else {
                    cell.detailTextLabel.text = award;
                }
            }
        }
        else if (indexPath.row == 2)
        {
            cell.textLabel.text = locationString(@"due_date");
            NSString * expireDate = (self.submitOrderModel.orderPrepareModel.productExpireDate && ![self.submitOrderModel.orderPrepareModel.productExpireDate isEqualToString:@""]) ? self.submitOrderModel.orderPrepareModel.productExpireDate : @"--";
            cell.detailTextLabel.text = expireDate;
        }
        else if (indexPath.row == 3)
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
    else if (indexPath.section == 1)
    {
        CouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CouponTableViewCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (_otherCouponIdSelectedIndex<0) {
                //未点击其他理财金券或者击额没有选择
                //众筹理财金圈需要测试啊
                cell.financiaCouponModel = self.coupounArray[indexPath.row];
                
                UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:(_selectedIndex==indexPath.row) ? @"icon_selected" : @"icon_choice"]];
                imageView.frame = CGRectMake(0, 0, 22, 22);
                cell.accessoryView = imageView;
            }else
            {
                //点击其他理财金券
                cell.financiaCouponModel = self.coupounArray[_otherCouponIdSelectedIndex];
                UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:_selectedIndex>=0 ? @"icon_selected": @"icon_choice"]];
                imageView.frame = CGRectMake(0, 0, 22, 22);
                cell.accessoryView = imageView;
            }
        }
        return cell;
    }
    return nil;
}

//购买预览页
- (void)gotoSummaryPage {
    [self dismissWaitingIcon];
    CrowdfundingInvestSummaryController * vc = [[CrowdfundingInvestSummaryController alloc] initOrderDataProductId:self.productId ProductExpireDate:self.submitOrderModel.orderPrepareModel.productExpireDate InvestAmount:[self.investAmount doubleValue] waitProfit:[self getWaitProfit] birdCoin:_coin couponDes:couponDes realPayAmout:self.realPayAmout userCouponId:userCouponId presentCode:[self selectPresentCode]];
    vc.stepId = self.stepId;
    if ([self.productType isEqualToString:@"A"]) {
        vc.isRealObject = YES;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *
 *  @return 传到确认投资界面的最终字符串的样子
 */
- (NSString *)getWaitProfit
{
    NSString *waitProfit;
    NSString * incomeSelf = nil;
    if (self.stepId) {
        if (self.submitOrderModel.orderPrepareModel.stepAward && ![self.submitOrderModel.orderPrepareModel.stepAward isEqualToString:@""]) {
            incomeSelf = self.submitOrderModel.orderPrepareModel.stepAward;
        } else {
            incomeSelf = @"--";
        }
        
    } else {
        if (self.submitOrderModel.orderPrepareModel.revenue) {
            incomeSelf = [NSString stringWithFormat:@"%.2f元", self.submitOrderModel.orderPrepareModel.revenue];
        } else {
            incomeSelf = @"--";
        }
    }
    if([self selectCoupon]) {
        waitProfit = [NSString stringWithFormat:@"%@＋%.2f元", incomeSelf,[self revenueAndAdditional]];
    }else
    {
        waitProfit = incomeSelf;
    }
    return waitProfit;
}

@end
