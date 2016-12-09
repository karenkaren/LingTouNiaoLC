//
//  UtilJSAction.m
//  mmbang
//
//

#import "UtilJSAction.h"
#import "BaseDataEngine.h"
#import "JSActionFactory.h"
#import "RechargeViewController.h"
#import "ChargeViewController.h"
#import "SecondBoundBandCardViewController.h"
#import "LTNAccountInfoController.h"
#import "LTNMyCurrentDepositController.h"
#import "LTNRollInController.h"
#import "ConfirmInvestViewController.h"
#import "InvestSummaryViewController.h"
#import "VerifyRealNameViewController.h"
#import "LTNAccountController.h"
#import "ShareSnsUtils.h"
//#import "ShareSnsUtil.h"
#import "LTNSystemInfo.h"
#import "LTNCrowdRecordController.h"
#import "LTNMutualRecordController.h"

@implementation UtilJSAction

#pragma mark -

-(BOOL)canCallMe{
    
    NSString *absoluteString = self.urlString;
//    NSString *absoluteString = self.webView.request.URL.absoluteString;
    
    NSArray *legalDomains=[[NSUserDefaults standardUserDefaults] objectForKey:kLegalDomains];
    if(legalDomains&&isArray(legalDomains)&&[legalDomains count]>0){
        
    }else{
        legalDomains=@[@"http://120.55.184.234",@"http://192.168.18.194:8080",@"https://www.lingtouniao.com"];
    }
    
    for(NSString *legalDomain in legalDomains){
        
        if([absoluteString hasPrefix:legalDomain])
            return YES;
    }

    
    return NO;
    
//#if (defined(DEBUG) || defined(ADHOC))
//    if([absoluteString hasPrefix:API_BASE_URL])
//        return YES;
//    else
//        return NO;
//
//#else
//    if([absoluteString hasPrefix:@"https://www.lingtouniao.com/"])
//        return YES;
//    else
//        return NO;
//#endif
    
}

/**
 *	获取SessionKey
 */
-(void)getSessionKey{
    
    if(![self canCallMe])
        return;
    
    NSString *sessionKey = [CurrentUser mine].sessionKey;
    [self excuteCallback:sessionKey?@{@"sessionKey":sessionKey}:@{}];
}

/**
 *	获取用户信息
 */
-(void)getUserInfo{
    
    if(![self canCallMe])
        return;
    
    NSMutableDictionary *userDic=[NSMutableDictionary dictionaryWithDictionary:[CurrentUser mine].userInfo.mj_keyValues];
    [userDic addEntriesFromDictionary:[CurrentUser mine].accountInfo.mj_keyValues];
    
    [self excuteCallback:userDic];
}

/**
 *	购买众筹 http://callclient?method=crowdBuy&param='+crowdProDetailStr
 */
-(void)crowdBuy{
    
    [LTNUtilsHelper actionWhenLogin:^{
        if([CurrentUser mine].accountInfo.usableBalance<=0){
            [self verifyedRealNameAndBindedBankCard:^{
                if ([CurrentUser verifyedRealName] && [CurrentUser bindedBankCard]) {
                    [[LTNCore globleCore] jumpToCrowdfundingConfirmInvestWithParams:self.params fromController:self.baseViewController];
                }
            }];
        }else{
            [[LTNCore globleCore] jumpToCrowdfundingConfirmInvestWithParams:self.params fromController:self.baseViewController];
        }
        
    }];
}





/**
 *  互助购买
 */
- (void)buy_mutual
{
    [LTNUtilsHelper actionWhenLogin:^{
        
        if([CurrentUser mine].accountInfo.usableBalance<=0){
            [self verifyedRealNameAndBindedBankCard:^{
                if ([CurrentUser verifyedRealName] && [CurrentUser bindedBankCard]) {
                    [[LTNCore globleCore] jumpToCooperationConfirmInvestWithParams:self.params fromController:self.baseViewController];
                }
            }];
        }else{
            [[LTNCore globleCore] jumpToCooperationConfirmInvestWithParams:self.params fromController:self.baseViewController];
        }

        
    }];
}

