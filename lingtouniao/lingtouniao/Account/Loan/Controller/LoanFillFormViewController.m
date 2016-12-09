//
//  LoanFillFormViewController.m
//  lingtouniao
//
//  Created by zhangtongke on 16/3/31.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LoanFillFormViewController.h"
#import "TextfieldCell.h"
#import "SingleActionSheetPicker.h"
#import "LoanData.h"

#import "LTNLoanProgressController.h"

//#import "UIControl+TapSingle.h"


@interface LoanFillFormViewController ()
@property (nonatomic,strong)NSMutableDictionary *loanDic;
@property (nonatomic)BOOL submitting;
@end

@implementation LoanFillFormViewController

+(instancetype)loanFillFormViewController:(NSDictionary *)loanTypeDic{
    LoanFillFormViewController *controller=[[LoanFillFormViewController alloc] init];
    controller.loanTypeDic=loanTypeDic;
    return controller;
    
}

- (void)viewDidLoad {
    self.isTableViewStyleGrouped = YES;
    self.hideRefreshHeader = YES;

    [super viewDidLoad];
    
    self.title=_loanTypeDic[@"title"];
    [self.tableView registerClass:[TextfieldCell class] forCellReuseIdentifier:@"TextfieldCell"];
    _loanDic=[NSMutableDictionary dictionary];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor=[UIColor colorWithHexString:@"#f3f5f7"];
    
    
    UIView *footerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, DimensionBaseIphone6(30)*2+kGeneralHeight)];
    footerView.backgroundColor=[UIColor clearColor];
    
    // 登录按钮
    UIButton * submitButton = [[UIButton alloc] initWithFrame:CGRectMake(kHorizontalMargin, DimensionBaseIphone6(30), self.view.width-kHorizontalMargin*2, kGeneralHeight)];
    submitButton.layer.cornerRadius = 5;
    submitButton.layer.masksToBounds = YES;
    [submitButton setTitle:locationString(@"load_details_submit_tv") forState:UIControlStateNormal];
    [submitButton setDisenableBackgroundColor:kDisabledColor enableBackgroundColor:COLOR_MAIN];
//    [submitButton setBackgroundImage:[UIImage imageWithColor:COLOR_MAIN size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:submitButton];
    
    self.tableView.tableFooterView=footerView;
    
    
    [self initData];
    
//    [CurrentUser mine].userInfo.userName=@"张同柯";
//    [CurrentUser mine].userInfo.cardId=@"410426198312220511";
//    [CurrentUser mine].userInfo.mobile=@"1582158708";
    
    [_loanDic setObject:_loanTypeDic[@"type"] forKey:@"loan_type"];
    [_loanDic setObject:[CurrentUser mine].userInfo.userName forKey:@"intent_username"];
    [_loanDic setObject:[[CurrentUser mine].userInfo sex] forKey:@"sex"];
    [_loanDic setObject:[CurrentUser mine].userInfo.cardId forKey:@"pspt_no"];
    [_loanDic setObject:[CurrentUser mine].userInfo.mobile forKey:@"mobile_phone"];
    if([_loanTypeDic[@"type"] isEqualToString:@"1"]||[_loanTypeDic[@"type"] isEqualToString:@"5"])
        [_loanDic setObject:@"0021" forKey:@"intent_area"];
        
    
    // Do any additional setup after loading the view.
}


/*
 
 {
 "borrow_amount" = "100-200\U4e07";
 email = Mamg;
 "house_advance" = 12;
 "intent_username" = "\U5f20\U540c\U67ef";
 "intent_area" = 0021;
 "loan_type" = 2;
 "mediation_name" = Rete;
 "mobile_phone" = 15821587076;
 "pspt_no" = 410426198312220511;
 sex = 0;
 }

 */
