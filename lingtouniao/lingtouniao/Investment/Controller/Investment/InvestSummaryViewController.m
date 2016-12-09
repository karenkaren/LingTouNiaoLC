//
//  InvestSummaryViewController.m
//  lingtouniao
//
//  Created by 徐凯 on 16/2/22.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "InvestSummaryViewController.h"
//#import "LTNSuccessView.h"
#import "LTNTabBarController.h"
#import "LTNBaseDetailController.h"
//#import "GoldenEggsViewController.h"
#import "RechargeViewController.h"
#import "InvestSuccessViewController.h"

@interface InvestSummaryViewController ()<UITableViewDataSource,UITableViewDelegate>
//{
//    NSArray *_titleArray;
//    UITableView *_tableView;
//    UIButton *_confirmButton;//确认
//    UIView *_footView;
//    NSInteger _productId;//产品id
//    NSString *_productExpireDate;//产品到期时间
//    float _investAmount;//投资金额
//    NSString *_waitProfit;//待收收益
//    double _birdCoin;//鸟币
//    NSString *_couponDes;//优惠券描述
//    double _realPayAmout;//实付金额
//    long _userCouponId;
//   
//    
//    
//
//}

@end

@implementation InvestSummaryViewController

-(id)initOrderDataProductId:(NSInteger)productId ProductExpireDate:(NSString *)productExpireDate InvestAmount:(float)investAmount waitProfit:(NSString *)waitProfit birdCoin:(double)birdCoin couponDes:(NSString *)couponDes realPayAmout:(double)realPayAmout userCouponId:(long)userCouponId presentCode:(NSString *)presentCode

{
    self = [super init];
    if (self) {
        _productId = productId;
        _productExpireDate = productExpireDate;
        _investAmount = investAmount;
        _waitProfit = waitProfit;
        _birdCoin = birdCoin;
        _couponDes = couponDes;
        _realPayAmout = realPayAmout;
        _userCouponId = userCouponId;
        _presentCode=presentCode;
    }
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _titleArray = @[@[locationString(@"purchase_money"), locationString(@"toreceive_balance"), locationString(@"bird_coin_deduction"), locationString(@"used_coupon")],@[locationString(@"due_date"), locationString(@"actually_pay_money")]];
}

-(void)initUIView
{
    self.title = locationString(@"confirm_buy");
    [self setconfirmButton];
    [self setFooterView];
    [self setTableView];
}

-(void)setFooterView
{
    _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 260)];
    [_footView addSubview:_confirmButton];
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_footView).offset(20);
        make.right.equalTo(_footView).offset(-20);
        make.top.equalTo(_footView.mas_top).offset(30);
        make.height.mas_equalTo(@40);
    }];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"e2e2e2"];
    [_footView addSubview:lineView];
    
}

-(void)setTableView
{
    CGFloat navibarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat tabbarHeight = self.navigationController.tabBarController.tabBar.frame.size.height;
    CGFloat statusHeight = [[UIApplication sharedApplication]statusBarFrame].size.height;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - navibarHeight - tabbarHeight - statusHeight)style:UITableViewStylePlain];
    _tableView.backgroundColor = BACKGROUND_COLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = _footView;
    [self.view addSubview:_tableView];
}

-(void)setconfirmButton
{
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmButton setTitle:locationString(@"btn_confirm_yes") forState:UIControlStateNormal];
    [_confirmButton setDisenableBackgroundColor:kDisabledColor enableBackgroundColor:COLOR_MAIN];
    [_confirmButton addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
    _confirmButton.layer.masksToBounds = YES;
    _confirmButton.layer.cornerRadius = 5;
}


#pragma - mark TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if (_birdCoin > 0 || _couponDes) {
//        return 2;
//    }
//    return 1;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
//            return 4;
            return [self numberOfRows];
            break;
        case 1:
//            return [self numberOfRows];
            return 2;
            break;
        default:
            return 0;
            break;
    }
}