- (void)verifyedRealNameAndBindedBankCard:(VoidBlock)handleBlock
{
    if(![CurrentUser verifyedRealName])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:locationString(@"realname_text")
                                                       delegate:nil
                                              cancelButtonTitle:locationString(@"cancel")
                                              otherButtonTitles:locationString(@"next"),nil];
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            if (buttonIndex) {
                [LTNCore verifyRealNameViewController:^{
                    if (handleBlock) {
                        handleBlock();
                    }
                }];
            }
        }];
    }
    else if(![CurrentUser bindedBankCard])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:locationString(@"bindbank_text")
                                                       delegate:nil
                                              cancelButtonTitle:locationString(@"cancel")
                                              otherButtonTitles:locationString(@"next"),nil];
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            if (buttonIndex) {
                [LTNCore boundBankCardViewController:^{
                    if (handleBlock) {
                        handleBlock();
                    }
                }];
            }
        }];
        
    } else {
        if (handleBlock) {
            handleBlock();
        }
    }
}

/**
 *	获取PhoneNumber
 */
-(void)getPhoneNumber{
    
    if(![self canCallMe])
        return;

    NSString *phoneNumber = esString([CurrentUser mine].userInfo.mobile);
    [self excuteCallback:@{@"phoneNumber":phoneNumber}];
}


/**
 * 是否最新版本
 */
-(void)shouldUpdateApp{
    BOOL isRemind = NO;
    NSString *versionString = [Utility getDataWithKey:@"UpDateVersionRemind"];
    
    NSString *currentVersion = [LTNSystemInfo appVersion];
    if (versionString) {
        if (![currentVersion isEqualToString:versionString]) {
            isRemind = YES;
        }
    }
    [self excuteCallback:@{@"shouldUpdateApp":@(isRemind)}];
}



/**
 * 更新客户端
 */
-(void)updateApp{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:locationString(@"hint")
                                                    message:locationString(@"need_new_version")
                                                   delegate:nil
                                          cancelButtonTitle:locationString(@"btn_cancel")
                                          otherButtonTitles:locationString(@"update_btn"), nil];
    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [Utility openURL:[NSURL URLWithString:kUpdateUrl]];
        }
    }];

}



/**
 * 弹窗
 */
-(void)alertShow{
    
    if([self.params[@"type"] isEqualToString:@"1"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:self.params[@"title"]
                                                        message:self.params[@"content"]
                                                       delegate:nil
                                              cancelButtonTitle:locationString(@"btn_confirm_yes")
                                              otherButtonTitles:nil];
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            
        }];
    }else if([self.params[@"type"] isEqualToString:@"2"]){
        [LTNUtilsHelper boxShowWithMessage:self.params[@"content"] duration:2.0f];
    }
    
    
    
    
    
}






/**
 *	获取版本号
 */
-(void)getAppVersion{
    NSString *appVersion = [LTNSystemInfo appVersion];
    [self excuteCallback:appVersion ? @{@"appVersion":appVersion}:@{}];
}



/**
 *	注册
 */
-(void)shouldLogup{
    [[LTNCore globleCore] registerController:^{
        NSString *sessionKey = [CurrentUser mine].sessionKey;
        [self excuteCallback:sessionKey?@{@"sessionKey":sessionKey}:@{}];
    }];
}




/**
 *	没有登录就进入的，需要弹出登录窗口
 */
-(void)shouldLogin{
//    [LTNCore popToRootControllers];
//    [[CurrentUser mine] reset];
//    [[LTNCore globleCore] backToMainController];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_Exit_Success object:nil];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:locationString(@"not_login_should") delegate:nil cancelButtonTitle:locationString(@"btn_cancel") otherButtonTitles:locationString(@"login_label_signin"), nil];
//    
//    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
//        if (buttonIndex) {
            //登陆成功不会跳转我的帐户
            [[LTNCore globleCore] loginController:^{
                NSString *sessionKey = [CurrentUser mine].sessionKey;
                [self excuteCallback:sessionKey?@{@"sessionKey":sessionKey}:@{}];
            }];
//        }
//    }];
}

//调用需要实名
-(void)shouldRealname{
    [LTNCore verifyRealNameViewController:^{
        
    }];
}

//调用需要绑卡
-(void)shouldBindCard{
    
    if([CurrentUser bindedBankCard])
    {
        [LTNCore showBankInfoViewController:^{
            
        }];
        
    }
    else
    {
        [LTNCore boundBankCardViewController:^{
           
        }];
  
    }

    
}

//调用需要充值
-(void)shouldRecharge{
    [LTNCore rechargeViewController:^{
        
    }];

}

/**
 *	登录超时
 */

