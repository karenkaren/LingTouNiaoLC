//
//  LTNCore+Helper.m
//  lingtouniao
//
//  Created by  mathe on 15/12/17.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNSystemInfo.h"
#import "LTNTabBarController.h"

#import "KeychainItemWrapper.h"
#import "GesturePasswordController.h"

@implementation LTNCore (Helper)
#define kESUserDefaultsKey_CheckFreshLaunchAppVersion @"es_check_fresh_launch_app_version"
#define kLastTimeWhenApplicationDidEnterBackground @"kLastTimeWhenApplicationDidEnterBackground"
+ (BOOL)isFreshLaunch:(NSString **)previousAppVersion
{
    static NSString *__previousVersion = nil;
    static BOOL __isFreshLaunch = NO;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __previousVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kESUserDefaultsKey_CheckFreshLaunchAppVersion];
        NSString *current = [LTNSystemInfo appVersion];
        if (__previousVersion && [__previousVersion compare:current] == NSOrderedSame) {
            __isFreshLaunch = NO;
        } else {
            __isFreshLaunch = YES;
            [[NSUserDefaults standardUserDefaults] setObject:current forKey:kESUserDefaultsKey_CheckFreshLaunchAppVersion];
            [self initNewVersion];
        }
    });
    
    if (previousAppVersion) {
        *previousAppVersion = __previousVersion;
    }
    return __isFreshLaunch;
}

+ (void)deleteAllHTTPCookies
{
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *c in cookieStorage.cookies) {
        [cookieStorage deleteCookie:c];
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}



#pragma mark IQKeyboardManager

-(void)initIQKeyboardManager{
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside     = YES;
    [IQKeyboardManager sharedManager].shouldShowTextFieldPlaceholder = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar              = NO;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField  = 80;
    [[IQKeyboardManager sharedManager] setEnable:NO];
}


+(BOOL)HaveGesturePassword{
    KeychainItemWrapper * keychin = [[KeychainItemWrapper alloc]initWithIdentifier:@"Gesture" accessGroup:nil];
    NSString * password = [keychin objectForKey:(__bridge id)kSecValueData];
    if ([password isEqualToString:@""]) {
        return NO;
    }
    else {
        return YES;
    }
}



+(void)popToRootControllers{
    
    [[LTNAlertWindow sharedWindow] dismissRootController];
    [LTNCore globleCore].tabbarController=[[LTNTabBarController alloc] init];
    [[LTNCore mainWindow]  setRootViewController:[LTNCore globleCore].tabbarController];

    //    NSArray *rootControllers = [LTNCore globleCore].tabbarController.viewControllers;
//    
//    for(UIViewController *viewController in rootControllers){
//        
//        UINavigationController * navController=(UINavigationController *)viewController;
//        if([navController.viewControllers count]>1)
//            [navController popToRootViewControllerAnimated:YES];
//     
//    }
    
}


+(void)saveLastTimeWhenApplicationDidEnterBackground{
    if([GesturePasswordController existKeychainPassword]){
        NSDate *nowDate=[NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:[nowDate dateByAddingTimeInterval:30]
                                                  forKey:kLastTimeWhenApplicationDidEnterBackground];

    }
}

+(void)removeLastTimeWhenApplicationDidEnterBackground{
    if([GesturePasswordController existKeychainPassword]){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLastTimeWhenApplicationDidEnterBackground];
        
    }
}


+(BOOL)shouldShowGesturePassword{
    
    NSDate *canVerifyGestureTime=[[NSUserDefaults standardUserDefaults] objectForKey:kLastTimeWhenApplicationDidEnterBackground];
    if(canVerifyGestureTime){
        NSDate *nowDate=[NSDate date];
        if([canVerifyGestureTime compare:nowDate]!=NSOrderedDescending)
            return YES;
        else
            return NO;
        
    }
    return YES;
}



