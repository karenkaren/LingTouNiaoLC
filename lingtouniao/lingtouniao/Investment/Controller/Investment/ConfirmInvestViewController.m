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

-(NSMutableArray *)coupounArray{
    if(!_coupounArray){
        _coupounArray=[NSMutableArray array];
    }
    return _coupounArray;
}

-(FinanciaCouponModel *)selectCoupon{
    if(_selectedIndex>=0&&[self.coupounArray count]>_selectedIndex)
        return (FinanciaCouponModel *)(self.coupounArray[_selectedIndex]);
    return nil;
}

-(NSString *)selectPresentCode{
    
    FinanciaCouponModel *financiaCouponModel=[self selectCoupon];
    if(financiaCouponModel)
        return financiaCouponModel.presentCode;
    else
        return @"";
    
}
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
    [super initViewModelBinding];
    _submitOrderModel = [[SubmitOrderModel alloc]init];
}

-(void)initUIView
{
    [super initUIView];
    self.navigationItem.title = locationString(@"confirm_buy");
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshCopouns:) name:Notification_Select_Coupon object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(exchangeCopoun:) name:Exchange_copoun object:nil];
    
    
    [_checkBox addObserver:self forKeyPath:@"isSelected" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    _checkBox.isSelected = true;
    
    _selectedIndex = 0;
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
           
           __strong typeof(self) strongSelf =weakself;
           if(strongSelf){
               [strongSelf dismissWaitingIcon];
               [strongSelf.coupounArray removeAllObjects];
               [strongSelf.coupounArray addObjectsFromArray:strongSelf.coupounsBefore];
               [strongSelf.coupounArray addObjectsFromArray:strongSelf.submitOrderModel.coupounArray];
               
               [weakTableView reloadData];
               [strongSelf updatePayButtonStatus];
               
           }
           
       }
   } failure:^(NSString *error) {
       __strong typeof(self) strongSelf =weakself;
       if(strongSelf)
       [strongSelf dismissWaitingIcon];
       
   }];
    
}


#pragma TableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    
    if([_submitOrderModel.orderPrepareModel.productType isEqualToString:@"XSB"])
        return 1;
    else{
        if(self.useCouponTag)
            return 2;
        return 1;
    }
    
