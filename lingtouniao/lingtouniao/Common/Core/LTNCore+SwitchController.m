//
//  LTNCore+SwitchController.m
//  lingtouniao
//
//  Created by  mathe on 15/12/17.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNTabBarController.h"
#import "LTNLoginController.h"
#import "LTNRegisterController.h"
#import "VerifyRealNameViewController.h"
#import "BoundBankCardViewController.h"
#import "SecondBoundBandCardViewController.h"
#import "RechargeViewController.h"
#import "ChargeViewController.h"
#import "ShowBankInfoController.h"

#import "GuideController.h"

#import "GesturePasswordController.h"

#import "NotificationWebViewController.h"

#import "LTNAlertWindow.h"
#import "SplashController.h"
#import "LTNAccountController.h"
#import "LTNMyTaskController.h"
#import "SplashModel.h"
#import "LTNHomeController.h"

#import "CooperationConfirmInvestController.h"
#import "CrowdfundingConfirmInvestController.h"

#import "LTNDiscoverViewController.h"
#import "LTNRetrieveController.h"

@implementation LTNCore (SwitchController)

- (void)firstLaunch
{
    
#if AlwaysShowGuide
    [self showGuideController];//引导页
#else
    if ([LTNCore isFreshLaunch:NULL]&&HaveIntroduction)
    {
        [self showGuideController];//引导页
    }else{
        if ([SplashModel sharedSplash].version && ![[SplashModel sharedSplash].version isEqualToString:@""]) {
            [self showSplashController];//可运营启动页
        } else {
            
            
            //[GesturePasswordController clearKeychainPassword];
            [self loadMainTabbarController];//首页
            
            [self performSelector:@selector(firstShowGesturePassword) withObject:nil afterDelay:0.5];
            //[LTNCore gesturePasswordController];
            
        }
    }
#endif
}

-(void)firstShowGesturePassword{
    [LTNCore gesturePasswordController];
}

- (void)showSplashController
{
    SplashController * splashController = [[SplashController alloc] init];
    [[LTNCore mainWindow] setRootViewController:splashController];
}

-(void)showGuideController
{
    GuideController * guideController=[GuideController guideController:YES];
    [[LTNCore mainWindow]  setRootViewController:guideController];
}

-(void)loadMainTabbarController{
    if(!self.tabbarController)
        self.tabbarController=[[LTNTabBarController alloc] init];
    [[LTNCore mainWindow]  setRootViewController:self.tabbarController];
    //[[LTNCore appDelegate] registerRemoteNotification];
    if ([[CurrentUser mine] hasLogged]) {
        [LTNServerHelper retrieveAccountInfoWithFinishBlock:^{
        }];
        [LTNServerHelper retrieveUserInfoWithFinishBlock:^(void){
        }];
    }
}

-(void)loadMainTabbarControllerOne{
    if(!self.tabbarController) {
        self.tabbarController=[[LTNTabBarController alloc] init];
        [[LTNCore mainWindow]  setRootViewController:self.tabbarController];
        //[[LTNCore appDelegate] registerRemoteNotification];
        if ([[CurrentUser mine] hasLogged]) {
            [LTNServerHelper retrieveAccountInfoWithFinishBlock:^{
            }];
            [LTNServerHelper retrieveUserInfoWithFinishBlock:^(void){
            }];
        }
    }
}

-(void)backToMainController{
    
    [[LTNAlertWindow sharedWindow] dismissRootController];
    [self backToRootController];
    [self performSelector:@selector(tabBarSelect:) withObject:@(0) afterDelay:0.0];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GestureSuccessNotification"
                                                        object:nil
                                                      userInfo:nil];
}

-(void)tabBarSelect:(NSNumber *)index{
    [self.tabbarController setSelectedIndex:[index intValue]];
}

-(void)backToMoreController{
    [[LTNAlertWindow sharedWindow] dismissRootController];
    [self backToRootController];
    [self performSelector:@selector(tabBarSelect:) withObject:@(3) afterDelay:0.0];
}

