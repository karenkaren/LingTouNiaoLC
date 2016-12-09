//
//  InvestSuccessViewController.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/10/9.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "InvestSuccessViewController.h"
#import "GoldenEggsViewController.h"
#import "LTNSuccessView.h"
#import "LTNProductDetailController.h"
#import "LTNPartnerViewController.h"

@interface InvestSuccessViewController ()

@end

@implementation InvestSuccessViewController

- (void)initUIView {
    
    self.title = locationString(@"invest_success");
//    kWeakSelf
//    [self setupUIWithSuccessTitle:locationString(@"invest_success") buttonTitle:locationString(@"invest_complete") handle:^{
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshInvestPage];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshHomePage];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshAccountInfo];
//        [weakSelf back];
//    }];
    
   // kWeakSelf
    [self setupUIWithSuccessTitle:locationString(@"invest_success") buttonTitle:@"返回账户" buttonInvestTitle:@"继续投资" buttonShareTitle:@"邀请好友投资" buttonInviteTitle:@"邀请好友，享合伙人额外收益" handle:^{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshInvestPage];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshHomePage];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshAccountInfo];
        //[weakSelf back];
        [[LTNCore globleCore] backToMoreController];
    }];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_hasGoldenEgg) {
        [self startShowGoldenEggs];
    }
}
- (void)back
{
    [TrackingUtility event:kTZSuccess];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//- (void)setupUI
- (void)setupUIWithSuccessTitle:(NSString *)successTitle buttonTitle:(NSString *)buttonTitle handle:(VoidBlock)handleBlock
{
//    kWeakSelf;
    LTNSuccessView * successView = [[LTNSuccessView alloc] initWithSuccessTitle:successTitle buttonTitle:buttonTitle actionBlock:^(UIButton *button) {
        if (handleBlock) {
            handleBlock();
        }
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshInvestPage];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshHomePage];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshAccountInfo];
//        [weakSelf back];
    }];
    [self.view addSubview:successView];
}

//- (void)setupUI
- (void)setupUIWithSuccessTitle:(NSString *)successTitle buttonTitle:(NSString *)buttonTitle buttonInvestTitle:(NSString *)investTitle buttonShareTitle:(NSString *)shareTitle buttonInviteTitle:(NSString *)inviteTitle handle:(VoidBlock)handleBlock
{
    LTNSuccessView * successView = [[LTNSuccessView alloc]initWithSuccessTitle:successTitle buttonTitle:buttonTitle buttonInvestTitle:investTitle buttonShareTitle:shareTitle buttonInviteTitle:inviteTitle actionBlock:^(UIButton *button) {
        if (handleBlock) {
            handleBlock();
        }
    } investBlock:^(UIButton *button) {
        [self jumpToProductDetailController];
    } shareBlock:^(UIButton *button) {
        [self shareToFriends];
    } inviteBlock:^(UIButton *button) {
        [self jumpToPartnerController];
    }];
    
    [self.view addSubview:successView];
}
//跳到详情页
-(void)jumpToProductDetailController{
    
    NSArray *vcs = self.navigationController.viewControllers;
    UIViewController *popToVC;
    for(UIViewController *controller in vcs){
        if([controller isKindOfClass:[LTNProductDetailController class]]){
            popToVC=controller;
            break;
        }
    }
    
    [self.navigationController popToViewController:popToVC animated:YES];

}
//分享
- (void)shareToFriends
{
    [ShareSnsUtils shareSnsOnViewController:self delegate:self];
}

-(void)jumpToPartnerController{
    LTNPartnerViewController *partner =[[LTNPartnerViewController alloc]init];
    partner.ownName = [CurrentUser mine].userInfo.userName;
    [self.navigationController pushViewController:partner animated:YES];
}

/**
 *  显示砸金蛋界面
 */
-(void)startShowGoldenEggs
{
    
    UIWindow *keyWindow = [[[UIApplication sharedApplication]delegate]window];
    
    GoldenEggsViewController *goldenEggsViewController = [[GoldenEggsViewController alloc]init];
    goldenEggsViewController.goldenEggsWindow = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    goldenEggsViewController.goldenEggsWindow.bottom = 0;
    UINavigationController *navGoldenEggsViewController = [[UINavigationController alloc]initWithRootViewController:goldenEggsViewController];
    goldenEggsViewController.goldenEggsWindow.rootViewController = navGoldenEggsViewController;
    [keyWindow addSubview:goldenEggsViewController.goldenEggsWindow];
    [UIView animateWithDuration:0.5 animations:^{
        goldenEggsViewController.goldenEggsWindow.top = 0;
    }];
    [goldenEggsViewController.goldenEggsWindow setWindowLevel:UIWindowLevelAlert];
    [goldenEggsViewController.goldenEggsWindow makeKeyAndVisible];
    __weak typeof(self) weakSelf = self;
    __weak typeof(goldenEggsViewController) weakGoldenEggsViewController = goldenEggsViewController;
    [goldenEggsViewController setInvestCallBack:^{
        weakGoldenEggsViewController.goldenEggsWindow.hidden = YES;
        [weakSelf.navigationController popToRootViewControllerAnimated:NO];
        [LTNCore globleCore].tabbarController=[[LTNTabBarController alloc] init];
        [[LTNCore mainWindow]  setRootViewController:[LTNCore globleCore].tabbarController];
        
    }];
}


@end
