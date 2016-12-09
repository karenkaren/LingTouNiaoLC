//
//  ChargeViewController.m
//  lingtouniao
//
//  Created by 徐凯 on 15/12/24.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "ChargeViewController.h"
#import "ChargeModel.h"
#import "RechargeTextField.h"
#import "BaseWebViewController.h"
#import "CustomizedBackWebViewController.h"
#import "CustomAlerView.h"
#import "RechargeCell.h"
#import "UIImageView+WebCache.h"
#import "HeardView.h"

@interface ChargeViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    UITableView *_tableView;
    NSArray *_titleArray;
    UIButton *_chargeButton;//提现
    ChargeModel *_viewModel;
    RechargeTextField *_amountField;
    UIButton *_chargeExplanationButton;//提现说明
    UIView *_footView;
  //  UILabel *_descLabel;//提现说明
    UIImageView *_iconImageView;//说明图标
    UILabel *_accountMoney;//账户余额
    UILabel *_realMoney;//实际金额
    UIWindow *_sheetWindow ;
    
}
@property (nonatomic,strong)NSString *bankNotice;
@property (nonatomic) UIButton *btn;//全部提现按钮

@end

@implementation ChargeViewController


- (void)back
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    if(self.navigationController.finishBlock)
        self.navigationController.finishBlock();
    [super back];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
   // _tableView.scrollEnabled = NO;
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
    
    [self loadBankNotice];
    
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



-(void)initViewModelBinding
{
    _viewModel = [[ChargeModel alloc]init];
}

-(void)initUIView
{
    self.navigationItem.title = locationString(@"with_draw_title");
 //   _titleArray = @[@[@"可用余额",@"银行",@"提现手续费"],@[@"提现金额",@"实际到账金额"]];
    [self setTextField];
    [self setChargeButton];
    [self setFooterView];
    [self setTableView];
   
}


-(void)setTextField
{

    //_amountField = [[RechargeTextField alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth / 3, kGeneralHeight)];
    _amountField = [[RechargeTextField alloc]initWithFrame:CGRectMake(0, 35, kScreenWidth, 50)];
    [_amountField addLeftViewWithTitle:locationString(@"with_draw_input_title") leftMargin:15 leftWidth:100 leftViewMode:UITextFieldViewModeAlways];
    _amountField.placeholder = locationString(@"with_draw_input_message");
    _amountField.backgroundColor = [UIColor whiteColor];
    _amountField.keyboardType = UIKeyboardTypeDecimalPad;
    _amountField.delegate = self;
//    [_amountField setValue:[UIFont systemFontOfSize:14]forKeyPath:@"_placeholderLabel.font"];
//    [_amountField setValue:[UIColor colorWithHexString:@"#cccccc"] forKeyPath:@"_placeholderLabel.textColor"];
//    [_amountField addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventAllEditingEvents];
     [_amountField addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventEditingChanged];
//    _amountField.textAlignment = NSTextAlignmentRight;
    
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

//-(void)setChargeExplanationButton
//{
//    _chargeExplanationButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _chargeExplanationButton.frame = CGRectMake(0, 0, kScreenWidth, 40);
//    [_chargeExplanationButton setTitle:@"提现说明" forState:UIControlStateNormal];
//    [_chargeExplanationButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
//    [_chargeExplanationButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//    [_chargeExplanationButton setTitleEdgeInsets:UIEdgeInsetsMake(0, kScreenWidth-75, 0, 0)];
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_chargeExplanationButton.titleLabel.text];
//    NSRange strRange = {0,[str length]};
//    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
//    [_chargeExplanationButton setAttributedTitle:str forState:UIControlStateNormal];
//    [_chargeExplanationButton addTarget:self action:@selector(explanationClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_chargeExplanationButton];
//}