-(NSInteger)numberOfRows
{
    if (_birdCoin > 0 && _couponDes) {
        return 4;
    }
    else if (_birdCoin > 0 || _couponDes) {
        return 3;
    }
    else
    {
        return 2;
    }

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   return 20.0f;

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [TableViewDevider getHeaderViewWithHeight:20 showTopLine:YES showBottomLine:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self buildCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)buildCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ChargeCell = @"ChargeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChargeCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ChargeCell];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#3a3a3a"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0];
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#3a3a3a"];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = _titleArray[indexPath.section][indexPath.row];
        if (indexPath.row == 0) {
            cell.detailTextLabel.text =[NSString stringWithFormat:locationString(@"amount_yuan_decimal"),_investAmount];
        }
        else if (indexPath.row == 1)
        {
            cell.detailTextLabel.text = _waitProfit;
        }
        
        else if (indexPath.row == 2)
        {
            // 实付金额
            //            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f元",_realPayAmout];
            if (_birdCoin > 0 ) {
                // 已用鸟币
                cell.textLabel.text = _titleArray[indexPath.section][indexPath.row];
                cell.detailTextLabel.text = [NSString stringWithFormat:locationString(@"amount_niaobi_decimal"),_birdCoin];
            } else if (_couponDes) {
                // 已使用理财金券
                cell.textLabel.text = _titleArray[indexPath.section][indexPath.row + 1];
                cell.detailTextLabel.text = _couponDes;
            }
        }
        else if (indexPath.row == 3)
        {
            // 已使用理财金券
            cell.textLabel.text = _titleArray[indexPath.section][indexPath.row];
            cell.detailTextLabel.text = _couponDes;
            // 到期日期
            //            cell.detailTextLabel.text = _productExpireDate;
        }
    }
    else if (indexPath.section == 1)
    {
        cell.textLabel.text = _titleArray[indexPath.section][indexPath.row];
        if (indexPath.row == 0)
        {
            // 到期日期
            cell.detailTextLabel.text = _productExpireDate;
            //            if (_birdCoin > 0 ) {
            //                cell.textLabel.text = _titleArray[indexPath.section][indexPath.row];
            //                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f鸟币",_birdCoin];
            //            }else if (_couponDes)
            //            {
            //            cell.textLabel.text = _titleArray[indexPath.section][indexPath.row + 1];
            //                cell.detailTextLabel.text = _couponDes;
            //            }
            
        } else if (indexPath.row == 1) {
            // 实付金额
            cell.detailTextLabel.text = [NSString stringWithFormat:locationString(@"amount_yuan_decimal"),_realPayAmout];
            //            // 已使用理财金券
            //            cell.textLabel.text = _titleArray[indexPath.section][indexPath.row];
            //            cell.detailTextLabel.text = _couponDes;
        }
    }
    return cell;
}

/**
 *  确认投资
 */

-(void)confirmClick:(UIButton *)sender
{
    [TrackingUtility event:kTZClicked];
    
    //TODO:添加余额不足条件，还未测试
    if (_realPayAmout > [CurrentUser mine].accountInfo.usableBalance&& (_realPayAmout - [CurrentUser mine].accountInfo.usableBalance>0.001)) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:locationString(@"product_buy_dialog2_content"),[CurrentUser mine].accountInfo.usableBalance,_realPayAmout - [CurrentUser mine].accountInfo.usableBalance] delegate:self cancelButtonTitle:locationString(@"btn_cancel") otherButtonTitles:locationString(@"deposit"), nil];
        [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                
                if (![CurrentUser bindedBankCard]){
                    [LTNCore boundBankCardViewController:^{
                        if ([CurrentUser bindedBankCard]) {
                            [self gotoRecharge];
                        }
                    }];
                }else{
                    [self gotoRecharge];
                }
            }
        }];
        return;
    }
    [self confirmBuyProduct:sender];
}

// 跳转至充值界面
- (void)gotoRecharge
{
    RechargeViewController *rechargeViewController = [[RechargeViewController alloc]initWithRechargeMoney:_realPayAmout - [CurrentUser mine].accountInfo.usableBalance];
    [self.navigationController pushViewController:rechargeViewController animated:YES];
}

- (void)confirmBuyProduct:(UIButton *)sender
{
    // 参数字典
    NSDictionary * parameters = @{
                                  @"productId" :[NSNumber numberWithInteger:_productId],
                                  @"orderAmount" : @(_investAmount),
                                  @"birdCoin" : [NSNumber numberWithDouble:_birdCoin],
                                  @"userCouponId" :[NSNumber numberWithLong:_userCouponId],
                                  @"presentCode":esString(_presentCode)
                                  };
    
    sender.enabled = NO;
    kWeakSelf
    [self apiForPath:kBuyProductConfirmUrl method:kPostMethod parameter:parameters responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        sender.enabled = YES;
        kStrongSelf
        [strongSelf buyProducCompleteWithResponse:response data:data error:error];
    }];
}