-(void)loginTimeout{
    [LTNCore popToRootControllers];
    [[CurrentUser mine] reset];
    [[LTNCore globleCore] backToMainController];
    
    //TODO:需要重置密码吗？
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_Exit_Success object:nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:locationString(@"login_status_error") delegate:nil cancelButtonTitle:locationString(@"reset_password") otherButtonTitles:locationString(@"login_again"), nil];
    
    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
        if (buttonIndex) {
            //登陆成功不会跳转我的帐户
            if(buttonIndex==0){
                //密码重置
                [LTNCore resetPassword];
            }else{
                //登陆成功不会跳转我的帐户
                [[LTNCore globleCore] loginController:nil];
            }

        }
    }];

}

- (void)buildUrlParams {
    id params = self.params;
    
    NSMutableDictionary *builtParams = nil;
    if (params && [params isKindOfClass:[NSDictionary class]]) {
        builtParams = [BaseDataEngine rebuildParameter:[params mutableCopy]];
    }
    
    [self excuteCallback:builtParams?:@{}];
}

//充值成功
- (void)gotoDeposit {
    
    NSArray *piwikArr=@[
                        @[@"order_no",@""],
                        @[@"result",@"1"],
                        @[@"reason",@""],
                        @[@"amt",esString([LTNCore globleCore].tempAmt)],
                        @[@"datepoint",timeForStatistics()],
                        
                        ];
    piwikEvent(@"recharge",piwikArr);
    
    
    [TrackingUtility event:kCZSuccess];
    //pc端和手机端可以同时登陆，在进行提现操作的时候先进行账户金额的刷新
    [LTNServerHelper retrieveAccountInfoWithFinishBlock:nil];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshAccountInfo];
    
    UIViewController *vc = self.baseViewController;
    for (UIViewController *viewController in vc.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[InvestSummaryViewController class]]) {
            InvestSummaryViewController *investSummaryViewController = (InvestSummaryViewController *)viewController;
            [vc.navigationController popToViewController:investSummaryViewController animated:YES];
            break;
        }
        if ([viewController isKindOfClass:[RechargeViewController class]]) {
            RechargeViewController *rechargeViewController = (RechargeViewController *)viewController;
            rechargeViewController.isCompleteAction = YES;
            [vc.navigationController popToViewController:rechargeViewController animated:YES];
            break;
        }
    }
}

//提现成功
- (void)gotoWithdraw {
    
    
    NSArray *piwikArr=@[
                             @[@"order_no",@""],
                             @[@"result",@"1"],
                             @[@"reason",@""],
                             @[@"amt",esString([LTNCore globleCore].tempAmt)],
                             @[@"datepoint",timeForStatistics()],
                             
                             
                             ];
    piwikEvent(@"withdraw",piwikArr);
    
    [TrackingUtility event:kTXSuccess];
    [LTNServerHelper retrieveUserInfoWithFinishBlock:nil];
    [LTNServerHelper retrieveAccountInfoWithFinishBlock:nil];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshAccountInfo];
     UIViewController *vc = self.baseViewController;
    [vc.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//绑卡成功
- (void)gotoBindcard {
    [TrackingUtility event:kBKSuccess];
    
    
    NSArray *piwikArr=@[
                        @[@"user_id",esString([CurrentUser mine].userInfo.mobile)],
                        @[@"result",@"1"],
                             
                        @[@"reason",@""]
                             
                             ];
    
    piwikEvent(@"bind_card",piwikArr);

    UIViewController *vc = self.baseViewController;
    for (UIViewController *viewController in vc.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[SecondBoundBandCardViewController class]]) {
            SecondBoundBandCardViewController *secondBoundBandCardViewController = (SecondBoundBandCardViewController *)viewController;
            secondBoundBandCardViewController.isCompleteAction = YES;
            
            [LTNServerHelper retrieveAccountInfoWithFinishBlock:nil];
            [LTNServerHelper retrieveUserInfoWithFinishBlock:nil];
            
            [vc.navigationController popToViewController:secondBoundBandCardViewController animated:YES];
            break;
        }
    }
}

// 活期转入成功
- (void)gotoCurrentDeposit
{
    [TrackingUtility event:kHQSuccess];
    UIViewController * vc = self.baseViewController;
    for (UIViewController *viewController in vc.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[LTNMyCurrentDepositController class]]) {
            LTNMyCurrentDepositController * currentDepositController = (LTNMyCurrentDepositController *)viewController;
            [vc.navigationController popToViewController:currentDepositController animated:YES];
            break;
        }
    }
}

