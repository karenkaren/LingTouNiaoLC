//
//  ConfirmInvestViewController.m
//  lingtouniao
//
//  Created by 徐凯 on 15/12/17.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "ConfirmInvestViewController.h"
#import "CheckBox.h"
#import "BaseWebViewController.h"
#include "LTNServerConstant.h"
#import "SGActionView.h"

#import "InvestSummaryViewController.h"


@interface ConfirmInvestViewController ()<UITableViewDelegate,UITableViewDataSource>
//{
//    BOOL _selectFirstItem;
//    BOOL _selectSecondItem;
//    UIView *_footerView;//底部视图
//    PayButtonView *_payButtonView;
//    SubmitOrderModel *_submitOrderModel;
//    double _coin;//鸟币
//    NSInteger _index;//理财金券默认数组第一个数值
//    NSInteger _otherCouponIdSelectedIndex;//理财金券选择cell
//    long userCouponId;
//    NSString *couponDes;
//}
@property (weak, nonatomic) IBOutlet CheckBox *checkBox;
@property (strong, nonatomic) IBOutlet UIView *agreementview;

@end

@implementation ConfirmInvestViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    BOOL autoClick = [[[NSUserDefaults standardUserDefaults] valueForKey:kAutoClick] boolValue];
    if (autoClick) {
        [CurrentUser mine].userInfo.agreementTZ = YES;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAutoClick];
        [self performSelector:@selector(gotoSummaryPage) withObject:nil afterDelay:0.6];
        return;
    }
}
- (void)initViewModelBinding
{
    _submitOrderModel = [[SubmitOrderModel alloc]init];

}

-(void)initUIView
{
    self.navigationItem.title = locationString(@"confirm_buy");
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshCopouns:) name:NOTIFICATION_SELECTED_CHANGED object:nil];
    [_checkBox addObserver:self forKeyPath:@"isSelected" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    _checkBox.isSelected = true;
    _selectFirstItem = YES;
    _selectSecondItem = NO;
    _index = 0;
    _otherCouponIdSelectedIndex = NSIntegerMin;
    _payButtonView = [[PayButtonView alloc]init];
    [_payButtonView.payButton addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchUpInside];
    [self setUpTableView];
    [self setUpFooterView];
    [self setAgreementview];
    [self loadData];
  
}

-(void)setUpTableView
{
    CGFloat navibarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat tabbarHeight = self.navigationController.tabBarController.tabBar.frame.size.height;
    CGFloat statusHeight = [[UIApplication sharedApplication]statusBarFrame].size.height;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - navibarHeight - tabbarHeight - statusHeight - 30)style:UITableViewStyleGrouped];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = BACKGROUND_COLOR;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
}

-(void)setAgreementview
{
    [self.view addSubview:_agreementview];

    [_agreementview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(_footerView.mas_top);
        make.height.equalTo(@39);
    
    }];
}

-(void)loadData
{
       [self showWaitingIcon];
       __weak typeof(self) weakself = self;
       __weak typeof(_tableView) weakTableView = _tableView;
      [_submitOrderModel GET_getBuyWithProductId:[NSString stringWithFormat:@"%ld",_productId] andInvestAmount:_investAmount Success:^(BOOL isSuccess) {
       if (isSuccess) {
           [weakself dismissWaitingIcon];
           [weakTableView reloadData];
       }
   } failure:^(NSString *error) {
       
       [weakself dismissWaitingIcon];
       
   }];
    
}


#pragma TableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _submitOrderModel.coupounArray.count == 0 ?1:2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([_submitOrderModel.orderPrepareModel.productType isEqualToString:@"TYB"])
    {
        switch (section) {
            case 0:
                return 3;
                break;
            case 1:
                return 1;
                break;
            default:
                return 0;
                break;
        }

    }else if ([_submitOrderModel.orderPrepareModel.productType isEqualToString:@"XSB"])
    {
        switch (section) {
            case 0:
                return 3;
                break;
            case 1:
                return 0;
                break;
            default:
                return 0;
                break;
        }
    
    }
    else{
        switch (section) {
            case 0:
                return _submitOrderModel.orderPrepareModel.birdCoin == 0 ? 3 : 4;
                break;
            case 1:
                return  _otherCouponIdSelectedIndex>=0?1:[self getCoupounCount:_submitOrderModel.coupounArray.count];
                break;
            default:
                return 0;
                break;
        }
        
        
        
        

    }
    return 0;

}