- (void)backToDiscoverController
{
    [[LTNAlertWindow sharedWindow] dismissRootController];
    [self backToRootController];
    [self performSelector:@selector(tabBarSelect:) withObject:@(2) afterDelay:0.0];
}

-(void)backToInvestmentListController
{
    [[LTNAlertWindow sharedWindow] dismissRootController];
    [self backToRootController];
    [self performSelector:@selector(tabBarSelect:) withObject:@(1) afterDelay:0.0];
}

-(void)backToRootController{
    [self backToRootController:NO];
}


-(void)backToRootController:(BOOL)animation{
    if(!self.tabbarController)
        self.tabbarController=[[LTNTabBarController alloc] init];
    [self.tabbarController dismissViewControllerAnimated:NO completion:nil];
    
    NSArray *controllers=[self.tabbarController viewControllers];
    for(UINavigationController *navigationController in controllers){
        [navigationController popToRootViewControllerAnimated:animation];
    }
    UIView * socialView = [[UIApplication sharedApplication].keyWindow.subviews.firstObject viewWithTag:100];
    if (socialView) {
        [socialView removeFromSuperview];
    }
}

-(void)showMyAccountController:(BOOL)shouldShowMyAccount{
    if(!self.tabbarController)
        self.tabbarController=[[LTNTabBarController alloc] init];

    [self.tabbarController setSelectedIndex:2];

//    [UIView transitionFromView:[LTNCore keyWindow].rootViewController.view
//                        toView:self.tabbarController.view
//                      duration:0.50
//                       options:UIViewAnimationOptionTransitionFlipFromRight
//                    completion:^(BOOL finished)
//     {
//         [[LTNCore keyWindow]  setRootViewController:self.tabbarController];
//         if(shouldShowMyAccount)
//             [self.tabbarController setSelectedIndex:2];
//
//     }];

    
}

#pragma mark push notification transform

/**
 *  理财列表
 */
-(UIViewController *)jumpToInvestmentController{

    [self backToRootController];
    [self.tabbarController setSelectedIndex:1];
    UINavigationController * navController=(UINavigationController *)([self.tabbarController selectedViewController]);
    UIViewController *controller=navController.topViewController;
    if([controller isKindOfClass:NSClassFromString(@"LTNInvestmentController")]){
        return controller;
    }
    return nil;
}


/**
 *   标的详情
 */
-(void)jumpToProductDetailController:(NSString *)productID{
    UIViewController *investmentController=[self jumpToInvestmentController];
    if(investmentController){
        SEL action = NSSelectorFromString(@"pushProductDetailControllerWithproductID:");
        if([investmentController respondsToSelector:action]){
            [investmentController performSelector:action withObject:productID afterDelay:0.0f];
        }
    }
}


-(UIViewController *)jumpToMyAccountController{

    [self backToRootController];
    
    self.shouldNotShowTeachingView=YES;
    [self.tabbarController setSelectedIndex:3];
    
    if(![[CurrentUser mine] hasLogged])
        return nil;
    UINavigationController * navController=(UINavigationController *)([self.tabbarController selectedViewController]);
    UIViewController *controller=navController.topViewController;
    [self performSelector:@selector(setShouldNotShowTeachingViewNO) withObject:nil afterDelay:1.0];
    if([controller isKindOfClass:NSClassFromString(@"LTNAccountController")]){
        return controller;
    }
    return nil;
}

-(UIViewController *)jumpToDiscoverController{
    
    [self backToRootController];
    [self.tabbarController setSelectedIndex:2];
    UINavigationController * navController=(UINavigationController *)([self.tabbarController selectedViewController]);
    UIViewController * controller = navController.topViewController;
    if([controller isKindOfClass:NSClassFromString(@"LTNDiscoverViewController")]){
        return controller;
    }
    return nil;
}

-(void)setShouldNotShowTeachingViewNO{
    self.shouldNotShowTeachingView=NO;
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshAccountInfo];
}

/**
 *  收益明细
 */