- (void)buyProducCompleteWithResponse:(id)response data:(id)data error:(NSError *)error
{
    if (!error) {
        // 投资成功，列表页、首页需要刷新
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshInvestPage];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshHomePage];
        // 添加通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kNeedToRefreshProducts object:nil];
        [LTNServerHelper retrieveAccountInfoWithFinishBlock:nil];
        
//        InvestSuccessViewController *vc = [[InvestSuccessViewController alloc] init];
//        vc.investment = _investAmount;
//        vc.hasGoldenEgg = esBool(data[@"hasGoldenEgg"]);
//        [self.navigationController pushViewController:vc animated:YES];
        [self gotoInvestSuccessWithGoldenEgg:esBool(data[@"hasGoldenEgg"]) investAmount:_investAmount];
        
        NSArray *piwikArr=@[
                                @[@"bid_id",esString(@(_productId))],
                                @[@"result",@"1"],
                                @[@"reason",@""],
                                @[@"amt",esString(@(_investAmount))],
                                @[@"datepoint",timeForStatistics()],
                                          
                                 ];
        piwikEvent(@"invest",piwikArr);
    }else{
        
        NSArray *piwikArr=@[
                                @[@"bid_id",esString(@(_productId))],
                                @[@"result",@"0"],
                                @[@"reason",esString(error.description)],
                                @[@"amt",esString(@(_investAmount))],
                                @[@"datepoint",timeForStatistics()],
                                
                                
                                 ];
        piwikEvent(@"invest",piwikArr);
    }
}

- (void)gotoInvestSuccessWithGoldenEgg:(BOOL)hasGoldenEgg investAmount:(double)investAmount
{
    InvestSuccessViewController *vc = [[InvestSuccessViewController alloc] init];
    vc.investment = investAmount;
    vc.hasGoldenEgg = hasGoldenEgg;
    [self.navigationController pushViewController:vc animated:YES];
}

@end


//@implementation InvestSuccessViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.title = locationString(@"invest_success");
//    [self setupUI];
//
//}
//
//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    if (_hasGoldenEgg) {
//        [self startShowGoldenEggs];
//    }
//    
//
//}
//- (void)back
//{
//    [TrackingUtility event:kTZSuccess];
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}
//
//
//- (void)setupUI
//{
//    kWeakSelf;
//    LTNSuccessView * successView = [[LTNSuccessView alloc] initWithSuccessTitle:locationString(@"invest_success") buttonTitle:locationString(@"invest_complete") actionBlock:^(UIButton *button) {
//        
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshInvestPage];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshHomePage];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshAccountInfo];
//        [weakSelf back];
//        
//        
//            }];
//    [self.view addSubview:successView];
//}
//
///**
// *  显示砸金蛋界面
// */
//-(void)startShowGoldenEggs
//{
//    
//    UIWindow *keyWindow = [[[UIApplication sharedApplication]delegate]window];
//    
//    GoldenEggsViewController *goldenEggsViewController = [[GoldenEggsViewController alloc]init];
//    goldenEggsViewController.goldenEggsWindow = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    goldenEggsViewController.goldenEggsWindow.bottom = 0;
//    UINavigationController *navGoldenEggsViewController = [[UINavigationController alloc]initWithRootViewController:goldenEggsViewController];
//    goldenEggsViewController.goldenEggsWindow.rootViewController = navGoldenEggsViewController;
//    [keyWindow addSubview:goldenEggsViewController.goldenEggsWindow];
//    [UIView animateWithDuration:0.5 animations:^{
//        goldenEggsViewController.goldenEggsWindow.top = 0;
//    }];
//    [goldenEggsViewController.goldenEggsWindow setWindowLevel:UIWindowLevelAlert];
//    [goldenEggsViewController.goldenEggsWindow makeKeyAndVisible];
//     __weak typeof(self) weakSelf = self;
//     __weak typeof(goldenEggsViewController) weakGoldenEggsViewController = goldenEggsViewController;
//    [goldenEggsViewController setInvestCallBack:^{
//        weakGoldenEggsViewController.goldenEggsWindow.hidden = YES;
//        [weakSelf.navigationController popToRootViewControllerAnimated:NO];
//        [LTNCore globleCore].tabbarController=[[LTNTabBarController alloc] init];
//        [[LTNCore mainWindow]  setRootViewController:[LTNCore globleCore].tabbarController];
//
//    }];
//    
//}
//
//
//@end