-(NSInteger)getCoupounCount:(NSInteger)count
{
    
    if (count == 0) {
        return 0;
    }else if (count == 1)
    {
        return 1;
    }else if (count >= 2)
    {
        return 2;
    }
    else
    {
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self buildCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)buildCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
            cell.detailTextLabel.text = [NSString stringWithFormat:locationString(@"amount_yuan_text"),[_submitOrderModel.orderPrepareModel.productType isEqualToString:@"TYB"]?@"10000":_investAmount];
            
        }
        else if (indexPath.row == 1)
        {
            cell.textLabel.text = locationString(@"toreceive_balance");
            
            /**
             *  ===========================================
             *  ===========================================
             需要服务器添加字段时进行复测，切记
             
             */
            
            if ([_submitOrderModel.orderPrepareModel.productType isEqualToString:@"TYB"]) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f%@",[_submitOrderModel.orderPrepareModel.revenue doubleValue], locationString(@"bird_coin")];
                
            }else
            {
                if ([_submitOrderModel.orderPrepareModel.productType isEqualToString:@"XSB"])
                {
                    cell.detailTextLabel.text = [NSString stringWithFormat:locationString(@"amount_yuan_decimal"), [_submitOrderModel.orderPrepareModel.revenue doubleValue]];
                }else
                {
                    
                    if((_selectFirstItem || _selectSecondItem) && _submitOrderModel.coupounArray.count) {
                        cell.detailTextLabel.text = [NSString stringWithFormat:locationString(@"amount_yuan_decimal_plus"),[_submitOrderModel.orderPrepareModel.revenue doubleValue],[self revenueAndAdditional]];
                    }else
                    {
                        cell.detailTextLabel.text = [NSString stringWithFormat:locationString(@"amount_yuan_decimal"),[_submitOrderModel.orderPrepareModel.revenue doubleValue]];
                    }
                }
            }
        }
        else if (indexPath.row == 2)
        {
            cell.textLabel.text = locationString(@"due_date");
            cell.detailTextLabel.text = _submitOrderModel.orderPrepareModel.productExpireDate;
        }
        else if (indexPath.row == 3)
        {
            NSString * birdCoin = [NSString stringWithFormat:@"%.2f", _submitOrderModel.orderPrepareModel.birdCoin];
            cell.textLabel.text =[NSString stringWithFormat:locationString(@"use_bird_money"),birdCoin,birdCoin];
            UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
            [switchview setOn:_isSwitch animated:NO];
            if (_isPurchaseOnce) {
                [self updateSwitchAtIndexPath:switchview];
            }
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
                if (_submitOrderModel.coupounArray.count ==1 ) {
                    cell.financiaCouponModel = _submitOrderModel.coupounArray[_index];
                }
                else if (_submitOrderModel.coupounArray.count > 1)
                {
                    if (indexPath.row > 1) {
                        return nil;
                    }
                    cell.financiaCouponModel = _submitOrderModel.coupounArray[indexPath.row];
                }
                
                UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:(indexPath.row == 0 ? _selectFirstItem : _selectSecondItem) ? @"icon_selected" : @"icon_choice"]];
                imageView.frame = CGRectMake(0, 0, 22, 22);
                cell.accessoryView = imageView;
            }else
            {
                //点击其他理财金券
                cell.financiaCouponModel = _submitOrderModel.coupounArray[_index];
                UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:_selectFirstItem ? @"icon_selected": @"icon_choice"]];
                imageView.frame = CGRectMake(0, 0, 22, 22);
                cell.accessoryView = imageView;
            }
        }
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 48;
            break;
        case 1:
            return 96;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 20;
    }
    if([_submitOrderModel.orderPrepareModel.productType isEqualToString:@"XSB"])
    {
        return 0;
    }
    return 48;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