// 众筹购买记录
-(void)crowdBuyRecord{
   // self.params
    NSLog(@"===%@",self.params);

    NSString *productId = [NSString stringWithFormat:@"%@",self.params[@"productId"]];
    
    LTNCrowdRecordController *listRecord = [[LTNCrowdRecordController alloc]init];
    listRecord.productId = productId;
    [self.baseViewController.navigationController pushViewController:listRecord animated:YES];
}

// 互助购买记录
-(void)mutual_member{
   // NSLog(@"===%@",self.params);
    NSString *productId = [NSString stringWithFormat:@"%@",self.params[@"productId"]];
    
    LTNMutualRecordController *listRecord = [[LTNMutualRecordController alloc]init];
    listRecord.productId = productId;
    [self.baseViewController.navigationController pushViewController:listRecord animated:YES];
    
}

// 我的投资
- (void)gotoMyInvestment
{
    [LTNUtilsHelper actionWhenLogin:^{
        [[LTNCore globleCore] jumpToMyInvestment];

    } onVC:nil];
}
// 我的任务
- (void)gotoMyTask
{
    [LTNUtilsHelper actionWhenLogin:^{
        [[LTNCore globleCore] jumpToMyTask];
    } onVC:nil];
}
// 新手专区
- (void)gotoBeginnerDivision
{
    [[LTNCore globleCore] jumpToNewHandArea];
}
// 进阶专区
- (void)gotoAdvancedDivision
{
    [LTNUtilsHelper actionWhenLogin:^{
        [[LTNCore globleCore] jumpToStageArea];
    } onVC:nil];
}
// 活动专区
- (void)gotoActivityDivision
{
    [LTNUtilsHelper actionWhenLogin:^{
        [[LTNCore globleCore] jumpToLimitTimeArea];
    } onVC:nil];
}
// 项目列表
- (void)gotoProductList
{
    [[LTNCore globleCore] jumpToInvestmentController];
}

//  合伙人
- (void)gotoPartner
{
    [LTNUtilsHelper actionWhenLogin:^{
        [[LTNCore globleCore] jumpToMyPartner];
    } onVC:nil];
}

- (void)gotoTransfer{

    UIViewController *vc = self.baseViewController;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshInvestPage];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshAccountInfo];
    [vc.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark 免密授权成功
- (void)gotoGrant {
    //go back to original page: charge, or buy
    UIViewController *vc = self.baseViewController;
    NSArray *vcs = vc.navigationController.viewControllers;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kAutoClick];
    UIViewController *popToVC;
    for (NSInteger i = vcs.count - 1; i > -1; i--) {
        popToVC = vcs[i];
        if ([popToVC isKindOfClass:[RechargeViewController class]] || [popToVC isKindOfClass:[LTNRollInController class]] || [popToVC isKindOfClass:[ConfirmInvestViewController class]] || [popToVC isKindOfClass:[RechargeViewController class]] || [popToVC isKindOfClass:[SecondBoundBandCardViewController class]]||[popToVC isKindOfClass:[LTNAccountInfoController class]]) {
            if ([popToVC isKindOfClass:[SecondBoundBandCardViewController class]]) {
                SecondBoundBandCardViewController * secondBoundBandCardViewController = (SecondBoundBandCardViewController *)popToVC;
//                secondBoundBandCardViewController.isChangedMianMiGrant = YES;
                [CurrentUser mine].userInfo.agreementCZ = YES;
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kAutoClick];
            }
            
            if ([popToVC isKindOfClass:[LTNAccountInfoController class]]) {
                //LTNAccountInfoController * secondBoundBandCardViewController = (LTNAccountInfoController *)popToVC;
                //secondBoundBandCardViewController.isChangedMianMiGrant = YES;
                [CurrentUser mine].userInfo.agreementCZ = YES;
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kAutoClick];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_Update_UserInfo
                                                                object:nil
                                                              userInfo:nil];
            [vc.navigationController popToViewController:popToVC animated:YES];
            break;
        }
        
    }
}