//    return _submitOrderModel.coupounArray.count== 0 || [_submitOrderModel.orderPrepareModel.productType isEqualToString:@"XSB"]? 1:2;
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
            case 0:{
                if(self.useBirdCoinTag){
                    return _submitOrderModel.orderPrepareModel.birdCoin == 0 ? 3 : 4;
                }else{
                    return 3;
                }
                break;
 
            }
                
            case 1:
                return  _otherCouponIdSelectedIndex>=0 ? 1:[self getCoupounCount:self.coupounArray.count];
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
            cell.detailTextLabel.text = [NSString stringWithFormat:locationString(@"amount_yuan_text"),_investAmount];
            
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
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f%@",_submitOrderModel.orderPrepareModel.revenue, locationString(@"bird_coin")];
                
            }else
            {
                if ([_submitOrderModel.orderPrepareModel.productType isEqualToString:@"XSB"])
                {
                    cell.detailTextLabel.text = [NSString stringWithFormat:locationString(@"amount_yuan_decimal"), _submitOrderModel.orderPrepareModel.revenue];
                }else
                {
                    
                    if([self selectCoupon]) {
                        cell.detailTextLabel.text = [NSString stringWithFormat:locationString(@"amount_yuan_decimal_plus"),_submitOrderModel.orderPrepareModel.revenue,[self revenueAndAdditional]];
                    }else
                    {
                        cell.detailTextLabel.text = [NSString stringWithFormat:locationString(@"amount_yuan_decimal"),_submitOrderModel.orderPrepareModel.revenue];
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
                cell.financiaCouponModel = self.coupounArray[indexPath.row];
                
                UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:(indexPath.row==_selectedIndex) ? @"icon_selected" : @"icon_choice"]];
                imageView.frame = CGRectMake(0, 0, 22, 22);
                cell.accessoryView = imageView;
            }else
            {
                //点击其他理财金券
                cell.financiaCouponModel = self.coupounArray[_otherCouponIdSelectedIndex];
                
                UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:(_selectedIndex>=0) ? @"icon_selected" : @"icon_choice"]];
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
             
             
             NSString *otherCoupounString;
             
             if([self.coupounArray count]>0){
                lblTitle.text = locationString(@"text_choose_money_volume");
                 otherCoupounString=locationString(@"choose_other_coupon");
             }else{
                 lblTitle.text = @"";
                 otherCoupounString=locationString(@"have_coupon_code");
             }
             
             UIButton *otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
             otherButton.frame = CGRectMake(kScreenWidth - 150, 0, 150, 48);
             [otherButton setTitle:otherCoupounString
                          forState:UIControlStateNormal];
             otherButton.titleLabel.font = [UIFont systemFontOfSize:13];
             [otherButton setTitleColor:[UIColor colorWithHexString:@"#0090ff"] forState:UIControlStateNormal];
             otherButton.right=kScreenWidth-15.0f;
             otherButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
             
             
             [view addSubview:otherButton];
             
             [otherButton addTarget:self action:@selector(otherCouponClick:) forControlEvents:UIControlEventTouchUpInside];
             
         }
       
         UIView* devider1 = [[UIView alloc]init];
         devider1.backgroundColor = DEVIDE_LINE_COLOR;
         [view addSubview:devider1];
         
         [devider1 mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.left.right.equalTo(view);
             make.height.equalTo(@0.5);
         }];
         
         if([self.coupounArray count]>0){
             UIView* devider2 = [[UIView alloc]init];
             devider2.backgroundColor = DEVIDE_LINE_COLOR;
             [view addSubview:devider2];
             
             [devider2 mas_makeConstraints:^(MASConstraintMaker *make) {
                 make.bottom.left.right.equalTo(view);
                 make.height.equalTo(@0.5);
             }];

             
         }
             
         
        return view;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
  
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    if (indexPath.section == 1) {
        
        if(_otherCouponIdSelectedIndex>=0){
            if(_selectedIndex>=0)
                _selectedIndex=NSIntegerMin;
            else
                _selectedIndex=_otherCouponIdSelectedIndex;
            
        }else{
            if(indexPath.row==_selectedIndex)
                _selectedIndex=NSIntegerMin;
            else
                _selectedIndex=indexPath.row;
            
        }
        
        
        [tableView reloadData];
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

    
    /*
    [_invest_agreement_Button addTarget:self action:@selector(agreementClick:) forControlEvents:UIControlEventTouchUpInside];
     */
    
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

    FinanciaCouponModel  *financiaCouponModel = [self selectCoupon];
    
    //体验标，固定金额 10000
    if ([_submitOrderModel.orderPrepareModel.productType isEqualToString:@"TYB"]) {
     
        userCouponId = [financiaCouponModel.userCouponId doubleValue];
        couponDes = financiaCouponModel.couponName;

        //体验标还是老样子
        [_submitOrderModel GET_ConfirmToBuyProductWithProductId:_productId andOrderAmount:[_investAmount doubleValue] birdCoin:_coin userCouponId:userCouponId Success:^(BOOL isSuccess) {
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
        
        //TODO: 为0的情况是否会有bug？
        userCouponId = ( _selectedIndex>=0  ? [financiaCouponModel.userCouponId doubleValue]:0);
        couponDes = ( _selectedIndex>=0  ? financiaCouponModel.couponName:nil);
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
                  isShowExchangeView:YES
                      selectedHandle:nil
     ];



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
            enable = [self selectCoupon] ? YES:NO;
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
    [[NSNotificationCenter defaultCenter]removeObserver:self name:Notification_Select_Coupon object:nil];
    
    
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

//兑换理财金券
-(void)exchangeCopoun:(NSNotification *)notification{
    ESWeakSelf
    
    NSDictionary *userDic=notification.userInfo;
    
    NSDictionary *dic=@{
                        @"presentCode":userDic[@"presentCode"],
                        @"productId":@(_productId),
                        @"orderAmount":esString(_investAmount),
                        };
    
    NSMutableDictionary *parameter=[NSMutableDictionary dictionaryWithDictionary:dic];
    
    [BaseDataEngine apiForPath:kPresentCoupon method:kPostMethod parameter:parameter responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        if (!error&& isDictionary(data)) {
            //TODO:success:
            ESStrongSelf
            NSMutableDictionary *copounDic=[NSMutableDictionary dictionaryWithDictionary:data];
            [copounDic setObject:userDic[@"presentCode"] forKey:@"presentCode"];
            if(_self){
                [_self addConpoun:copounDic];
                
            }
            
        }
    }];

}
//添加理财金券
-(void)addConpoun:(NSDictionary *)conpounDic{
    
    NSString *userCouponIdTemp= esString(conpounDic[@"userCouponId"]);
    
    for(FinanciaCouponModel *financiaCouponModel in self.coupounArray){
        if([esString(financiaCouponModel.userCouponId) isEqualToString:userCouponIdTemp]){
            [LTNUtilsHelper boxShowWithMessage:locationString(@"exist_coupon_code") duration:2.0f];
            return;
        }
    }
    
    FinanciaCouponModel *financiaCouponModel=[FinanciaCouponModel mj_objectWithKeyValues:conpounDic];
    [self.coupounArray insertObject:financiaCouponModel atIndex:0];
    _otherCouponIdSelectedIndex = 0;
    _selectedIndex=_otherCouponIdSelectedIndex;
    
    [_tableView reloadData];
    
    [self.coupounsBefore addObject:financiaCouponModel];
    [self otherCouponClick:nil];
        
}
//刷新理财金券
-(void)refreshCopouns:(NSNotification *)text
{
    
    _otherCouponIdSelectedIndex = [text.userInfo[@"index"] integerValue];
    _selectedIndex=_otherCouponIdSelectedIndex;
    //[_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    [_tableView reloadData];
}

//购买预览页 TODO:what?
- (void)gotoSummaryPage {
    [self dismissWaitingIcon];
    
    InvestSummaryViewController *vc = [[InvestSummaryViewController alloc] initOrderDataProductId:_productId
                                                                                ProductExpireDate:_submitOrderModel.orderPrepareModel.productExpireDate
                                                                                     InvestAmount:[_investAmount doubleValue]
                                                                                       waitProfit:[self getWaitProfit]
                                                                                         birdCoin:_coin
                                                                                        couponDes:couponDes
                                                      realPayAmout:_realPayAmout
                                                      userCouponId:userCouponId
                                                                                      presentCode:[self selectPresentCode]];
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
    if (self.coupounArray.count) {
     
        financiaCouponModel = [self selectCoupon];
        /*
    if (_otherCouponIdSelectedIndex >= 0) {
        
        //TODO:可以不用选择吗？
        financiaCouponModel = _submitOrderModel.coupounArray[_otherCouponIdSelectedIndex];
        
        }else{
            
        financiaCouponModel = [self selectCoupon];
            
        }*/
    }
        
        //TODO:为空的情况呢？
        if(financiaCouponModel){
            if([financiaCouponModel.couponTypeDes isEqualToString:@"FXQ"]){
                additional = [financiaCouponModel.amount doubleValue];
            }else if([financiaCouponModel.couponTypeDes isEqualToString:@"JXQ"]){
                additional = [financiaCouponModel.amount doubleValue] * _submitOrderModel.orderPrepareModel.revenue * 0.01;
            }else{
                additional = 0.00;
            }

            
        }else{
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
        waitProfit = [NSString stringWithFormat:@"%.2f%@",_submitOrderModel.orderPrepareModel.revenue, locationString(@"bird_coin")];
    }else
    {
         if ([_submitOrderModel.orderPrepareModel.productType isEqualToString:@"XSB"])
         {
            waitProfit = [NSString stringWithFormat:locationString(@"amount_yuan_decimal"),_submitOrderModel.orderPrepareModel.revenue];
         }else
         {    
                if([self selectCoupon]) {
                    waitProfit = [NSString stringWithFormat:locationString(@"amount_yuan_decimal_plus"),_submitOrderModel.orderPrepareModel.revenue,[self revenueAndAdditional]];
                }else
                {
                    waitProfit = [NSString stringWithFormat:locationString(@"amount_yuan_decimal"),_submitOrderModel.orderPrepareModel.revenue];
                }
         }
    }
    return waitProfit;
}



@end