-(void)jumpToMyIncometSatement{
    UIViewController *accountController=[self jumpToMyAccountController];
    if(accountController){
        SEL action = NSSelectorFromString(@"showRevenueDetail:");
        if([accountController respondsToSelector:action]){
            [accountController performSelector:action withObject:nil afterDelay:0.0f];
        }
    }
}

/**
 *  理财金券
 */
-(void)jumpToMyTicketList{
    
    UIViewController *accountController=[self jumpToMyAccountController];
    if(accountController){
        SEL action = NSSelectorFromString(@"ticketList");
        if([accountController respondsToSelector:action]){
            [accountController performSelector:action withObject:nil afterDelay:0.0f];
        }
    }
    
}


/**
 *  我的投资
 */
-(void)jumpToMyInvestment{
    
    UIViewController *accountController=[self jumpToMyAccountController];
    if(accountController){
        SEL action = NSSelectorFromString(@"myInvestment");
        if([accountController respondsToSelector:action]){
            [accountController performSelector:action withObject:nil afterDelay:0.0f];
        }
    }
    
}

/**
 *  我的互助
 */
-(void)jumpToMyCooperation{
    
    UIViewController *accountController=[self jumpToMyAccountController];
    if(accountController){
        SEL action = NSSelectorFromString(@"eachHelp");
        if([accountController respondsToSelector:action]){
            [accountController performSelector:action withObject:nil afterDelay:0.0f];
        }
    }
    
}

/**
 *  我的众筹
 */
-(void)jumpToMyCrowdfunding{
    
    UIViewController *accountController=[self jumpToMyAccountController];
    if(accountController){
        SEL action = NSSelectorFromString(@"arrange");
        if([accountController respondsToSelector:action]){
            [accountController performSelector:action withObject:nil afterDelay:0.0f];
        }
    }
}

/**
 *  合伙人
 */
-(void)jumpToMyPartner{
    
    UIViewController *accountController=[self jumpToMyAccountController];
    if(accountController){
        SEL action = NSSelectorFromString(@"showPartner");
        if([accountController respondsToSelector:action]){
            [accountController performSelector:action withObject:nil afterDelay:0.0f];
        }
    }
}

/**
 *  我的任务
 */
-(UIViewController *)jumpToMyTask{
    
    return [self jumpToMyTaskWithAnimated:YES];
}

-(UIViewController *)jumpToMyTaskWithAnimated:(BOOL)animated
{
    LTNAccountController * accountController=(LTNAccountController * )[self jumpToMyAccountController];
    if(accountController){
        UIViewController * vc = [accountController showMyTaskWithAnimated:animated];
        if ([vc isKindOfClass:[LTNMyTaskController class]]) {
            return vc;
        }
    }
    return nil;
}

/**
 *  新手专区
 */
-(void)jumpToNewHandArea{
    
    [self backToRootController];
    [self.tabbarController setSelectedIndex:0];
    UINavigationController * navController=(UINavigationController *)([self.tabbarController selectedViewController]);
    UIViewController *controller=navController.topViewController;
    if([controller isKindOfClass:NSClassFromString(@"LTNHomeController")]){
        LTNHomeController * homeController = (LTNHomeController *)controller;
        SEL action = NSSelectorFromString(@"goToTaskDivision");
        if([homeController respondsToSelector:action]){
            [homeController performSelector:action withObject:nil afterDelay:0.0f];
        }
    }
}

/**
 *  进阶专区
 */
-(void)jumpToStageArea{
    
    UIViewController * viewController = [self jumpToMyTaskWithAnimated:NO];
    
    if(viewController && [viewController isKindOfClass:[LTNMyTaskController class]]){
        LTNMyTaskController * taskController = (LTNMyTaskController *)viewController;
        SEL action = NSSelectorFromString(@"stageArea");
        if([taskController respondsToSelector:action]){
            [taskController performSelector:action withObject:nil afterDelay:0.0f];
        }
    }
}

/**
 *  活动专区
 */
