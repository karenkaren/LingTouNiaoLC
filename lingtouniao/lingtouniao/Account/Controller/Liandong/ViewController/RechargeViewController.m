//
//  RechargeViewController.m
//  lingtouniao
//
//  Created by 徐凯 on 15/12/24.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "RechargeViewController.h"
#import "BaseWebViewController.h"
#import "RechargeModel.h"
#import "PromptView.h"
#import "RechargeTextField.h"
#import "CustomizedBackWebViewController.h"
#import "NSStringUtil.h"
#import "RechargeSummaryViewController.h"
#import "SXMarquee.h"
#import "RechargeCell.h"
#import "LTNExplainFreeCodeView.h"
#import "UIImageView+WebCache.h"





@interface RechargeViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *_tableView;
    NSArray *_titleArray;
    UIButton *_submitButton;//提交按钮
    RechargeModel *_viewModel;
    RechargeTextField *_amountField;//输入提现金额
    UIView *_footView;
    UILabel *_descLabel;//提现说明
    UIImageView *_iconImageView;//说明图标
    LimitMountModel *_model;
    UISwitch *_sw;
    UILabel *_accountMoney;//账户余额
    UILabel *_mianMiLab;
    UIView *_mianMiView;
    UILabel *_limitLabel;//银行限额说明


    
    double  _rechargeMoney;//代入的充值金额
    
}

@property (nonatomic,strong)NSString *bankNotice;

@end

@implementation RechargeViewController


-(id)initWithRechargeMoney:(double)rechargeMoney
{
    self = [super init];
    if (self) {
    _rechargeMoney = rechargeMoney;
    }
    return self;

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    _tableView.scrollEnabled = YES;
    _limitLabel = [[UILabel alloc]init];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [_tableView reloadData];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self dissmissWithBackButton];
    
    BOOL autoClick = [[[NSUserDefaults standardUserDefaults] valueForKey:kAutoClick] boolValue];
    if (autoClick) {
        [CurrentUser mine].userInfo.agreementCZ = YES;
        [_sw setOn:![CurrentUser mine].userInfo.agreementCZ animated:NO];
        _mianMiView.hidden = YES;
        [_tableView reloadData];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAutoClick];
//        [self gotoSummaryPage];
        return;
    }
    [[IQKeyboardManager sharedManager] setEnable:YES];
    if (_isCompleteAction) {
        NSString *investmentMoney = [[NSUserDefaults standardUserDefaults]valueForKey:@"investmentMoney"];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:locationString(@"getvalue_success") message:[NSString stringWithFormat:locationString(@"transfer_account_money"),[investmentMoney doubleValue]] delegate:self cancelButtonTitle:nil otherButtonTitles:locationString(@"btn_confirm"), nil];
        [alertView show];
    }
    
    [self loadBankNotice];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    BOOL autoClick = [[[NSUserDefaults standardUserDefaults] valueForKey:kAutoClick] boolValue];
    if (autoClick) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAutoClick];
        [self gotoSummaryPage];
    }
}


- (void)back
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"needToRefreshAccountInfo"];
    if(self.navigationController.finishBlock)
        self.navigationController.finishBlock();
    [super back];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self back];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

-(void)initViewModelBinding
{
    _viewModel = [[RechargeModel alloc]init];
}

-(void)initUIView
{
     self.title = locationString(@"deposit");
  //  _titleArray = @[@"卡号",@"银行",@"充值金额",@"实际到账金额"];
    [self setTextField];
    [self setSubmitButton];
    [self setFooterView];
    [self setTableView];
    [self loadData];
   
}

-(void)loadData
{
    NSMutableDictionary *paramaters = [[NSMutableDictionary alloc]init];
    [paramaters setValue:_viewModel.belongBank forKey:@"belongBank"];
    
   [self apiForPath:kLimitAmountUrl method:kPostMethod parameter:paramaters responseModelClass:[LimitMountModel class] onComplete:^(id response, id data, NSError *error) {
       _model = (LimitMountModel *)data;
       _limitLabel.text =[NSString stringWithFormat:locationString(@"key_prompt_mgs"), safeEmpty(_model.onceLimit), safeEmpty(_model.dailyLimit)];
   }];
}