-(void)submitAction:(UIButton *)sender{
    
    if(_submitting)
        return;
    
    _submitting=YES;
    
    NSLog(@"submitAction");
    
    NSLog(@"_loanDic==%@",_loanDic);
    
    if([_loanDic[@"intent_area"] length]==0){
        [LTNUtilsHelper boxShowWithMessage:locationString(@"selected_city") duration:2.0f];
        _submitting=NO;
        return;
    }
    
    if(![StringUtil isTelphoneNum:_loanDic[@"mobile_phone"]]){
        [LTNUtilsHelper boxShowWithMessage:locationString(@"mobile_corrected") duration:2.0f];
        _submitting=NO;
        return;
    }
    
    if([_loanDic[@"borrow_amount"] length]==0){
        [LTNUtilsHelper boxShowWithMessage:locationString(@"loan_money") duration:2.0f];
        _submitting=NO;
        return;
    }
    
    if([_loanDic[@"house_advance"] length]==0){
        [LTNUtilsHelper boxShowWithMessage:locationString(@"load_details_total_price_hint") duration:2.0f];
        _submitting=NO;
        return;
    }else if(esInteger(_loanDic[@"house_advance"])==0){
        [LTNUtilsHelper boxShowWithMessage:locationString(@"house_currect_money") duration:2.0f];
        _submitting=NO;
        return;
    }
    
    
    if([_loanDic[@"mediation_name"] length]==0){
        [LTNUtilsHelper boxShowWithMessage:locationString(@"load_details_broker_hint") duration:2.0f];
        _submitting=NO;
        return;
    }
    if([_loanDic[@"email"] length]==0){
        [LTNUtilsHelper boxShowWithMessage:locationString(@"input_email") duration:2.0f];
        _submitting=NO;
        return;
    }else if(![StringUtil validateEmail:_loanDic[@"email"]]){
        [LTNUtilsHelper boxShowWithMessage:locationString(@"email_correct_address") duration:2.0f];
        _submitting=NO;
        return;
    }
    
    
    NSRange range=[_loanDic[@"house_advance"] rangeOfString:locationString(@"unit")];
    if(range.location == NSNotFound){
        _loanDic[@"house_advance"]=[NSString stringWithFormat:locationString(@"money_unit"),_loanDic[@"house_advance"]];
    }
    
    sender.enabled = NO;
    kWeakSelf
    [BaseDataEngine apiForPath:kRequestLoan method:kPostMethod parameter:_loanDic responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        sender.enabled = YES;
        if (!error) {
            [LTNUtilsHelper boxShowWithMessage:locationString(@"waitting_patience") duration:2.0f];
            [weakSelf jumpToLoanProgress];
   
        }
        weakSelf.submitting = NO;
    }];
    
    
}