-(void)jumpToLimitTimeArea{
    
    UIViewController * viewController = [self jumpToMyTaskWithAnimated:NO];
    
    if(viewController && [viewController isKindOfClass:[LTNMyTaskController class]]){
        LTNMyTaskController * taskController = (LTNMyTaskController *)viewController;
        SEL action = NSSelectorFromString(@"limitTimeArea");
        if([taskController respondsToSelector:action]){
            [taskController performSelector:action withObject:nil afterDelay:0.0f];
        }
    }
}

/**
 *  借款
 */
-(void)jumpToLoan
{
    UIViewController * vc = [self jumpToMyAccountController];
    if(vc && [vc isKindOfClass:[LTNAccountController class]]){
        LTNAccountController * accountController = (LTNAccountController *)vc;
        SEL action = NSSelectorFromString(@"loanList");
        if([accountController respondsToSelector:action]){
            [accountController performSelector:action withObject:nil afterDelay:0.0f];
        }
    }
}

/**
 *  互助
 */
- (void)jumpToCooperationConfirmInvestWithParams:(NSDictionary *)params fromController:(UIViewController *)vc
{
    CooperationConfirmInvestController *confirmInvestViewController = [[CooperationConfirmInvestController alloc]initWithNibName:@"ConfirmInvestViewController" bundle:nil];
    confirmInvestViewController.hidesBottomBarWhenPushed = YES;
    confirmInvestViewController.detailParams = params;
    [vc.navigationController pushViewController:confirmInvestViewController animated:YES];
}

- (void)jumpToCrowdfundingConfirmInvestWithParams:(NSDictionary *)params fromController:(UIViewController *)vc
{
    CrowdfundingConfirmInvestController *confirmInvestViewController = [[CrowdfundingConfirmInvestController alloc]initWithNibName:@"ConfirmInvestViewController" bundle:nil];
    confirmInvestViewController.detailParams = params;
    confirmInvestViewController.hidesBottomBarWhenPushed = YES;
    [vc.navigationController pushViewController:confirmInvestViewController animated:YES];
}

// 跳转到互助列表
- (void)jumpToCooperationListController
{
    [[LTNCore globleCore] backToDiscoverController];
    UIViewController * vc = [self jumpToDiscoverController];
    if(vc && [vc isKindOfClass:[LTNDiscoverViewController class]]){
        LTNDiscoverViewController * discoverController = (LTNDiscoverViewController * )vc;
        SEL action = NSSelectorFromString(@"goToCooperationListController");
        if([discoverController respondsToSelector:action]){
            [discoverController performSelector:action withObject:nil afterDelay:0.0f];
        }
    }
}

// 跳转到众筹列表
- (void)jumpToCrowdfundingListController
{
    [[LTNCore globleCore] backToDiscoverController];
    UIViewController * vc = [self jumpToDiscoverController];
    if(vc && [vc isKindOfClass:[LTNDiscoverViewController class]]){
        LTNDiscoverViewController * discoverController = (LTNDiscoverViewController * )vc;
        SEL action = NSSelectorFromString(@"goToCrowdfundingListController");
        if([discoverController respondsToSelector:action]){
            [discoverController performSelector:action withObject:nil afterDelay:0.0f];
        }
    }
}

-(void)jumpToWebviewController:(NSString *)urlString{
    NotificationWebViewController * webViewController = [[NotificationWebViewController alloc] initWithURL:urlString];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:webViewController];
    [[LTNCore globleCore].tabbarController presentViewController:navController animated:YES completion:nil];
}



#pragma mark end

+(void)presentViewController:(Class)controllerClass withFinishBlock:(VoidBlock)finishBlock{
    //TODO:code review zhangtongke 修改跳转模式
    [LTNCore presentViewController:controllerClass withFinishBlock:finishBlock animated:YES];
    
}


+(void)presentViewController:(Class)controllerClass withFinishBlock:(VoidBlock)finishBlock animated:(BOOL)animated{
    //TODO:code review zhangtongke 修改跳转模式
    UIViewController *controller = [(UIViewController *)[controllerClass alloc] init];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:controller];
    navController.finishBlock=finishBlock;
    [[LTNCore globleCore].tabbarController presentViewController:navController animated:animated completion:nil];
    
}