-(void)setTextField
{
    
//    _amountField = [[RechargeTextField alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth /3, kGeneralHeight)];
    _amountField = [[RechargeTextField alloc]initWithFrame:CGRectMake(0, 35, kScreenWidth, 50)];
    [_amountField addLeftViewWithTitle:locationString(@"deposit_amount") leftMargin:15 leftWidth:100 leftViewMode:UITextFieldViewModeAlways];
    _amountField.backgroundColor = [UIColor whiteColor];
    _amountField.placeholder = locationString(@"input_amount1");
    _amountField.keyboardType = UIKeyboardTypeDecimalPad;
    _amountField.delegate = self;
//    [_amountField setValue:[UIFont systemFontOfSize:14]forKeyPath:@"_placeholderLabel.font"];
//    [_amountField setValue:[UIColor colorWithHexString:@"#cccccc"] forKeyPath:@"_placeholderLabel.textColor"];
    [_amountField addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventAllEditingEvents];
    // _amountField.textAlignment = NSTextAlignmentRight;
    if (_rechargeMoney) {
     _amountField.text = [NSString stringWithFormat:@"%.2f",_rechargeMoney];
    }
    
 
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    line1.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [_amountField addSubview:line1];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 49, kScreenWidth, 1)];
    line2.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [_amountField addSubview:line2];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 35, 15, 20, 20)];
    lab.text = locationString(@"money_unit_yuan");
    lab.textAlignment = NSTextAlignmentRight;
    lab.textColor = [UIColor colorWithHexString:@"#3a3a3a"];
    lab.font = [CustomerizedFont heiti:14];
    [_amountField addSubview:lab];
    
}

-(void)loadBankNotice{
    [LTNServerHelper bankNotice:^(id response) {
        //
        if(response&&isDictionary(response)){
            NSDictionary *data=response[@"data"];
            if(data&&isDictionary(data)){
                self.bankNotice=esString(data[@"notice"]);
             }
        }
 
    } failure:nil];
}



-(void)setBankNotice:(NSString *)bankNotice{
    _bankNotice=bankNotice;
    [_tableView reloadData];
}

-(void)setTableView

{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor = BACKGROUND_COLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = false;
    _tableView.separatorColor = HexRGB(0xe2e2e2);
    [self.view addSubview:_tableView];

    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    _tableView.tableFooterView = _footView;
    

    
}

-(void)setSubmitButton
{
    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_submitButton setTitle:locationString(@"next") forState:UIControlStateNormal];
    [_submitButton setBackgroundImage:[UIImage imageNamed:@"confirmButton"] forState:UIControlStateNormal];
    [_submitButton addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = 5;
}

-(void)setFooterView
{
    _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 240)];
    
    _accountMoney = [Utility createLabel:[CustomerizedFont heiti:12] color:[UIColor colorWithHexString:@"#666666"]];
    [_footView addSubview:_accountMoney];
    _accountMoney.text = [NSString stringWithFormat:locationString(@"account_balance"),[CurrentUser mine].accountInfo.usableBalance];
    [_accountMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_footView).offset(15);
        make.top.equalTo(_footView.mas_top).offset(0);
         make.height.mas_equalTo(@40);
        
    }];

    [_footView addSubview:_amountField];
    
    _mianMiView = [[UIView alloc]initWithFrame:CGRectMake(0, 85, kScreenWidth, 50)];
    _mianMiView.backgroundColor = [UIColor whiteColor];
    [_footView addSubview:_mianMiView];
    
    _mianMiLab = [Utility createLabel:[CustomerizedFont heiti:14] color:[UIColor colorWithHexString:@"#8a8a8a"]];
    _mianMiLab.frame = CGRectMake(15, 0, 100, 50);
    _mianMiLab.text = locationString(@"mianmi_charge");
    [_mianMiView addSubview:_mianMiLab];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(_mianMiLab.right, 15, 20, 20)];
    [btn setImage:[UIImage imageNamed:@"icon_help"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(explainMianMi) forControlEvents:UIControlEventTouchUpInside];
    [btn setEnlargeEdge:10];
    [_mianMiView addSubview:btn];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 49, kScreenWidth, 1)];
    line3.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [_mianMiView addSubview:line3];
    
    if (_sw == nil) {
        _sw = [[UISwitch alloc]init];
    }
    _sw.frame = CGRectMake(kScreenWidth - 65, 9, 40, 40);
    [_mianMiView addSubview:_sw];
    
    if ([CurrentUser mine].userInfo.agreementCZ) {
        _mianMiView.hidden = YES;
    }else{
        _mianMiView.hidden = NO;
    }
    
    [_footView addSubview:_submitButton];
    
    if ([CurrentUser mine].userInfo.agreementCZ) {
        
        [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_footView).offset(15);
            make.right.equalTo(_footView).offset(-15);
            make.top.equalTo(_footView.mas_top).offset(128);
            make.height.mas_equalTo(@40);
        }];
        
    }else{
        
    [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_footView).offset(15);
        make.right.equalTo(_footView).offset(-15);
        make.top.equalTo(_footView.mas_top).offset(178);
        make.height.mas_equalTo(@40);
    }];
    }
    
    _descLabel = [[UILabel alloc]init];
    [_footView addSubview:_descLabel];
    _descLabel.text = locationString(@"charge_descr");
    _descLabel.font = [UIFont systemFontOfSize:12];
    _descLabel.textColor = [UIColor grayColor];
    _descLabel.numberOfLines = 0;
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_footView).offset(30);
        make.right.equalTo(_footView).offset(-15);
        make.top.equalTo(_submitButton.mas_bottom).offset(10);
    }];
    
    _iconImageView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_tip"]];
    [_footView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_footView).offset(15);
        make.width.height.equalTo(@12);
        make.centerY.equalTo(_descLabel.mas_top).offset(7);
    }];
    
}