//        return [TableViewDevider getNoTopLineView];
        return [TableViewDevider singleLine];
    }
     else if (section == 1) {
         
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, 0, kScreenWidth, 48);
        view.backgroundColor = COLORWITHRGB(247, 247, 247);
        UILabel *lblTitle = [[UILabel alloc] init];

        [view addSubview:lblTitle];
        lblTitle.frame = CGRectMake(10, 0, kScreenWidth/2, 48);
        lblTitle.font = [UIFont systemFontOfSize:13];
         lblTitle.textColor = [UIColor colorWithHexString:@"#8a8a8a"];
         if([_submitOrderModel.orderPrepareModel.productType isEqualToString:@"TYB"])
         {
             lblTitle.text = locationString(@"text_usable_money_volume");
         }
         else
         {
             lblTitle.text = locationString(@"text_choose_money_volume");
             UIButton *otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
             otherButton.frame = CGRectMake(kScreenWidth - 150, 0, 150, 48);
             [otherButton setTitle:locationString(@"choose_other_coupon") forState:UIControlStateNormal];
             otherButton.titleLabel.font = [UIFont systemFontOfSize:13];
             [otherButton setTitleColor:[UIColor colorWithHexString:@"#0090ff"] forState:UIControlStateNormal];
             if(_submitOrderModel.coupounArray.count > 2)
             {
             [view addSubview:otherButton];
             }
             [otherButton addTarget:self action:@selector(otherCouponClick:) forControlEvents:UIControlEventTouchUpInside];
             
         }
       
         UIView* devider1 = [[UIView alloc]init];
         devider1.backgroundColor = DEVIDE_LINE_COLOR;
         [view addSubview:devider1];
         
         [devider1 mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.left.right.equalTo(view);
             make.height.equalTo(@0.5);
         }];
         
         UIView* devider2 = [[UIView alloc]init];
         devider2.backgroundColor = DEVIDE_LINE_COLOR;
         [view addSubview:devider2];
         
         [devider2 mas_makeConstraints:^(MASConstraintMaker *make) {
             make.bottom.left.right.equalTo(view);
             make.height.equalTo(@0.5);
         }];

        return view;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
  
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    if (indexPath.section == 1) {
        if (_otherCouponIdSelectedIndex < 0 ) {
            if(indexPath.row == 0) {
                if (_selectSecondItem) {
                    _selectFirstItem = !_selectFirstItem;
                    _selectSecondItem = !_selectSecondItem;
                }else
                {
                    _selectFirstItem = !_selectFirstItem;
                }
                [tableView reloadData];
            }
            else if (indexPath.row == 1)
            {
                if (_selectFirstItem) {
                    _selectSecondItem = !_selectSecondItem;
                    _selectFirstItem = !_selectFirstItem;
                    
                }else
                {
                    _selectSecondItem = !_selectSecondItem;
                }
                if(_selectSecondItem)
                {
                    _index = indexPath.row;
                }
                else
                {
                    _index = NSIntegerMin;
                }
                
                [tableView reloadData];
                
            }

        }else
        {
            _selectFirstItem = !_selectFirstItem;
             [tableView reloadData];
        }
        [self updatePayButtonStatus];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

#pragma 底部实付与确认

- (void)setUpFooterView {
    
    _current_account_title2Label.text = locationString(@"current_account_title2");
    [_invest_agreement_Button setTitle:locationString(@"invest_agreement") forState:UIControlStateNormal];

    
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - StatusBarHeight - NavigationBarHeight - kScreenWidth * 48 / 320.0, kScreenWidth, kScreenWidth * 48 / 320.0)];
    [_footerView addSubview:_payButtonView];
    _realPayAmout = [_investAmount doubleValue];
    _payButtonView.payLabel.text =[NSString stringWithFormat:locationString(@"amount_reality_pay"), _realPayAmout];
    [self.view addSubview:_footerView];
}


