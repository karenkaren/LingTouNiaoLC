//
//  LTNTabBarController.m
//  lingtouniao
//
//  Created by  mathe on 15/12/16.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNTabBarController.h"
#import "LTNHomeController.h"
#import "LTNInvestmentController.h"
#import "LTNAccountController.h"
#import "LTNMoreController.h"
#import "LTNDiscoverViewController.h"

@interface LTNTabBarController ()<UITabBarControllerDelegate>

@end

@implementation LTNTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //ea5504
    
    
    //self.tabBar.barTintColor = [UIColor blackColor];
    //self.tabBar.translucent = false;
    //[[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
    self.delegate=self;
    [self creatControllers];

    // Do any additional setup after loading the view.
}

-(void)creatControllers
{    
    // 1.首页
    LTNHomeController * home = [[LTNHomeController alloc] init];
    UINavigationController * homeNav = [[UINavigationController alloc] initWithRootViewController:home];
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:locationString(@"tab_main1")
                                                        image:[UIImage imageNamed:@"tab_home_normal"]
                                                selectedImage:[UIImage imageNamed:@"tab_home_selected"]];
    home.tabBarItem = item1;
    
    // 2.投资理财
    LTNInvestmentController * investment = [[LTNInvestmentController alloc] init];
    UINavigationController * investmentNav = [[UINavigationController alloc] initWithRootViewController:investment];
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:locationString(@"tab_investiment1")
                                                        image:[UIImage imageNamed:@"tab_list_normal"]
                                                selectedImage:[UIImage imageNamed:@"tab_list_selected"]];
    investmentNav.tabBarItem=item2;
    
    //3.发现
    LTNDiscoverViewController *discover = [[LTNDiscoverViewController alloc]init];
    UINavigationController *discoverNav = [[UINavigationController alloc]initWithRootViewController:discover];
    UITabBarItem *item3 = [[UITabBarItem alloc]initWithTitle:locationString(@"tab_discover") image:[UIImage imageNamed:@"tab_discover_normal"] selectedImage:[UIImage imageNamed:@"tab_discover_selected"]];
    discoverNav.tabBarItem = item3;
    
    
    // 4.我的帐号
    LTNAccountController * account = [[LTNAccountController alloc] init];
    UINavigationController * accountNav = [[UINavigationController alloc] initWithRootViewController:account];
    UITabBarItem *item4 = [[UITabBarItem alloc] initWithTitle:locationString(@"tab_account1")
                                                        image:[UIImage imageNamed:@"tab_account_normal"]
                                                selectedImage:[UIImage imageNamed:@"tab_account_selected"]];
    accountNav.tabBarItem=item4;
    
    // 5.更多
    LTNMoreController * more = [[LTNMoreController alloc] init];
    UINavigationController * moreNav = [[UINavigationController alloc] initWithRootViewController:more];
    [self addChildViewController:moreNav];
    UITabBarItem *item5 = [[UITabBarItem alloc] initWithTitle:locationString(@"tab_more")
                                                        image:[UIImage imageNamed:@"tab_about_normal"]
                                                selectedImage:[UIImage imageNamed:@"tab_about_normal"]];
    moreNav.tabBarItem=item5;
    
    NSArray *controllers = [NSArray arrayWithObjects:homeNav,investmentNav,discoverNav,accountNav,nil];
    self.viewControllers=controllers;
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    
    
    /*
    
    NSInteger aaa=tabBarController.selectedIndex;
    
    if(aaa>=1){
        
        //NSMutableString *string=[NSMutableString string];
        NSString *string;
        if(aaa==1)
            string=@"oneone";
        else if(aaa==2){
            string=@"twotwo";
        }else{
            string=@"threethree";
        }
        for(int i=1;i<=aaa;i++){
            [[PiwikTracker sharedInstance] setCustomVariableForIndex:i name:[NSString stringWithFormat:@"%@%d",string,i] value:[NSString stringWithFormat:@"%d",i] scope:ScreenCustomVariableScope];
        }

        
    }
    
    
    
    [[PiwikTracker sharedInstance] sendEventWithCategory:@"ios" action:@"Tab" name:@"Thrive" value:@(10000+tabBarController.selectedIndex)];
    
    
    
    

    
    
    [[PiwikTracker sharedInstance] dispatch];
     
     */
    
//    [LTNCore secondBoundBandCardViewController:nil];
//    return YES;
    
    if([[CurrentUser mine] hasLogged])
        return YES;
    else{
        UINavigationController * navController=(UINavigationController *)viewController;
        if([navController.topViewController isKindOfClass:[LTNAccountController class]]){
     
//            [LTNCore presentViewController:[LTNLoginController class] withFinishBlock:^(void){
//                [self setSelectedIndex:2];
//            }];
            
            [[LTNCore globleCore] loginController:^(void){
                [self setSelectedIndex:3];
                
            }];
            
            return NO;
           
        }
        return YES;
        
    }
    
    return YES;
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