#pragma mark 换卡
- (void)gotoChangeCard {
    //直接跳到设置银行卡页面
    UIViewController *vc = self.baseViewController;
    NSArray *vcs = vc.navigationController.viewControllers;
    UIViewController *popToVC;
    //[vc.navigationController popToRootViewControllerAnimated:YES];
    for (NSInteger i = 0; i < vcs.count; i++) {
        popToVC = vcs[i];
        if ([popToVC isKindOfClass:[SecondBoundBandCardViewController class]]) {
            [[LTNCore globleCore] backToRootController:YES];
            break;
        }
    }
}

/**
 *  解除免密充值成功
 */
- (void)gotoTopUpCancel
{
    UIViewController *vc = self.baseViewController;
    for (UIViewController *viewController in vc.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[SecondBoundBandCardViewController class]]) {
            SecondBoundBandCardViewController *secondBoundBandCardViewController = (SecondBoundBandCardViewController *)viewController;
            secondBoundBandCardViewController.isCompleteAction = YES;
            [CurrentUser mine].userInfo.agreementCZ = NO;
//            secondBoundBandCardViewController.isChangedMianMiGrant = YES;
            [vc.navigationController popToViewController:secondBoundBandCardViewController animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_Update_UserInfo
                                                                object:nil
                                                              userInfo:nil];
            break;
        }
        else if([viewController isKindOfClass:[LTNAccountInfoController class]]) {
            LTNAccountInfoController *accountInfoController = (LTNAccountInfoController *)viewController;
            //secondBoundBandCardViewController.isCompleteAction = YES;
            [CurrentUser mine].userInfo.agreementCZ = NO;
            //secondBoundBandCardViewController.isChangedMianMiGrant = YES;
            [vc.navigationController popToViewController:accountInfoController animated:YES];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_Update_UserInfo
                                                                object:nil
                                                              userInfo:nil];
            break;
        }
        
        
    }
    
   
}

/**
 *  实名并设置密码成功
 */
- (void)goBackAfterSetPasswordSuccess
{
    //直接跳到资金托管页面
    
    NSArray *piwikArr=@[
                        @[@"user_id",esString([CurrentUser mine].userInfo.mobile)],
                        @[@"result",@"1"],
                        @[@"reason",@""]
                        ];
    
    piwikEvent(@"auth_name",piwikArr);
    
    
    UIViewController *vc = self.baseViewController;
    NSArray *vcs = vc.navigationController.viewControllers;
    UIViewController *popToVC;
    for (NSInteger i = 0; i < vcs.count; i++) {
        popToVC = vcs[i];
        if ([popToVC isKindOfClass:[VerifyRealNameViewController class]]) {
            [LTNServerHelper retrieveAccountInfoWithFinishBlock:nil];
            [LTNServerHelper retrieveUserInfoWithFinishBlock:^{
                [CurrentUser mine].userInfo.certification = @"1";
                VerifyRealNameViewController * VerifyRealNameController = (VerifyRealNameViewController *)popToVC;
                VerifyRealNameController.isCompleteAction = YES;
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshAccountInfo];
                [vc.navigationController popToViewController:VerifyRealNameController animated:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_Update_UserInfo
                                                                    object:nil
                                                                  userInfo:nil];
            }];
            break;
        }
    }
}

#pragma mark 新手分享
- (void)gotoNoviceShare
{
    BaseViewController * vc = self.baseViewController;
    [ShareSnsUtils shareSnsOnViewController:vc delegate:vc];
}

-(void)shareWithParameters{
    BaseViewController * vc = self.baseViewController;
    [ShareSnsUtils shareSnsOnViewController:vc shareTitle:esString(self.params[@"title"]) shareText:esString(self.params[@"desc"]) shareImage:esString(self.params[@"icon"]) shareUrl:[NSString stringWithFormat:@"%@?mobile=%@", esString(self.params[@"url"]),esString([CurrentUser mine].userInfo.mobile)] delegate:vc];
//    [ShareSheet showWithBlock:^(ShareSnsType type) {
//        ShareData * shareData= [[ShareData alloc] initWithData:@{
//                                                                 @"title" : esString(self.params[@"title"]),
//                                                                 @"desc" : esString(self.params[@"desc"]),
//                                                                 
//                                                                 @"thumb":esString(self.params[@"icon"]),
//                                                                 @"url" : [NSString stringWithFormat:@"%@?mobile=%@", esString(self.params[@"url"]),esString([CurrentUser mine].userInfo.mobile)],
//                                                                 } type:type];
//        [[ShareSnsUtil mainSnsUtil]shareSnsWithData:shareData onVC:vc];
//    }];
//
}

@end
