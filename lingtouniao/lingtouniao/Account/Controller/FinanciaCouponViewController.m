//
//  FinanciaCouponViewController.m
//  lingtouniao
//
//  Created by 徐凯 on 15/12/18.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "FinanciaCouponViewController.h"
#import "FinancialModel.h"
#import "FinancialCouponCell.h"
#import "MJRefresh.h"
#import "LTNUtilsHelper.h"
#import "CurrentUser.h"
#import "DonateAlertView.h"

#import "FinancialIntroduceViewController.h"


@interface FinanciaCouponViewController ()<copyButtonClickDelegate>
{
    
    FinancialModel *_financialModel;//理财金券
    UITableViewRowAction *donateRowAction;
}
@property (nonatomic) UITextField *textFiled;

@property (nonatomic) UIButton *btn;

@property (nonatomic) DonateAlertView *donateAlertView;

@property (nonatomic) NSString *userFincalId,*presentCodeStr,*isGiveStr;//金券ID,赠送券码,是否赠送
@property (nonatomic) NSString *couponNameStr,*fincalDescStr,*couponDateStr;//金券金额，金券描述，金券有效期

@end

@implementation FinanciaCouponViewController

- (void)back{
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSNumber *hadShowed = [[NSUserDefaults standardUserDefaults] valueForKey:@"HadShowFinancialIntroduceView"];
    if(![hadShowed boolValue]){
        [FinancialIntroduceViewController showFinancialIntroduceViewController:^{
            
        }];
        [[NSUserDefaults standardUserDefaults] setValue:@YES forKey:@"HadShowFinancialIntroduceView"];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self pullReload];
    self.tableView.backgroundColor= [UIColor colorWithHexString:@"#EFEFF4"];
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth , DimensionBaseIphone6(49))];
    
    _textFiled = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - DimensionBaseIphone6(140), DimensionBaseIphone6(49))];
    _textFiled.placeholder = locationString(@"input_coupon_exchange_code");
    _textFiled.backgroundColor = [UIColor whiteColor];
    _textFiled.leftView = [[UIView alloc]initWithFrame:CGRectMake(0,0,15,DimensionBaseIphone6(49))];
    _textFiled.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, _textFiled.top, kScreenWidth - DimensionBaseIphone6(140), 0.5)];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    
    UIView *lineViwe2  =[[UIView alloc]initWithFrame:CGRectMake(0, _textFiled.bottom, kScreenWidth - DimensionBaseIphone6(140), 0.5)];
    lineViwe2.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    
    [self.tableView.tableHeaderView addSubview:_textFiled];
    [self.tableView.tableHeaderView addSubview:lineView1];
    [self.tableView.tableHeaderView addSubview:lineViwe2];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(_textFiled.right, _textFiled.top, DimensionBaseIphone6(140), DimensionBaseIphone6(49))];
    [btn setTitle:locationString(@"exchange") forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithHexString:@"#ea5504"];
    btn.titleLabel.font = [CustomerizedFont heiti:18];
    [btn addTarget:self action:@selector(couponTicket) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView.tableHeaderView addSubview:btn];
    self.btn = btn;
    
    
}

- (void)couponTicket{
    [self.view endEditing:YES];
    
    if (_textFiled.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:locationString(@"hint") message:locationString(@"input_coupon_exchange_code") delegate:nil cancelButtonTitle:locationString(@"btn_confirm") otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [self showWaitingIcon];
    kWeakSelf;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"sessionid":[[CurrentUser mine] sessionKey],@"code":_textFiled.text}];
    
    [BaseDataEngine apiForPath:kExchangeCode method:kGetMethod parameter:dic responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        [weakSelf dismissWaitingIcon];
        
        if (!error) {
            
//            if (data[@"coupon"] && isDictionary(data[@"coupon"])) {
//                NSDictionary * dic = data[@"coupon"];
//                FinanciaCouponModel * finaciaCoupon = [FinanciaCouponModel mj_objectWithKeyValues:dic];
//                
//                [self.data insertObject:finaciaCoupon atIndex:0];
//                [_tableView reloadData];
//            }
            
            NSArray * coupons = [FinanciaCouponModel mj_objectArrayWithKeyValuesArray:data[@"coupons"]];
            for (id coupon in coupons) {
                [self.data insertObject:coupon atIndex:0];
            }

//            [self.data insertObject:coupons.firstObject atIndex:0];
           
            [_tableView reloadData];
            
            NSString * message = [NSString stringWithFormat:@"%@",[data valueForKey:@"detail"]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:locationString(@"coupon_exchang_success") message:message delegate:nil cancelButtonTitle:locationString(@"btn_confirm") otherButtonTitles:nil, nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                _textFiled.text = @"";
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshAccountInfo];
            }];
        }
        
        
    }];
    
}