-(void)loginController:(VoidBlock)finishBlock{
    

//    LTNLoginController * loginController = [LTNLoginController loginControllerWithFinishBlock:^{
//        
//        
//        [self.tabbarController setSelectedIndex:2];
//    }];

    LTNLoginController * loginController = [LTNLoginController loginControllerWithFinishBlock:nil];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:loginController];
    navController.finishBlock=finishBlock;
    [self.tabbarController presentViewController:navController animated:YES completion:nil];
    /*
    [UIView transitionFromView:[LTNCore keyWindow].rootViewController.view
                        toView:navController.view
                      duration:0.50
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:^(BOOL finished)
     {
         [[LTNCore keyWindow] setRootViewController:navController];
     }];
     */
}

+(void)resetPassword{
    LTNRetrieveController * retrieveController = [[LTNRetrieveController alloc] init];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:retrieveController];
   
    navController.finishBlock=^{
        [[LTNCore globleCore] loginController:^(void){
            
        }];
    };
    [[LTNCore globleCore].tabbarController presentViewController:navController animated:YES completion:nil];
    
}

-(void)registerController:(VoidBlock)finishBlock{
    
    LTNRegisterController * loginController = [LTNRegisterController registerControllerWithFinishBlock:finishBlock];
    
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:loginController];
    navController.finishBlock=finishBlock;
    [self.tabbarController presentViewController:navController animated:YES completion:nil];
    
}

+(void)verifyRealNameViewController:(VoidBlock)finishBlock{
    
    VerifyRealNameViewController * controller = [[VerifyRealNameViewController alloc] init];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:controller];
    navController.finishBlock=finishBlock;
    [[LTNCore globleCore].tabbarController presentViewController:navController animated:YES completion:nil];
    
}


+(void)boundBankCardViewController:(VoidBlock)finishBlock{
    
    BoundBankCardViewController * controller = [[BoundBankCardViewController alloc] init];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:controller];
    navController.finishBlock=finishBlock;
    [[LTNCore globleCore].tabbarController presentViewController:navController animated:YES completion:nil];
    
}

+(void)secondBoundBandCardViewController:(VoidBlock)finishBlock{
    
    SecondBoundBandCardViewController * controller = [[SecondBoundBandCardViewController alloc] init];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:controller];
    navController.finishBlock=finishBlock;
    [[LTNCore globleCore].tabbarController presentViewController:navController animated:YES completion:nil];
    
}

+(void)showBankInfoViewController:(VoidBlock)finishBlock{
    
    ShowBankInfoController * controller = [[ShowBankInfoController alloc] init];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:controller];
    navController.finishBlock=finishBlock;
    [[LTNCore globleCore].tabbarController presentViewController:navController animated:YES completion:nil];
    
}


+(void)rechargeViewController:(VoidBlock)finishBlock{
    
    RechargeViewController * controller = [[RechargeViewController alloc] init];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:controller];
    navController.finishBlock = finishBlock;
    [[LTNCore globleCore].tabbarController presentViewController:navController animated:YES completion:nil];
    
}


+(void)chargeViewController:(VoidBlock)finishBlock{
    
    ChargeViewController * controller = [[ChargeViewController alloc] init];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:controller];
    navController.finishBlock=finishBlock;
    [[LTNCore globleCore].tabbarController presentViewController:navController animated:YES completion:nil];
    
}





