//
//  LTNRechargeSummaryViewController.m
//  lingtouniao
//
//  Created by peijingwu on 2/20/16.
//  Copyright © 2016 lingtouniao. All rights reserved.
//

#import "RechargeSummaryViewController.h"
#import "LTNSuccessView.h"
#import "RechargeViewController.h"
#import "InvestSummaryViewController.h"
#import "RechargeCell.h"
#import "RechargeModel.h"
#import "UIImageView+WebCache.h"


@interface RechargeSuccessViewController : BaseViewController


@end

@interface RechargeSummaryViewController () {
    UIButton *_submitButton;
    UIView *_views;
   RechargeModel *_viewModel;

   
}

@end

@implementation RechargeSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    self.tableView.scrollEnabled = NO;
    self.title = locationString(@"confirm_rechange");

    _viewModel = [[RechargeModel alloc]init];
   
    [self setFooterView];
    
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SwitchCell"];
//    cell.textLabel.text = self.data[indexPath.row][0];
//    cell.detailTextLabel.text = self.data[indexPath.row][1];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    return cell;
    
    static NSString *cellId = @"cell";
    RechargeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[RechargeCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSURL *url = [NSURL URLWithString:bankIcon(_viewModel.belongBank)];
    [cell.bankImg sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRetryFailed];
    
    cell.bankName.text = _viewModel.belongBank;
    cell.bankNum.text = [NSString stringWithFormat:locationString(@"last_number"),[StringUtil subStringFromString:_viewModel.bankNo]];
    cell.bankInstr.text = self.bankInstr;
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

//code is similar to that of RechargeViewController
-(void)setFooterView
{
    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_submitButton setTitle:locationString(@"btn_confirm_yes") forState:UIControlStateNormal];
    [_submitButton  setDisenableBackgroundColor:HexRGB(0xcccccc) enableBackgroundColor:HexRGB(kMainColor)];
    [_submitButton addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = 5;

    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
    [footView addSubview:_submitButton];
    [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footView).offset(15);
        make.right.equalTo(footView).offset(-15);
        make.top.equalTo(footView.mas_top).offset(155);
        make.height.mas_equalTo(@40);
    }];
    
    _views = [[UIView alloc]initWithFrame:CGRectMake(0, 12.5, kScreenWidth, 100)];
    _views.backgroundColor = [UIColor whiteColor];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    line1.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [_views addSubview:line1];
    
    UILabel *accountMoney = [Utility createLabel:[CustomerizedFont heiti:14] color:[UIColor colorWithHexString:@"#8a8a8a"]];
    accountMoney.frame = CGRectMake(15, 0, 100, 50);
    accountMoney.text = locationString(@"with_draw_balance4");
    [_views addSubview:accountMoney];
    
    UILabel *money = [Utility createLabel:[CustomerizedFont heiti:14] color:[UIColor colorWithHexString:@"#3a3a3a"]];
    money.frame = CGRectMake(120, 0, kScreenWidth - 140, 50);
    money.text = [NSString stringWithFormat:locationString(@"amount_yuan_decimal"),[CurrentUser mine].accountInfo.usableBalance];
    money.textAlignment = NSTextAlignmentRight;
    [_views addSubview:money];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 49, kScreenWidth, 1)];
    line2.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [_views addSubview:line2];
    
    UILabel *rechargeMoney = [Utility createLabel:[CustomerizedFont heiti:14] color:[UIColor colorWithHexString:@"#8a8a8a"]];
    rechargeMoney.frame = CGRectMake(15, line2.bottom, 100, 50);
    rechargeMoney.text = locationString(@"deposit_amount");
    [_views addSubview:rechargeMoney];
    
    UILabel *recharge = [Utility createLabel:[CustomerizedFont heiti:14] color:[UIColor colorWithHexString:@"#3a3a3a"]];
    recharge.frame = CGRectMake(120, line2.bottom, kScreenWidth - 140, 50);
    recharge.text = [NSString stringWithFormat:locationString(@"amount_yuan_decimal"),[_rechargeSum floatValue]];
    recharge.textAlignment = NSTextAlignmentRight;
    [_views addSubview:recharge];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 99, kScreenWidth, 1)];
    line3.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [_views addSubview:line3];
    
    [footView addSubview:_views];

    UILabel *descLabel = [[UILabel alloc] init];
    [footView addSubview:descLabel];
    descLabel.text = self.promptMsg;
    descLabel.font = [UIFont systemFontOfSize:12];
    descLabel.textColor = [UIColor grayColor];
    descLabel.numberOfLines = 0;
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footView).offset(30);
        make.right.equalTo(footView).offset(-15);
        make.top.equalTo(_submitButton.mas_bottom).offset(10);
    }];

    UIImageView *iconImageView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_tip"]];
    [footView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footView).offset(15);
        make.width.height.equalTo(@12);
        make.centerY.equalTo(descLabel.mas_top).offset(7);
    }];
    self.tableView.tableFooterView = footView;
}