+(BOOL)shouldShowCurrentInvestment{
    BOOL showCurrentInvestment= [CurrentUser mine].accountInfo.sxtIsShow;
    return showCurrentInvestment;
}

+(BOOL)shouldShowOfflineInvestment{
    BOOL showOfflineInvestment= [CurrentUser mine].accountInfo.axtIsShow;
    return showOfflineInvestment;
}


#pragma mark  EvaluateAlertView-------------------------

/**
 //
 去评价->到App Store->作为一个参数记到本地，除非有版本新需求需要清理掉这个参数，否则以后不再弹出
 拒绝->这个版本周期内不再出现
 我再想想->至少21天后，会再弹出一次
 
*/


#define ShouldClearUpEvaluate NO //版本新需求需要清理掉这个参数

#if (defined(DEBUG) || defined(ADHOC))
    #define firstEvaluateShowTime 20
    #define secondEvaluateShowTime 50
#else
    #define firstEvaluateShowTime 60*60*24*7
    #define secondEvaluateShowTime 60*60*24*21
#endif

+(void)initNewVersion{
    
    [[NSUserDefaults standardUserDefaults] setObject:[[NSDate date] dateByAddingTimeInterval:firstEvaluateShowTime]
                                              forKey:@"kFutureEvaluatedTime"];
    if(ShouldClearUpEvaluate){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kHadEvaluated"];
        
    }
}

+(BOOL)shouldShowEvaluateAlertView{
    BOOL HadEvaluated=esBool([[NSUserDefaults standardUserDefaults] valueForKey:@"kHadEvaluated"]);
    if(HadEvaluated)
        return NO;
    else{
        NSDate *futureEvaluatedTime=[[NSUserDefaults standardUserDefaults] objectForKey:@"kFutureEvaluatedTime"];
        if(futureEvaluatedTime){
            NSDate *nowDate=[NSDate date];
            if([futureEvaluatedTime compare:nowDate]!=NSOrderedDescending)
                return YES;
            else
                return NO;
        }else{
            return YES;
        }
  
    }
   
}

+(BOOL)evaluateAlertViewExist {
    for (UIWindow* window in [UIApplication sharedApplication].windows) {
        for (UIView* view in window.subviews) {
            BOOL alert = [view isKindOfClass:[UIAlertView class]];
            if (alert&&view.tag==10001)
                return YES;
        }
    }
    return NO;
}


+(BOOL)hiddenKeyboard{
    for (UIWindow* window in [UIApplication sharedApplication].windows) {
        for (UIView* view in window.subviews) {
            [view endEditing:YES];
        }
    }
    return NO;
}






+(void)showEvaluateAlertView{
    [[LTNCore globleCore] performSelector:@selector(startShowEvaluateAlertView) withObject:nil afterDelay:5];
}

-(void)startShowEvaluateAlertView{
    //TODO: alertView
    if(![LTNCore shouldShowEvaluateAlertView])
        return;
    
    if(![[LTNCore mainWindow] isKeyWindow])
        return;
    if([LTNCore globleCore].tabbarController.presentedViewController)
        return;
    
    
    if([LTNCore globleCore].haveShowEvaluateAlertView)
        return;
    
    [LTNCore globleCore].haveShowEvaluateAlertView=YES;
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:locationString(@"comment_title") message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:locationString(@"comment_good"),locationString(@"comment_refuse"),locationString(@"think_again"), nil];
    alert.tag=10001;
    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [Utility openURL:[NSURL URLWithString:kRatingUrl]];
            [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:@"kHadEvaluated"];
            
        }else if (buttonIndex == 1){
            [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:@"kHadEvaluated"];
            
        }else if (buttonIndex == 2){
            [[NSUserDefaults standardUserDefaults] setObject:[[NSDate date] dateByAddingTimeInterval:secondEvaluateShowTime]
                                                      forKey:@"kFutureEvaluatedTime"];
            
            
            
        }
    }];
}


@end