#pragma 订单支付跳转
-(void)payClick:(id)sender
{
    [self.view endEditing:YES];
    [self showWaitingIcon];
    __weak typeof(self) weakself = self;

    FinanciaCouponModel  *financiaCouponModel = [[FinanciaCouponModel alloc]init];
    if (_submitOrderModel.coupounArray.count > 2) {
        if (_index >= 0) {
            financiaCouponModel = _submitOrderModel.coupounArray[_index];
             }
        } else if (_submitOrderModel.coupounArray.count == 1) {
        if (_selectFirstItem) {
            financiaCouponModel = _submitOrderModel.coupounArray[_index];
        }
    } else if (_submitOrderModel.coupounArray.count == 2) {
        if (_selectFirstItem) {
            if (_otherCouponIdSelectedIndex < 0) {
                financiaCouponModel = _submitOrderModel.coupounArray[0];
            }else
            {
                financiaCouponModel = _submitOrderModel.coupounArray[_index];
            }
        }
        if (_selectSecondItem) {
            financiaCouponModel = _submitOrderModel.coupounArray[1];
        }
    }

    if ([_submitOrderModel.orderPrepareModel.productType isEqualToString:@"TYB"]) {
     
        userCouponId = [financiaCouponModel.userCouponId doubleValue];
        couponDes = financiaCouponModel.couponName;

        //体验标还是老样子
        [_submitOrderModel GET_ConfirmToBuyProductWithProductId:_productId andOrderAmount:10000 birdCoin:_coin userCouponId:userCouponId Success:^(BOOL isSuccess) {
            [weakself dismissWaitingIcon];
            if (isSuccess) {
                
                // 添加通知
                [[NSNotificationCenter defaultCenter] postNotificationName:kNeedToRefreshProducts object:nil];
                
                [_tableView reloadData];
                if([_submitOrderModel.orderPrepareModel.productType isEqualToString:@"TYB"])
                {
                    CustomizedBackWebViewController * baseWebViewController = [[CustomizedBackWebViewController alloc] initWithURL:kH5ProjectTransferUrl];
                    [self.navigationController pushViewController:baseWebViewController animated:YES];

                    return;
                }

                CustomizedBackWebViewController * baseWebViewController = [[CustomizedBackWebViewController alloc]initWithURL:_submitOrderModel.productBuyConfirmModel.url];
                [self.navigationController pushViewController:baseWebViewController animated:YES];
            }

        } failure:^(NSString *error) {
            [weakself dismissWaitingIcon];
            [LTNUtilsHelper boxShowWithMessage:error];
            
        }];

        return;

    } else if ([_submitOrderModel.orderPrepareModel.productType isEqualToString:@"XSB"]) {
        userCouponId = 0;
        couponDes = nil;
    } else {
        userCouponId = ( _selectFirstItem || _selectSecondItem  ? [financiaCouponModel.userCouponId doubleValue]:0);
        couponDes = ( _selectFirstItem || _selectSecondItem  ? financiaCouponModel.couponName:nil);
    }
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

/**
 *  是否使用鸟币按钮
 */
- (void)updateSwitchAtIndexPath:(id)sender {
    _isSwitch = !_isSwitch;
    UISwitch *switchView = (UISwitch *) sender;
    
    if (_isPurchaseOnce) {
        _isSwitch = YES;
        [switchView setOn:_isSwitch animated:NO];
        _isPurchaseOnce = NO;
    }
    
    if ([switchView isOn]) {
        _coin = _submitOrderModel.orderPrepareModel.birdCoin;
    } else {
        _coin = 0;
    }
    
    _realPayAmout = [_investAmount doubleValue] - _coin;
    _payButtonView.payLabel.text =[NSString stringWithFormat:locationString(@"amount_reality_pay"), _realPayAmout];
}

/**
 *  选择其他理财金券
 *
 *  @param button <#button description#>
 */
-(void)otherCouponClick:(UIButton *)button
{
    
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:_submitOrderModel.coupounArray.count];
    NSMutableArray *descArray = [NSMutableArray arrayWithCapacity:_submitOrderModel.coupounArray.count];
    NSMutableArray *itemSubTitlesArray = [NSMutableArray arrayWithCapacity:_submitOrderModel.coupounArray.count];
    for (FinanciaCouponModel  *financiaCouponModel in _submitOrderModel.coupounArray) {
        [itemArray addObject:[NSString stringWithFormat:@"%@", financiaCouponModel.couponName]];
        [descArray addObject:[NSString stringWithFormat:@"%@", financiaCouponModel.desc]];
        [itemSubTitlesArray addObject:[NSString stringWithFormat:locationString(@"choose_coupon_title"),financiaCouponModel.couponDate]];
    }
    
    
    [SGActionView showSheetWithTitle:locationString(@"choose_other_coupon")
                          itemTitles:itemArray
                          descTitles:descArray
                       itemSubTitles:itemSubTitlesArray
                       selectedIndex:_otherCouponIdSelectedIndex
                      selectedHandle:nil];



}

//#pragma KVO 响应
///**
// *  监听Checkbox的选中状态
// */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isSelected"]) {
        [self updatePayButtonStatus];
    }
    
}