+(void)gesturePasswordController{
    
    /*
    GesturePasswordController *gesturePasswordController=[GesturePasswordController gesturePasswordController:^{
        [self.tabbarController dismissViewControllerAnimated:YES
                                                  completion:^(void){
                                                      // Code
                                                  }];
    }   ];
     */
    
    
    
    
    
    
    
    
    if(![[CurrentUser mine] hasLogged])
        return;
    
    
//    if(![GesturePasswordController existKeychainPassword])
//        return;
    
    
//    [LTNServerHelper retrieveAccountInfoWithFinishBlock:^{
//        
//    }];
//    [LTNServerHelper retrieveUserInfoWithFinishBlock:^(void){
//        
//    }];
    
    if(![LTNCore shouldShowGesturePassword])
        return;
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshInvestPage];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshHomePage];
    
    [LTNCore hiddenKeyboard];
    
    
    GesturePasswordController *gesturePasswordController;
    
    if(![GesturePasswordController existKeychainPassword]){
        gesturePasswordController=[GesturePasswordController createGesturePasswordController:^{
            
            [[LTNAlertWindow sharedWindow] dismissRootController];
            //TODO:block unuseful remove
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GestureSuccessNotification"
                                                                object:nil
                                                              userInfo:nil];
            
        }];
        
    }else{
        gesturePasswordController=[GesturePasswordController gesturePasswordController:^{
            
            //TODO:block unuseful remove
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GestureSuccessNotification"
                                                                object:nil
                                                              userInfo:nil];
            
        }];
        
    }
     
    
    
    /*
    
    GesturePasswordController *gesturePasswordController=[GesturePasswordController gesturePasswordController:^{
        
        //TODO:block unuseful remove
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GestureSuccessNotification"
                                                            object:nil
                                                          userInfo:nil];
        
    }];
     */

    GestureNavigationController * navController = [[GestureNavigationController alloc] initWithRootViewController:gesturePasswordController];
    
    //[[LTNCore globleCore].tabbarController presentViewController:navController animated:YES completion:nil];
    [[LTNAlertWindow sharedWindow] showRootViewController:navController];
 
}


+(void)gesturePasswordControllerWithBlock:(VoidBlock)block{
    
    /*
     GesturePasswordController *gesturePasswordController=[GesturePasswordController gesturePasswordController:^{
     [self.tabbarController dismissViewControllerAnimated:YES
     completion:^(void){
     // Code
     }];
     }   ];
     */
    
    
    
    
    
    
    
    
    if(![[CurrentUser mine] hasLogged]){
        block();
        return;
    }
    

    
    
//    [LTNServerHelper retrieveAccountInfoWithFinishBlock:^{
//        
//    }];
//    [LTNServerHelper retrieveUserInfoWithFinishBlock:^(void){
//        
//        
//    }];
    
    if(![LTNCore shouldShowGesturePassword]){
        block();
        return;
    }
    
    
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshInvestPage];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshHomePage];
    
    [LTNCore hiddenKeyboard];
    
    GesturePasswordController *gesturePasswordController;
    
    if(![GesturePasswordController existKeychainPassword]){
        gesturePasswordController=[GesturePasswordController createGesturePasswordController:^{
            
            [[LTNAlertWindow sharedWindow] dismissRootController];
            block();
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GestureSuccessNotification"
                                                                object:nil
                                                              userInfo:nil];
        }];
        
       
    }else{
        
        gesturePasswordController=[GesturePasswordController gesturePasswordController:^{
            
            block();
            //TODO:block unuseful remove
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GestureSuccessNotification"
                                                                object:nil
                                                              userInfo:nil];
            
            
        }];

        
    }
    
    
    
    GestureNavigationController * navController = [[GestureNavigationController alloc] initWithRootViewController:gesturePasswordController];
    
    //[[LTNCore globleCore].tabbarController presentViewController:navController animated:YES completion:nil];
    [[LTNAlertWindow sharedWindow] showRootViewController:navController];
    
}


+(void)poundGoldenEggsController:(NSString *)urlString{
    
//    if(!([urlString hasPrefix:@"http://"]||[urlString hasPrefix:@"https://"])){
//        urlString = [NSString stringWithFormat:@"%@%@", API_BASE_URL, urlString];
//    }
//
//    PoundGoldenEggsController *controller=[[PoundGoldenEggsController alloc] initWithURL:urlString];
//    
//    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:controller];
//    [[LTNCore globleCore].tabbarController presentViewController:navController animated:YES completion:nil];

}

-(void)createNewGesturePassword{
    
    
    
}


@end