#pragma - mark TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    NSInteger section = 1;
//    if (![CurrentUser mine].userInfo.agreementCZ) {
//        section += 1;
//    }
//
//    return section;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 //   return section == 0 ? 4 : 1;
    return 1;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    cell.bankInstr.text = _limitLabel.text;
    
    return cell;
    
/*
    UITableViewCell *cell;
    if (indexPath.section == 1) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SwitchCell"];
        cell.textLabel.text = @"开通充值免密支付";
        if (_sw == nil) {
            _sw = [[UISwitch alloc] init];
        }
        cell.accessoryView = _sw;

        return cell;
    }

    NSString *RECHARGE_CELL = @"RechargeCell";
    cell = [tableView dequeueReusableCellWithIdentifier:RECHARGE_CELL];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:RECHARGE_CELL];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#3a3a3a"];
       // cell.textLabel.text = _titleArray[indexPath.row];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#3a3a3a"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = _viewModel.belongBank;
          //  cell.imageView.image = [UIImage imageNamed:_viewModel.bankIcon];
            cell.imageView.image = [UIImage imageNamed:_viewModel.bankIcon];

        
            [cell.detailTextLabel setNumberOfLines:2];
            NSString *string = @"dfsgsgsgsgdsdwfkk";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"尾号%@\n%@",[StringUtil subStringFromString:_viewModel.bankNo],string];
          //  cell.detailTextLabel.text = [NSString stringWithFormat:@"尾号%@",[StringUtil subStringFromString:_viewModel.bankNo]];
            cell.textLabel.centerY=[self tableView:_tableView heightForRowAtIndexPath:indexPath]/2;

        }
        else if (indexPath.row == 1){

            cell.detailTextLabel.text = _viewModel.belongBank;

        }else if (indexPath.row ==2) {

            cell.accessoryView = _amountField;

        }else if (indexPath.row ==3) {

            cell.detailTextLabel.text =_amountField.text.length == 0 ?@"0.00元": [NSString stringWithFormat:@"%.2f元",[_amountField.text doubleValue]];
            [[NSUserDefaults standardUserDefaults]setValue:_amountField.text forKey:@"investmentMoney"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }

    }

    return cell;
 */
    
    

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0&&[self.bankNotice length]>0){//显示
        return 25;
    }else{//不显示
        return 15;
    }

    return 15;

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if(section==0&&[self.bankNotice length]>0){
        //显示
            SXMarquee *_marView = [[SXMarquee alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 25) speed:4 Msg:self.bankNotice bgColor:[UIColor colorWithRed:255.0/255 green:254.0/255 blue:223.0/255 alpha:1.0] txtColor:[UIColor colorWithHexString:@"#EA5504"]];
            [_marView changeMarqueeLabelFont:[UIFont systemFontOfSize:12]];
            [_marView start];
            return _marView;
        
    }
    
    //不显示
    return [TableViewDevider getHeaderViewWithHeight:15 showTopLine:YES showBottomLine:YES];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

/**
 *  提交按钮
 *
 *  @param sender <#sender description#>
 */