-(void)initViewModelBinding
{
  _financialModel = [[FinancialModel alloc]init];

}

-(void)initUIView
{
    self.navigationItem.title = locationString(@"text_money_volume");
    self.view.backgroundColor= [UIColor colorWithHexString:@"#EFEFF4"];
}

- (void)getServiceData:(BOOL)isGetMore {
    [super getServiceData:isGetMore];
    kWeakSelf
    [self apiForPath:kUserCouponUrl method:kPostMethod parameter:nil responseModelClass:[FinancialModel class] onComplete:^(id response, id data, NSError *error) {
          _financialModel = (FinancialModel *)data;
        if ([_financialModel isKindOfClass:[FinancialModel class]]) {
            [weakSelf.data addObjectsFromArray:_financialModel.coupons];
        }
    }];
    
}
#pragma mark - tableViewDalegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *FINANCIAL_COUPON_CELL = @"FinancialCouponCell";
    
    FinancialCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:FINANCIAL_COUPON_CELL];
    
    if (cell == nil) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:FINANCIAL_COUPON_CELL owner:self options:nil] lastObject];
        cell = [[FinancialCouponCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FINANCIAL_COUPON_CELL];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
    }
    cell.financialCouponModel = self.data[indexPath.section];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 110;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.data.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIImage *)iconImageWhenDataEmpty{
    return [UIImage imageNamed:@"icon_nothing_ticket"];
}

- (NSString *)tipsMessageWhenDataEmpty{
    return locationString(@"coupon_empty_title");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView setEditing:NO animated:YES];
}


-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    FinancialCouponCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //理财金券id,金券金额，金券满额，金券有效期,是否赠送
    self.userFincalId = cell.financialCouponModel.userCouponId;
    self.couponNameStr = cell.financialCouponModel.couponName;
    self.fincalDescStr = cell.financialCouponModel.desc;
    self.couponDateStr = cell.financialCouponModel.couponDate;
    self.isGiveStr = cell.financialCouponModel.isGive;//1 可送 2 不可送
    
    donateRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:locationString(@"donate") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if ([cell.financialCouponModel.isGive isEqualToString:@"2"]) {
            return ;
        }
        [self donateFincalCode];
        
    }];
    if ([cell.financialCouponModel.isGive isEqualToString:@"2"]) {
        donateRowAction.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    }else{
        donateRowAction.backgroundColor = [UIColor colorWithHexString:@"#4a90e2"];
    }

    
    return @[donateRowAction];
}

-(void)donateFincalCode{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"userCouponId":self.userFincalId}];
    [BaseDataEngine apiForPath:kPresentCode method:kGetMethod parameter:dic responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        if (!error) {

            self.presentCodeStr =esString(data[@"presentCode"]);
            self.donateAlertView = [[DonateAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            self.donateAlertView.delegate = self;
            self.donateAlertView.messageLabel.text = [NSString stringWithFormat:locationString(@"donteCodeDetail"),self.presentCodeStr];
            [self.donateAlertView.messageLabel addAttributes:@{NSFontAttributeName:[CustomerizedFont heiti:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"]} forString:locationString(@"donateCode")];
            self.donateAlertView.detailLabel.text = locationString(@"detailDonate");
            self.donateAlertView.iconView.hidden = YES;
            self.donateAlertView.succeessLabel.hidden = YES;
            self.donateAlertView.backgroundColor = [UIColor colorWithRed:10.f/255 green:10.f/255 blue:10.f/255 alpha:0.4];
            [[UIApplication sharedApplication].keyWindow addSubview:self.donateAlertView];
        }
        
    }];

}
-(void)ButtonDidCilcked:(UIButton *)btn{
    
    if (btn.tag == 1) {
        NSString *str = [NSString stringWithFormat:locationString(@"donateCopyContent"),self.couponNameStr,self.fincalDescStr,self.presentCodeStr,self.couponDateStr];
        
        [UIPasteboard generalPasteboard].string =str;
        
        self.donateAlertView = [[DonateAlertView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        self.donateAlertView.messageLabel.hidden = YES;
        self.donateAlertView.succeessLabel.text = locationString(@"donateSuccess");
        self.donateAlertView.detailLabel.text = locationString(@"donateShare");
        self.donateAlertView.backgroundColor = [UIColor colorWithRed:10.f/255 green:10.f/255 blue:10.f/255 alpha:0.4];
        self.donateAlertView.confirmButton.hidden = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:self.donateAlertView];
    }
    [self.tableView reloadData];
    

    
}


@end