-(void)setFooterView
{
    _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 240)];
    
    _accountMoney = [Utility createLabel:[CustomerizedFont heiti:12] color:[UIColor colorWithHexString:@"#6a6a6a"]];
    [_footView addSubview:_accountMoney];
    _accountMoney.text = [NSString stringWithFormat:locationString(@"account_balance"),[CurrentUser mine].accountInfo.usableBalance];
    [_accountMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_footView).offset(15);
        make.top.equalTo(_footView.mas_top).offset(0);
        make.height.mas_equalTo(@40);
        
    }];
    
    self.btn = [Utility createButtonWithTitle:locationString(@"with_draw_all") color:kHexColor(@"#0090ff") font:[CustomerizedFont systemFontOfSize:12] block:^(UIButton *btn) {
        [self withdrawAll];
    }];
    [_footView addSubview: self.btn];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_accountMoney.mas_right).offset(10);
        make.top.equalTo(_footView.mas_top);
        make.height.mas_equalTo(@40);
        
    }];
    
    [_footView addSubview:_amountField];

    
    UILabel *poundgeLab = [Utility createLabel:[CustomerizedFont heiti:12] color:[UIColor colorWithHexString:@"#666666"]];
    poundgeLab.frame = CGRectMake(15, _amountField.bottom + 12, 80, 40);
    [_footView addSubview:poundgeLab];
    if((_viewModel.freeCounter > 0) || (_viewModel.birdCoin >= 2.00)){
        poundgeLab.text = locationString(@"with_draw_cost");
    }else{
        poundgeLab.text = locationString(@"with_draw_cost2");
    }
    [poundgeLab sizeToFit];
    
    UILabel *realMoneyLab = [Utility createLabel:[CustomerizedFont heiti:12] color:[UIColor colorWithHexString:@"#666666"]];
    realMoneyLab.frame = CGRectMake(110, _amountField.bottom + 12, 60, 40);
    realMoneyLab.text = locationString(@"get_amount");
    [realMoneyLab sizeToFit];
    [_footView addSubview:realMoneyLab];
    
    
    UILabel *realMoney = [Utility createLabel:[CustomerizedFont heiti:12] color:[UIColor colorWithHexString:@"#f68818"]];
    realMoney.frame = CGRectMake(realMoneyLab.right, _amountField.bottom + 12, kScreenWidth - realMoneyLab.right, 40);
    [_footView addSubview:realMoney];
    realMoney.text = locationString(@"no_money_yuan");
    [realMoney sizeToFit];
    _realMoney = realMoney;

    
    [_footView addSubview:_chargeButton];
    [_chargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_footView).offset(15);
        make.right.equalTo(_footView).offset(-15);
        make.top.equalTo(_footView.mas_top).offset(128);
        make.height.mas_equalTo(@40);
    }];
    
    
    HeardView *descLab = [[HeardView alloc]init];
    [_footView addSubview:descLab];
    descLab.circleView1.hidden = YES;
    descLab.circleView2.hidden = YES;
    descLab.line1.hidden = YES;
    descLab.line2.hidden = YES;
    
    [descLab setTitle:locationString(@"with_draw_time_explain")];

    [descLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_footView).offset(0);
        make.right.equalTo(_footView).offset(0);
        make.top.equalTo(_chargeButton.mas_bottom).offset(9);
    }];
    
   
    
    UILabel *detail1Lab = [[UILabel alloc]init];
    [_footView addSubview:detail1Lab];
   
    detail1Lab.numberOfLines = 0;
    detail1Lab.text = locationString(@"with_draw_note");
    detail1Lab.textColor = [UIColor colorWithHexString:@"#3a3a3a"];
    detail1Lab.font = [CustomerizedFont heiti:12];
    [detail1Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_footView).offset(31);
        make.right.equalTo(_footView).offset(-31);
        make.top.equalTo(descLab.mas_bottom).offset(31);
    }];
    
    
    HeardView *moneyLab = [[HeardView alloc]init];
    [_footView addSubview:moneyLab];
   
    [moneyLab setTitle:locationString(@"with_draw_cost_explain")];
    [moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_footView).offset(0);
        make.right.equalTo(_footView).offset(0);
        make.top.equalTo(detail1Lab.mas_bottom).offset(7);
    }];

    
    UILabel *detail2Lab = [[UILabel alloc]init];
    [_footView addSubview:detail2Lab];
    
    detail2Lab.numberOfLines = 0;
    detail2Lab.text = locationString(@"with_draw_note2");
    detail2Lab.textColor = [UIColor colorWithHexString:@"#3a3a3a"];
    detail2Lab.font = [CustomerizedFont heiti:12];
    [detail2Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_footView).offset(31);
        make.right.equalTo(_footView).offset(-31);
        make.top.equalTo(moneyLab.mas_bottom).offset(31);

    }];
}