- (void)submitClick:(UIButton *)btn {
    
    [TrackingUtility event:kMMCZClicked];
//    int section = 0;
//    int row = 2;
//  NSString *amount = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]].detailTextLabel.text;
  
    NSString *amount = _rechargeSum;

    NSDictionary *dict = @{@"orderAmount" : amount};
    btn.enabled = NO;
//    MBProgressHUD * progressHUD = [MBProgressHUD bwm_showHUDAddedToController:self title:nil animated:YES];
    [self showWaitingIcon];
    kWeakSelf
    [BaseDataEngine apiForPath:kUserRechargeUrl method:kPostMethod parameter:dict.mutableCopy responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        btn.enabled = YES;
        [weakSelf dismissWaitingIcon];
//        [progressHUD hide:YES];
        
        
        //TODO:订单号？？sever 需要返回
        
        if (!error) {
            //
            RechargeSuccessViewController *vc = [[RechargeSuccessViewController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
            
            NSArray *piwikArr=@[
                                @[@"order_no",@""],
                                @[@"result",@"1"],
                                @[@"reason",@""],
                                @[@"amt",esString(amount)],
                                @[@"datepoint",timeForStatistics()],
                                
                                     ];
            piwikEvent(@"recharge",piwikArr);

        }else{
            NSArray *piwikArr=@[
                                @[@"order_no",@""],
                                @[@"result",@"0"],
                                @[@"reason",esString(error.description)],
                                @[@"amt",esString(amount)],
                                @[@"datepoint",timeForStatistics()],
                              
                                     ];
            piwikEvent(@"recharge",piwikArr);
        }
    }];

}

@end




@implementation RechargeSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = locationString(@"deposit_success");
    [self setupUI];
}

- (void)setupUI
{
    LTNSuccessView * successView = [[LTNSuccessView alloc] initWithSuccessTitle:locationString(@"deposit_success") buttonTitle:locationString(@"deposit_success") actionBlock:^(UIButton *button) {
        [self back];
    }];
    [self.view addSubview:successView];
}

- (void)back
{
    [TrackingUtility event:kMMCZSuccess];
    //pc端和手机端可以同时登陆，在进行提现操作的时候先进行账户金额的刷新
    [LTNServerHelper retrieveAccountInfoWithFinishBlock:nil];
    [LTNServerHelper retrieveUserInfoWithFinishBlock:nil];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshAccountInfo];
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[InvestSummaryViewController class]]) {
            InvestSummaryViewController *investSummaryViewController = (InvestSummaryViewController *)viewController;
            
            [self.navigationController popToViewController:investSummaryViewController animated:YES];
            break;
        }
        if ([viewController isKindOfClass:[RechargeViewController class]]) {
            RechargeViewController *rechargeViewController = (RechargeViewController *)viewController;
            rechargeViewController.isCompleteAction = YES;
            [self.navigationController popToViewController:rechargeViewController animated:YES];
            break;
        }
    }

}

@end