-(void)submitClick:(id)sender
{
    [self.view endEditing:YES];
    CGFloat fee = [_amountField.text doubleValue];
    if ([_amountField.text doubleValue] <= 0) {
        [LTNUtilsHelper boxShowWithMessage:locationString(@"amount_small_error")];
        return;
    }
    
    // 判断有效位数
    if (![_amountField validDecimal]) {
        [LTNUtilsHelper boxShowWithMessage:locationString(@"amount_digits_error")];
        return;
    }
    
    CGFloat total = [_model.onceLimit doubleValue];
    if (total > 0.1) {
        //if onceLimit is valid, check the limit constraints
        //total, unit w
        if (fee >= total * 10000 + 0.0001) {
            [LTNUtilsHelper boxShowWithMessage:locationString(@"amonut_grenter")];
            return;
        }
    }
    
    
    [LTNCore globleCore].tempAmt=esString(_amountField.text);
    BOOL applyForPermission = _sw.isOn;
    kWeakSelf
    if (applyForPermission) {
        _submitButton.enabled = NO;
        NSDictionary *dict = @{@"agreement_type" : @"ZCZP0800"};
//        MBProgressHUD * progressHUD = [MBProgressHUD bwm_showHUDAddedToController:self title:nil animated:YES];
        [self apiForPath:kUserAgreeMianMiUrl method:kPostMethod parameter:dict responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
//            [progressHUD hide:YES];
            
            //TODO:免密订单号？
            _submitButton.enabled = YES;
            if (!error) {
                //goto grant mianmi page
                CustomizedBackWebViewController *baseWebViewController = [[CustomizedBackWebViewController alloc] initWithURL:[data valueForKey:@"url"]];
                [weakSelf.navigationController pushViewController:baseWebViewController animated:YES];
            }
        }];
    } else {
        if ([CurrentUser mine].userInfo.agreementCZ) {
            [self gotoSummaryPage];
        } else {
            [TrackingUtility event:kCZClicked];
            [self showWaitingIcon];
            _submitButton.enabled = NO;
//            MBProgressHUD * progressHUD = [MBProgressHUD bwm_showHUDAddedToController:self title:nil animated:YES];
            [_viewModel GET_UserRechargeWithOrderAmount:_amountField.text success:^(BOOL success) {
                _submitButton.enabled = YES;
//                [progressHUD hide:YES];
                [weakSelf dismissWaitingIcon];
                CustomizedBackWebViewController *baseWebViewController = [[CustomizedBackWebViewController alloc]initWithURL:_viewModel.bindBankCardModel.url];
                [weakSelf.navigationController pushViewController:baseWebViewController animated:YES];
            } failure:^(NSString *error) {
                _submitButton.enabled = YES;
//                [progressHUD hide:YES];
                [weakSelf dismissWaitingIcon];
                [LTNUtilsHelper boxShowWithMessage:error];
                
                //充值失败
                NSArray *piwikArr=@[
                                    @[@"order_no",@""],
                                    @[@"result",@"0"],
                                    @[@"reason",esString(error.description)],
                                    @[@"amt",esString([LTNCore globleCore].tempAmt)],
                                    @[@"datepoint",timeForStatistics()],
                                    
                                    ];
                piwikEvent(@"recharge",piwikArr);

                
            }];
        }
    }
}

- (void)valueChanged:(UITextField *)textfield {
   // [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [[NSUserDefaults standardUserDefaults]setValue:_amountField.text forKey:@"investmentMoney"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _amountField) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 10) {
            return NO;
        }
    }
    
    return YES;
}


//充值预览页
- (void)gotoSummaryPage
{
    RechargeSummaryViewController *vc = [[RechargeSummaryViewController alloc] init];
//    vc.data = [NSMutableArray arrayWithCapacity:_titleArray.count];
//    int i = 0;
//    int section = 0;
//    for (NSString *title in _titleArray) {
//        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:section]];
//        NSString *value = cell.detailTextLabel.text;
//        if (i == 2) {
//            value = _amountField.text;
//        }
//        id item = @[
//                    safeEmpty(title),
//                    safeEmpty(value)
//                    ];
//        [vc.data addObject:item];
//        i++;
//    }
    
    vc.promptMsg = _descLabel.text;
    vc.rechargeSum = _amountField.text;
    vc.bankInstr = _limitLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
}

//解释免密
- (void)explainMianMi{
    
    LTNExplainFreeCodeView *explain = [[LTNExplainFreeCodeView alloc]init];
    [explain show];

}
@end