//全部提现
- (void)withdrawAll{
    
     _amountField.text = [NSString stringWithFormat:@"%.2f",[CurrentUser mine].accountInfo.usableBalance];
    [self actuallyMoney];
   
    
}

/**
 *  提现说明
 *
 *  @param button <#button description#>
 */
-(void)explanationClick:(UIButton *)button
{
    BaseWebViewController *baseWebViewController = [[BaseWebViewController alloc] initWithURL:kH5WithDrawIntroUrl];
    [self.navigationController pushViewController:baseWebViewController animated:YES];
}

-(void)setTableView
{
//    CGFloat navibarHeight = self.navigationController.navigationBar.frame.size.height;
//    CGFloat tabbarHeight = self.navigationController.tabBarController.tabBar.frame.size.height;
//    CGFloat statusHeight = [[UIApplication sharedApplication]statusBarFrame].size.height;
//    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - navibarHeight - tabbarHeight - statusHeight)style:UITableViewStyleGrouped];
     _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor = BACKGROUND_COLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = _footView;
    [self.view addSubview:_tableView];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)setChargeButton
{
    _chargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_chargeButton setTitle:locationString(@"next") forState:UIControlStateNormal];
    [_chargeButton setBackgroundImage:[UIImage imageNamed:@"confirmButton"] forState:UIControlStateNormal];;
    [_chargeButton addTarget:self action:@selector(chargeClick:) forControlEvents:UIControlEventTouchUpInside];
    _chargeButton.layer.masksToBounds = YES;
    _chargeButton.layer.cornerRadius = 5;


}


#pragma - mark TableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   // return 2;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    switch (section) {
//        case 0:
//            return 3;
//            break;
//        case 1:
//            return 2;
//            break;
//        default:
//            return 0;
//            break;
//    }
    return 1;
}





-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0&&[self.bankNotice length]>0){
        return 25;
    }else{//不显示
        return 15;
    }

    
