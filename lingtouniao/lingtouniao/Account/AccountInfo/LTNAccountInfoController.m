//
//  LTNAccountInfoController.m
//  lingtouniao
//
//  Created by  mathe on 15/12/23.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNAccountInfoController.h"
#import "LTNSupplyPartnerControllerViewController.h"
#import "VerifyRealNameViewController.h"
#import "BoundBankCardViewController.h"
#import "SecondBoundBandCardViewController.h"
#import "LTNRetrieveController.h"
#import "GesturePasswordController.h"
#import "LTNModifyTradePasswordViewController.h"
#import "LTNResetTradePasswordViewController.h"
#import "CurrentUser.h"
#import "UIImage+LJ.h"
#import "LTNLoginController.h"
#import "LTNGrantRechargePermissionViewController.h"
#import "LTNNotificationSetController.h"
#import "BaseWebViewController.h"
#import "CustomizedBackWebViewController.h"
#import "RechargeViewController.h"
#import "LTNMoreController.h"
#import "LTNAddressViewController.h"

@interface LTNAccountInfoController (){
    
    UIAlertView *_verifyRealNameAlertView;//用户实名认证
    UIAlertView *_boundBankCardAlertView;//用户绑卡
}

@property (nonatomic)NSArray *cellArrays;


@end


@implementation LTNAccountInfoController

- (void)back{
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    self.isTableViewStyleGrouped = YES;
    [super viewDidLoad];
    self.title=locationString(@"account_settings");
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = HexRGB(0xcccccc);
    
    UIView *footerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
    footerView.backgroundColor=[UIColor clearColor];
    
    // 登录按钮
    UIButton * logoffButton = [[UIButton alloc] initWithFrame:CGRectMake(kHorizontalMargin, 10, self.view.width-kHorizontalMargin*2, kGeneralHeight)];
    logoffButton.layer.cornerRadius = 5;
    logoffButton.layer.masksToBounds = YES;
    [logoffButton setTitle:locationString(@"quit_app") forState:UIControlStateNormal];
    [logoffButton setBackgroundImage:[UIImage imageWithColor:COLOR_MAIN size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [logoffButton addTarget:self action:@selector(logoff:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:logoffButton];

    //set an empty array here to prevent the the first time show sthe table view, and let the tableview show in viewWillAppear 
    _cellArrays = @[];

    self.tableView.tableFooterView=footerView;
    
    [self pullReload];
 
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateTableView) name:NotificationMsg_Update_UserInfo object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)updateTableView{
    _cellArrays = nil;
    [self.tableView reloadData];
}

- (void)getServiceData:(BOOL)isGetMore
{
    [super getServiceData:isGetMore];
    kWeakSelf
    [self apiForPath:kUserInfoUrl method:kGetMethod parameter:nil responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        if (!error) {
            NSInteger agreementCZ = [data[@"agreementCZ"] integerValue];
            agreementCZ = agreementCZ == 2 || agreementCZ == 0 ? 0 : 1;
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:data];
            [dic setValue:@(agreementCZ) forKey:@"agreementCZ"];
            [CurrentUser mine].userInfo = [UserInfoModel mj_objectWithKeyValues:dic];
            _cellArrays = nil;
        }
        [weakSelf.data addObjectsFromArray:self.cellArrays];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _cellArrays = nil;
    [self.tableView reloadData];
}

-(NSArray *)cellArrays{
    if(!_cellArrays){
        
        _cellArrays=@[
                      @[@{@"title":locationString(@"user_auth"),
                          @"key":@"kRealName",
                          @"sel":@"realNameAuthentication",
                          @"value":([CurrentUser verifyedRealName]) ? locationString(@"user_auth_true") : locationString(@"user_auth_false")
                          },
                        @{@"title":locationString(@"bind_bank_card"),
                          @"key":@"kBankCard",
                          @"sel":@"bindBankCard",
                          @"value":([CurrentUser bindedBankCard]) ? locationString(@"bank_card_binded") : locationString(@"bank_card_unbind")
                          },
                        @{@"title":locationString(@"deposit_nopwd"),
                          @"key":@"kRechargeFree",
                          @"sel":@"rechargeFree",
                          @"value":[CurrentUser mine].userInfo.agreementCZ ? locationString(@"opened") : locationString(@"unopen")
                          },
                        @{@"title":@"收货地址",
                          @"sel":@"myAddress",
                          }],

//                      @[@{@"title":@"免密充值",
//                          @"key":@"kRechargeFree",
//                          @"sel":@"rechargeFree",
//                          @"value":[CurrentUser mine].userInfo.agreementCZ ? @"已开通" : @"未开通"
//                          }],

                      @[@{@"title":locationString(@"modify_login_password"),
                          @"key":@"kLoginPwd",
                          @"sel":@"modifyLoginPassword",
                          @"value":@""},
                        @{@"title":locationString(@"reset_trade_password"),
                          @"key":@"kTradePwd",
                          @"sel":@"resetTradePassword",
                          @"value":@""
                          },
                        @{@"title":locationString(@"modify_trade_password"),
                          @"key":@"kTradePwd",
                          @"sel":@"modifyTradePassword",
                          @"value":@""
                          }
                        ],
                      
                      @[@{@"title":locationString(@"modify_gesture_password"),
                          @"key":@"kGesturePwd",
                          @"sel":@"modifyGesturePassword",
                          @"value":@""
                          }],
                      
                      
                      @[@{@"title":locationString(@"new_message_notification"),
                          @"key":@"kPushSet",
                          @"sel":@"pushSet",
                          @"value":@""}],
                      
                      @[@{@"title":locationString(@"tab_more"),
                         // @"key":@"kPushSet",
                          @"sel":@"pushAboutUs",
                          @"value":@""}],

                      ];
        
    }
    return _cellArrays;
}


/**
 *  实名认证
 */
-(void)realNameAuthentication{
    
   [LTNCore verifyRealNameViewController:^{
       [self pullReload];
   }];
}

/**
 *  绑定银行卡
 */
-(void)bindBankCard{
    if(![CurrentUser verifyedRealName])
    {
        _verifyRealNameAlertView = [[UIAlertView alloc] initWithTitle:nil message:locationString(@"realname_text") delegate:nil cancelButtonTitle:locationString(@"know") otherButtonTitles:nil, nil];
        [_verifyRealNameAlertView show];
        return;
    }
    if([CurrentUser bindedBankCard])
    {
        [LTNCore showBankInfoViewController:^{
            [self pullReload];
        }];
//        SecondBoundBandCardViewController *secondBoundBandCardViewController = [[SecondBoundBandCardViewController alloc]init];
//        [self.navigationController pushViewController:secondBoundBandCardViewController animated:YES];
    }
    else
    {
        [LTNCore boundBankCardViewController:^{
            [self pullReload];
        }];
        
//    BoundBankCardViewController *boundBankCardViewController = [[BoundBankCardViewController alloc]init];
//    [self.navigationController pushViewController:boundBankCardViewController animated:YES];
    }
    
}


/**
 *  免密充值
 */
- (void)changeUserAgreeMianMi
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:@{@"agreement_type" : @"ZCZP0800"}];
    // 如果已同意免密充值
    if ([CurrentUser mine].userInfo.agreementCZ) {
        [dict setValue:@"1" forKey:@"unbind"];
    }
    kWeakSelf
    [BaseDataEngine apiForPath:kUserAgreeMianMiUrl method:kPostMethod parameter:dict responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        if (!error) {
            //goto grant / unbind page
            
            //kStrongSelf
            BaseWebViewController *baseWebViewController = [[CustomizedBackWebViewController alloc] initWithURL:[data valueForKey:@"url"]];
            [weakSelf.navigationController pushViewController:baseWebViewController animated:YES];
           
            
        }
    }];
}