-(void)jumpToLoanProgress{
    
    LTNLoanProgressController *controller=[[LTNLoanProgressController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];

}

-(void)initData{
    NSArray *array=@[
                @{@"title":locationString(@"load_details_realname_tv"),
                  @"key":@"intent_username",
                  @"canEdit":@(NO),
                  @"showAccess":@(NO),
                  @"placeholder":@"",
                  @"maxLength":@(100),
                  },
                @{@"title":locationString(@"load_details_sex_tv"),
                  @"key":@"sex",
                  @"canEdit":@(NO),
                  @"showAccess":@(NO),
                  @"placeholder":@"",
                  @"maxLength":@(100),
                  },
                @{@"title":locationString(@"load_details_idcard_tv"),
                  @"key":@"pspt_no",
                  @"canEdit":@(NO),
                  @"showAccess":@(NO),
                  @"placeholder":@"",
                  @"maxLength":@(100),
                  },
                @{@"title":locationString(@"load_details_city_tv"),
                  @"key":@"intent_area",
                  @"canEdit":@(NO),
                  @"showAccess":@(YES),
                  @"placeholder":locationString(@"select_belong_city"),
                  @"maxLength":@(100),
                  },
                @{@"title":locationString(@"mobile_num"),
                  @"key":@"mobile_phone",
                  @"canEdit":@(YES),
                  @"showAccess":@(NO),
                  @"placeholder":@"",
                  @"maxLength":@(11),
                  },
                @{@"title":locationString(@"load_details_loan_account_tv"),
                  @"key":@"borrow_amount",
                  @"canEdit":@(NO),
                  @"showAccess":@(YES),
                  @"placeholder":locationString(@"loan_money"),
                  @"maxLength":@(100),
                  },
                @{@"title":locationString(@"load_details_total_price_tv"),
                  @"key":@"house_advance",
                  @"canEdit":@(YES),
                  @"showAccess":@(NO),
                  @"placeholder":locationString(@"load_details_total_price_hint"),
                  @"maxLength":@(8),
                  },
                @{@"title":locationString(@"load_details_broker_tv"),
                  @"key":@"mediation_name",
                  @"canEdit":@(YES),
                  @"showAccess":@(NO),
                  @"placeholder":locationString(@"load_details_broker_hint"),
                  @"maxLength":@(50),
                  },
                @{@"title":locationString(@"load_details_email_tv"),
                  @"key":@"email",
                  @"canEdit":@(YES),
                  @"showAccess":@(NO),
                  @"placeholder":locationString(@"input_email"),
                  @"maxLength":@(30),
                  },
                
                ];
    
    [self.data addObjectsFromArray:array];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 15.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 1.0;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TextfieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextfieldCell"];
 
    NSDictionary *dic=self.data[indexPath.row];
    
    NSString *contentText=_loanDic[dic[@"key"]];
    if([dic[@"key"] isEqualToString:@"sex"]){
        contentText=SexTitle((Sex)esInteger(_loanDic[dic[@"key"]]));
    }else if([dic[@"key"] isEqualToString:@"intent_area"]){
        contentText=CityName(_loanDic[dic[@"key"]]);
    }else if([dic[@"key"] isEqualToString:@"intent_username"]){
        contentText=[StringUtil starsReplacedOfString:_loanDic[dic[@"key"]] withinRange:NSMakeRange(1, 1)];
    }else if([dic[@"key"] isEqualToString:@"pspt_no"]){
        contentText=[StringUtil starsReplacedOfString:_loanDic[dic[@"key"]] withinRange:NSMakeRange(3, [_loanDic[dic[@"key"]] length]-6)];
    }
    cell.textField.text=contentText;
    cell.cellDic=dic;
    cell.textFieldTextChangeBlock=^(NSString *text){
        _loanDic[dic[@"key"]]=text;
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic=self.data[indexPath.row];
    if([dic[@"key"] isEqualToString:@"intent_area"]){
        ESWeakSelf;
        [SingleActionSheetPicker showWithTitle:dic[@"title"]                                       selectArray:LoanCitys(_loanTypeDic[@"type"])
                            initialSelectedDic:@{@"key":esString(_loanDic[dic[@"key"]])}
                                          done:^(RootActionSheetPicker *picker, NSDictionary *selectedDic) {
                                              //
                                              ESStrongSelf;
                                              [_self.loanDic setObject:selectedDic[@"key"] forKey:dic[@"key"]];
                                              [_self.tableView reloadData];
                                              
                                          }
                                        origin:self.view];

        
    }else if([dic[@"key"] isEqualToString:@"borrow_amount"]){
        ESWeakSelf;
        [SingleActionSheetPicker showWithTitle:dic[@"title"]                                       selectArray:LoanAmountsList(_loanTypeDic[@"type"])
                            initialSelectedDic:@{@"key":esString(_loanDic[dic[@"key"]])}
                                          done:^(RootActionSheetPicker *picker, NSDictionary *selectedDic) {
                                              //
                                              ESStrongSelf;
                                              [_self.loanDic setObject:selectedDic[@"key"] forKey:dic[@"key"]];
                                              [_self.tableView reloadData];
                                              
                                          }
                                        origin:self.view];

    }
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