//    if (_viewModel.freeCounter == 0 && _viewModel.birdCoin >= 2.0) {///TODO:???????
//        switch (section) {
//            case 0:{
//                
//                if([self.bankNotice length]>0){//显示
//                    return 25;
//                         }else{//不显示
//                    return 15;
//                }
//
//            }
//                
//                break;
//            case 1:
//                return 32;
//                break;
//            default:
//                return 0;
//                break;
//        }
//    }else//TODO:  需要银行信息显示吗？
//    {
//        if(section==0&&[self.bankNotice length]>0){
//            return 25;
//        }else{//不显示
//            return 15;
//        }
//
//    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    
    return 0.5;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  
        if (_viewModel.freeCounter == 0 && _viewModel.birdCoin >= 2.0) {
            if (section == 1) {
                return [TableViewDevider getHighHeaderRightLabelWithString:locationString(@"deduct_fee_with_two_bird_coin") hasTopLine:NO];
            }
        }
    
    
    if(section==0&&[self.bankNotice length]>0){
        SXMarquee *_marView = [[SXMarquee alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 25) speed:4 Msg:self.bankNotice bgColor:[UIColor colorWithRed:255.0/255 green:254.0/255 blue:223.0/255 alpha:1.0] txtColor:[UIColor colorWithHexString:@"#EA5504"]];
        [_marView changeMarqueeLabelFont:[UIFont systemFontOfSize:12]];
        [_marView start];
        return _marView;
    }
    //不显示
    return [TableViewDevider getHeaderViewWithHeight:15 showTopLine:YES showBottomLine:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cell";
    RechargeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[RechargeCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSURL *url = [NSURL URLWithString:bankIcon(_viewModel.belongBank)];
    [cell.bankImg sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRetryFailed];
    
    cell.bankName.text = _viewModel.belongBank;
    cell.detailTextLabel.text = [NSString stringWithFormat:locationString(@"last_number"),[StringUtil subStringFromString:_viewModel.bankNo]];
    cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#3a3a3a"];
    cell.detailTextLabel.font = [CustomerizedFont heiti:15];
   
    return cell;
    
/*
    NSString *ChargeCell = @"ChargeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChargeCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ChargeCell];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#3a3a3a"];
        cell.textLabel.text = _titleArray[indexPath.section][indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#3a3a3a"];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f元",_viewModel.usableBalance];
        }
        else if (indexPath.row == 1)
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@  尾号%@",_viewModel.belongBank,[StringUtil subStringFromString:_viewModel.bankNo]];
        }
        
        else if (indexPath.row == 2)
        {
            if((_viewModel.freeCounter > 0) || (_viewModel.birdCoin >= 2.00))
            {
                cell.detailTextLabel.text = @"0.00元";
            }
            else
            {
                cell.detailTextLabel.text = @"2.00元";
            }
            
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            cell.accessoryView = _amountField;
            
        }else if (indexPath.row == 1)
        {
            if ((_viewModel.freeCounter > 0) || (_viewModel.birdCoin >= 2.00)) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f元",([_amountField.text doubleValue] < _viewModel.usableBalance) ? [_amountField.text doubleValue] : _viewModel.usableBalance];
            }else
            {
             cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f元",((_viewModel.usableBalance - [_amountField.text doubleValue ])>=2)?[_amountField.text doubleValue ]:([_amountField.text doubleValue]-(2-(_viewModel.usableBalance - [_amountField.text doubleValue])))];
                if([cell.detailTextLabel.text doubleValue] < 0)
                {
                  cell.detailTextLabel.text = @"0.00";
                }
            }
        }
        
    }
    
    
    return cell;
 */
    
}


/**
 *  提现
 */
 
-(void)chargeClick:(id)sender
{
    [self.view endEditing: YES];
    
    // 判断有效位数
    if (![_amountField validDecimal]) {
        [LTNUtilsHelper boxShowWithMessage:locationString(@"amount_digits_error")];
        return;
    }
    
    float realitymoney;//实际到账金额
    if ([_amountField.text doubleValue] <= 0) {
        [LTNUtilsHelper boxShowWithMessage:locationString(@"amount_small_error")];
        return;
    }
        
    if ((_viewModel.freeCounter > 0) || (_viewModel.birdCoin >= 2.00))
    {
        realitymoney = [_amountField.text doubleValue];
    }
    else{
        if(_viewModel.usableBalance < 2)
        {
            [LTNUtilsHelper boxShowWithMessage:locationString(@"with_draw_toast4")];
            return;
        }
        
        realitymoney = _viewModel.usableBalance - [_amountField.text doubleValue]>= 2 ? [_amountField.text doubleValue]:_viewModel.usableBalance - 2;
    }
    _chargeButton.enabled = NO;
    NSString *messagestring;
//    if(_viewModel.freeCounter > 0)
//    {
//     messagestring = [NSString stringWithFormat:@"实际到账%.2f元，此次提现免手续费%.2f元，你当月还有%ld次免费提现机会，确认提现吗？",realitymoney,_viewModel.freeCounter > 0?2.00:0.00,(_viewModel.freeCounter-1) > 0?(_viewModel.freeCounter-1):0];
//    
//    }
//     else if ((_viewModel.freeCounter == 0) && (_viewModel.birdCoin >= 2.00))
//    {
//     messagestring = [NSString stringWithFormat:@"实际到账%.2f元，此次提现免手续费%.2f元，你当月还有%ld次免费提现机会，本次提现用2鸟币抵扣手续费。确认提现吗？",realitymoney,_viewModel.freeCounter > 0?2.00:0.00,(_viewModel.freeCounter-1) > 0?(_viewModel.freeCounter-1):0];
//    }else
//    {
//    messagestring = [NSString stringWithFormat:@"实际到账%.2f元，你当月还有%ld次免费提现机会，本次提现扣除手续费2元。确认提现吗？",realitymoney,(_viewModel.freeCounter-1) > 0?(_viewModel.freeCounter-1):0];
//
//    }
    
    
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
//    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
//    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
//    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
//    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
//    NSComparisonResult result = [dateA compare:dateB];
//    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
//    if (result == NSOrderedDescending) {
//        //NSLog(@"Date1  is in the future");
//        return 1;
//    }
//    else if (result == NSOrderedAscending){
//        //NSLog(@"Date1 is in the past");
//        return -1;
//    }
//    //NSLog(@"Both dates are the same");
//    return 0;
//    
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    NSDate *dateA = [dateFormatter dateFromString:dateString];
    NSDate *dateB = [dateFormatter dateFromString:@"17:15"];
    NSString *compareString = nil;
    
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedAscending) {
         compareString = locationString(@"with_draw_tonight");
    }else{
         compareString = locationString(@"with_draw_tomorrow");
    }
    
    messagestring = [NSString stringWithFormat:locationString(@"with_draw_arrival_hint4"),realitymoney,(_viewModel.freeCounter-1) > 0?(_viewModel.freeCounter-1):0,compareString];
        
   
    _sheetWindow = [CustomAlerView showAlertViewWithImage:@"icon_tishi" title:locationString(@"import_tip") detail:messagestring canleButtonTitle:locationString(@"btn_cancel") okButtonTitle:locationString(@"with_draw_confirm") callBlock:^(MyWindowClick buttonIndex) {
        if (buttonIndex == 1) {
            _sheetWindow.hidden = YES;
            _sheetWindow = nil;
        }
        if (buttonIndex == 0) {
            _sheetWindow.hidden = YES;
            _sheetWindow = nil;
            [TrackingUtility event:kTXClicked];
            
            
            [LTNCore globleCore].tempAmt=esString(_amountField.text);
            [_viewModel GET_UserWithdrawalsWithOrderAmount:_amountField.text birdCoin:_viewModel.birdCoin >= 2 ? @"2":@"0"  buckle:@"JYF" success:^(BOOL success) {
                //提现-[需要去联动网页]
                _chargeButton.enabled = YES;
                BaseWebViewController *baseWebViewController = [[CustomizedBackWebViewController alloc]initWithURL:_viewModel.bindBankCardModel.url];
                [self.navigationController pushViewController:baseWebViewController animated:YES];
                
            } failure:^(NSString *error) {
                _chargeButton.enabled = YES;
                [LTNUtilsHelper boxShowWithMessage:error];
            }];
        } else {
            _chargeButton.enabled = YES;
        }

        
    }];
    
    
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"重要提示！" message:messagestring  delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定提现", nil];
//    
//    [alertView showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
//        
//        if (buttonIndex) {
//            [TrackingUtility event:kTXClicked];
//            [_viewModel GET_UserWithdrawalsWithOrderAmount:_amountField.text birdCoin:_viewModel.birdCoin >= 2 ? @"2":@"0"  buckle:@"JYF" success:^(BOOL success) {
//                //提现-[需要去联动网页]
//                _chargeButton.enabled = YES;
//                BaseWebViewController *baseWebViewController = [[CustomizedBackWebViewController alloc]initWithURL:_viewModel.bindBankCardModel.url];
//                [self.navigationController pushViewController:baseWebViewController animated:YES];
//                
//            } failure:^(NSString *error) {
//                _chargeButton.enabled = YES;
//                [LTNUtilsHelper boxShowWithMessage:error];
//            }];
//        } else {
//            _chargeButton.enabled = YES;
//        }
//    }];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *shouldText = [[textField.text stringByReplacingCharactersInRange:range withString:string] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if ([shouldText doubleValue] > _viewModel.usableBalance) {
        [LTNUtilsHelper boxShowWithMessage:locationString(@"with_draw_toast3")];
        return  NO;
    }
    
    return YES;
}

- (void)valueChanged:(UITextField *)textfield {
    
    [self actuallyMoney];
    if (textfield == _amountField) {
        if (textfield.text.length > 18) {
            textfield.text = [textfield.text substringToIndex:18];
        }
    }
    
    //  [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)actuallyMoney{
    
    if ((_viewModel.freeCounter > 0) || (_viewModel.birdCoin >= 2.00)){
        _realMoney.text = [NSString stringWithFormat:locationString(@"amount_yuan_decimal"),([_amountField.text doubleValue] < _viewModel.usableBalance) ? [_amountField.text doubleValue] : _viewModel.usableBalance];
    }else{
        _realMoney.text =  [NSString stringWithFormat:locationString(@"amount_yuan_decimal"),((_viewModel.usableBalance - [_amountField.text doubleValue ])>=2)?[_amountField.text doubleValue ]:([_amountField.text doubleValue]-(2-(_viewModel.usableBalance - [_amountField.text doubleValue])))];
        if ([_realMoney.text doubleValue] < 0) {
            _realMoney.text = @"0.00";
        }
    }
    [_realMoney sizeToFit];
    
}
@end