- (void)updatePayButtonStatus {
    BOOL enable = NO;
    if (_checkBox.selected) {
        if([_submitOrderModel.orderPrepareModel.productType isEqualToString:@"TYB"]) {
            enable = _selectFirstItem;
        } else {
            enable = YES;
        }
    }

    if (enable) {
        _payButtonView.payButton.enabled = YES;
        _payButtonView.payButton.backgroundColor = [UIColor colorWithHexString:@"#ea5504"];
    } else {
        _payButtonView.payButton.enabled = NO;
        _payButtonView.payButton.backgroundColor = [UIColor grayColor];
    }
}

/**
 *   移除对checkbox的状态的监听
 */
- (void)dealloc {
    
    [_checkBox removeObserver:self forKeyPath:@"isSelected"];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATION_SELECTED_CHANGED object:nil];
}

/**
 *  收益信托协议
 *
 */
- (IBAction)agreementClick:(id)sender {
    //TODO: use url from server side
    BaseWebViewController *baseWebViewController = [[BaseWebViewController alloc] initWithURL:kH5ProfitUrl];
    [self.navigationController pushViewController:baseWebViewController animated:YES];
 
}

//刷新理财金券
-(void)refreshCopouns:(NSNotification *)text
{
    _index = [text.userInfo[@"index"] integerValue];
    _otherCouponIdSelectedIndex = [text.userInfo[@"index"] integerValue];
    _selectFirstItem = YES;
    _selectSecondItem = NO;
    //[_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    [_tableView reloadData];
}

//购买预览页
- (void)gotoSummaryPage {
    [self dismissWaitingIcon];
    
    InvestSummaryViewController *vc = [[InvestSummaryViewController alloc] initOrderDataProductId:_productId
                                                                                ProductExpireDate:_submitOrderModel.orderPrepareModel.productExpireDate
                                                                                     InvestAmount:[_submitOrderModel.orderPrepareModel.productType isEqualToString:@"TYB"]?10000:[_investAmount doubleValue]
                                                                                       waitProfit:[self getWaitProfit]
                                                                                         birdCoin:_coin
                                                                                        couponDes:couponDes
                                                      realPayAmout:_realPayAmout
                                                      userCouponId:userCouponId];
    [self.navigationController pushViewController:vc animated:YES];
}


/**
 *
 *  @return 收益应该有多少
 */
- (double)revenueAndAdditional
{
    double additional;
    FinanciaCouponModel  *financiaCouponModel = [[FinanciaCouponModel alloc]init];
    if (_submitOrderModel.coupounArray.count) {
     
    if (_otherCouponIdSelectedIndex > 0) {
        
        financiaCouponModel = _submitOrderModel.coupounArray[_otherCouponIdSelectedIndex];
        
        }else{
            
        financiaCouponModel = _submitOrderModel.coupounArray[_selectFirstItem ? 0:1];
            
        }
    }
        if([financiaCouponModel.couponTypeDes isEqualToString:@"FXQ"])
    {
        additional = [financiaCouponModel.amount doubleValue];
        
    }else if([financiaCouponModel.couponTypeDes isEqualToString:@"JXQ"])
    {
        additional = [financiaCouponModel.amount doubleValue] * [_submitOrderModel.orderPrepareModel.revenue doubleValue] * 0.01;
    }else
    {
        additional = 0.00;
    }
    return additional;

}

/**
 *
 *  @return 传到确认投资界面的最终字符串的样子
 */
- (NSString *)getWaitProfit
{
    NSString *waitProfit;
    
    if ([_submitOrderModel.orderPrepareModel.productType isEqualToString:@"TYB"]) {
        waitProfit = [NSString stringWithFormat:@"%.2f%@",[_submitOrderModel.orderPrepareModel.revenue doubleValue], locationString(@"bird_coin")];
    }else
    {
         if ([_submitOrderModel.orderPrepareModel.productType isEqualToString:@"XSB"])
         {
            waitProfit = [NSString stringWithFormat:locationString(@"amount_yuan_decimal"),[_submitOrderModel.orderPrepareModel.revenue doubleValue]];
         }else
         {    
                if((_selectFirstItem || _selectSecondItem) &&  _submitOrderModel.coupounArray.count) {
                    waitProfit = [NSString stringWithFormat:locationString(@"amount_yuan_decimal_plus"),[_submitOrderModel.orderPrepareModel.revenue doubleValue],[self revenueAndAdditional]];
                }else
                {
                    waitProfit = [NSString stringWithFormat:locationString(@"amount_yuan_decimal"),[_submitOrderModel.orderPrepareModel.revenue doubleValue]];
                }
         }
    }
    return waitProfit;
}



@end
