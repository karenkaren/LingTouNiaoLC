//
//  AppDelegate.m
//  lingtouniao
//
//  Created by LiuFeifei on 15/11/10.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "AppDelegate.h"
#import "LTNNetHelper.h"
#import "WXApi.h"
#import "JPUSHService.h"
#import "TalkingDataAppCpa.h"
#import "NetDataCacheManager.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialWhatsappHandler.h"
#import "UMSocialLineHandler.h"
#import "UMSocialTumblrHandler.h"
#import "BaseDataEngine.h"
#import "PiwikTracker.h"

static NSString * const PiwikTestServerURL = @"http://192.168.18.210";
static NSString * const PiwikTestSiteID = @"3";
static NSString * const PiwikTestSiteID1 = @"6";

static NSString * const PiwikProductionServerURL = @"http://log.lingtouniao.cn";
static NSString * const PiwikProductionSiteID = @"3";
static NSString * const PiwikProductionSiteID1 = @"6";

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 监听网络状态
    [LTNNetHelper moniterNetworking];
    
#ifdef DEBUG
    [PiwikTracker sharedInstanceWithSiteID:PiwikTestSiteID baseURL:[NSURL URLWithString:PiwikTestServerURL]];
    [PiwikTracker sharedInstanceWithSiteID1:PiwikTestSiteID1 baseURL:[NSURL URLWithString:PiwikTestServerURL]];
#else
    [PiwikTracker sharedInstanceWithSiteID:PiwikProductionSiteID baseURL:[NSURL URLWithString:PiwikProductionServerURL]];
    [PiwikTracker sharedInstanceWithSiteID1:PiwikProductionSiteID1 baseURL:[NSURL URLWithString:PiwikProductionServerURL]];
#endif
    
    // Print events to the console
    //[PiwikTracker sharedInstance].debug = YES;
    [PiwikTracker sharedInstance].dispatchInterval = 0;
    [PiwikTracker sharedInstance1].dispatchInterval = 0;
    
    //clean up temp data
    [self cleanup];
    
    // 分享设置
    [self shareSetting];

    [TrackingUtility startTracking];
    [self addTalkingDataAnalysis];

    [Utility customizeNavigationBar:[UIColor whiteColor] fontSize:18 fontColor:[UIColor blackColor]];

    [LTNNetHelper configHttpManager];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [NSThread sleepForTimeInterval:2.0];
    
    [[LTNCore globleCore] firstLaunch];
    [self.window makeKeyAndVisible];
    
    [self setupJPush:launchOptions];
        
    
    
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知launchOptions"
                                                    message:[launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey] description]
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
        
    }];

     */

    /*
    //杀死程序 进入后台 通过推送打开都可以在后台收到推送 ios8  可以把launch里的推送处理去掉
     */
//    [AppDelegate handleRemoteNotification:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]];
    
    NSLog(@"=cacheDirectory====%@",[NetDataCacheManager cacheDirectory]);
    
    return YES;
}


-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    if(!url){
        return NO;
    }
    
    [self handleURLString:url];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options{
    
    [self handleURLString:url];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    [self handleURLString:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}

-(void)handleURLString:(NSURL *)url{
    
    if(!url)
        return;
   
    NSString *urlString=url.absoluteString;
    if(!urlString||urlString.length ==0)
        return;
    
    NSRange range = [urlString rangeOfString:@"com.wy.lingtouniao://app?url="];
    NSString *urlPara=@"";
    if(range.location !=NSNotFound){
        urlPara=esString([[urlString substringFromIndex:range.location+range.length] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    }
   
    //  NSString *urlPara=esString([urlString substringFromIndex:range.location+range.length]);
    if([urlPara length]==0)
        return;
    [AppDelegate pushNotificationAction:@{@"url":urlPara}];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [LTNCore saveLastTimeWhenApplicationDidEnterBackground];
    [application setApplicationIconBadgeNumber:0];
    [JPUSHService resetBadge];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [LTNCore showEvaluateAlertView];

    [LTNCore gesturePasswordController];
    [application setApplicationIconBadgeNumber:0];
    [JPUSHService resetBadge];
    
    //synRescource if needed
    [[LTNCore globleCore] synRescource];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [LTNCore removeLastTimeWhenApplicationDidEnterBackground];

    //remove all caches
    [LTNCore deleteAllHTTPCookies];
}

- (void)addTalkingDataAnalysis
{
    if (([[UIDevice currentDevice].systemVersion doubleValue] >= 6.0f)) {
#if (!defined(DEBUG) && !defined(ADHOC))
        [TalkingDataAppCpa setVerboseLogDisabled];
#endif

        [TalkingDataAppCpa init:@"96f668b2463648019fc75572d43cd0e2" withChannelId:@"AppStore"];
    }
}

//for anything you want to clean during a clean setup
- (void)cleanup {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAutoClick];
    [LTNCore removeLastTimeWhenApplicationDidEnterBackground];
}

// 友盟分享设置
- (void)shareSetting
{
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UMENG_APP_KEY];
    
    //打开调试log的开关
    [UMSocialData openLog:YES];
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:WECHAT_APP_ID appSecret:WECHAT_APP_SECRET url:[CurrentUser urlForShare]];
    
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:QQ_APP_ID appKey:QQ_APP_KEY url:[CurrentUser urlForShare]];
    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
    
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。需要 #import "UMSocialSinaSSOHandler.h"
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:SINA_APP_KEY secret:SINA_APP_SECRET RedirectURL:SINA_APP_REDIRECT_URL];
    
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToSina, UMShareToWechatSession, UMShareToWechatTimeline]];
}

@end