/**
 * 收货地址
 */
-(void)myAddress{
    LTNAddressViewController *address = [[LTNAddressViewController alloc]init];
    [self.navigationController pushViewController:address animated:YES];
}

/**
 *  重设登录密码
 */
-(void)modifyLoginPassword{
    LTNResetController * retrieveController = [[LTNResetController alloc] init];
    UINavigationController * navi = [[UINavigationController alloc] initWithRootViewController:retrieveController];
    navi.finishBlock=^(void){
        [LTNCore presentViewController:[LTNLoginController class] withFinishBlock:^(void){
            [self.navigationController popToRootViewControllerAnimated:NO];
            
        } animated:NO];
    };
    [self presentViewController:navi animated:YES completion:^{
        
    }];
    
    //[self.navigationController pushViewController:retrieveController animated:YES];
}

- (void)resetTradePassword {
    if(![CurrentUser verifyedRealName]){
        [LTNUtilsHelper boxShowWithMessage:locationString(@"reset_trand_passwpord_error") duration:2.0f];
        return;
    }

    LTNResetTradePasswordViewController *vc = [[LTNResetTradePasswordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  修改支付密码
 */
-(void)modifyTradePassword{
    if(![CurrentUser verifyedRealName]){
        [LTNUtilsHelper boxShowWithMessage:locationString(@"reset_trand_passwpord_error") duration:2.0f];
        return;
    }

    LTNModifyTradePasswordViewController *vc = [[LTNModifyTradePasswordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


/**
 *  修改手势密码
 */
-(void)modifyGesturePassword{
    
    GesturePasswordController *gesturePasswordController=[GesturePasswordController modifyGesturePasswordController];
    GestureNavigationController * navController = [[GestureNavigationController alloc] initWithRootViewController:gesturePasswordController];
    
    [self presentViewController:navController animated:YES completion:nil];
}

/**
 *  补充邀请人
 */
-(void)supplyPartner{
    LTNSupplyPartnerControllerViewController *controlelr=[[LTNSupplyPartnerControllerViewController alloc] init];
    [self.navigationController pushViewController:controlelr animated:YES];
}

/**
 *  新消息通知
 */
-(void)pushSet{
    LTNNotificationSetController *controlelr=[[LTNNotificationSetController alloc] init];
    [self.navigationController pushViewController:controlelr animated:YES];
}
/**
 *  关于我们
 */
-(void)pushAboutUs{
    LTNMoreController *more = [[LTNMoreController alloc]init];
    [self.navigationController pushViewController:more animated:YES];
    
}


/**
 *  退出登录
 */
-(void)logoff:(id)sender {
    VoidBlock block = ^(){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshInvestPage];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshHomePage];
        [self.navigationController popToRootViewControllerAnimated:NO];
        [[LTNCore globleCore] backToMainController];
        //[[CurrentUser mine] reset];
    };
    
    [CurrentUser  userLogoutSuccess:^(id response) {
        block();
    } failure:^(NSError *error) {
        DLog(@"%@", error.localizedDescription);
        block();
    }];
}

- (void)rechargeFree {
    
    if (![self verifyRealNameandboundBank])
        return;

    NSString * prompt = [CurrentUser mine].userInfo.agreementCZ ? locationString(@"relieve_deposit_pwd_hint") : locationString(@"open_deposit_pwd_hint");
    NSString * cancel = [CurrentUser mine].userInfo.agreementCZ ? locationString(@"cancel_2") : locationString(@"cancel");
    NSString * confirm = [CurrentUser mine].userInfo.agreementCZ ? locationString(@"relieve_2") : locationString(@"immediately_opened_2");
    UIAlertView *alertView= [[UIAlertView alloc]initWithTitle:locationString(@"hint") message:prompt delegate:self cancelButtonTitle:cancel otherButtonTitles:confirm, nil];
    alertView.tag = 3000;
    [alertView show];
}

#pragma mark 验证是否完成用户认证、银行卡认证
-(BOOL)verifyRealNameandboundBank
{
    if(![CurrentUser verifyedRealName])
    {
        _verifyRealNameAlertView = [[UIAlertView alloc] initWithTitle:nil message:locationString(@"realname_text") delegate:nil cancelButtonTitle:locationString(@"know") otherButtonTitles:nil, nil];
        [_verifyRealNameAlertView show];
        return NO;
    }
    else if(![CurrentUser bindedBankCard])
    {
        _boundBankCardAlertView = [[UIAlertView alloc] initWithTitle:nil message:locationString(@"should_bound_bank") delegate:nil cancelButtonTitle:locationString(@"know") otherButtonTitles:nil, nil];
        [_boundBankCardAlertView show];
        return NO;
    }
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.cellArrays count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cellArrays[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * CellIdentifier = @"AccountInfoCellIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = kFont(16);
        cell.textLabel.textColor = HexRGB(0x3a3a3a);
        cell.detailTextLabel.font = kFont(14);
        cell.detailTextLabel.textColor = HexRGB(0x8a8a8a);
    }
    

    NSDictionary *cellDic=self.cellArrays[indexPath.section][indexPath.row];
   
    cell.textLabel.text=cellDic[@"title"];
    cell.detailTextLabel.text = cellDic[@"value"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary * dic = _cellArrays[indexPath.section][indexPath.row];
    NSString * selName = dic[@"sel"];
    SEL action = NSSelectorFromString(selName);
    if([self respondsToSelector:action])
        [self performSelector:action withObject:dic[@"detail"] afterDelay:0.0f];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}
//- (void)back
//{
//    if (self.navigationController.visibleViewController == self) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 3000) {
        if (buttonIndex == 1) {
            [self changeUserAgreeMianMi];
        }
    }else {
        if(buttonIndex == 1)
        {
            RechargeViewController *rechargeViewController = [[RechargeViewController alloc]init];
            [self.navigationController pushViewController:rechargeViewController animated:YES];
        }else{
            [self back];
        }
    }
}


@end
