//
//  AppDelegate+JPush.m
//  lingtouniao
//
//  Created by zhangtongke on 16/2/18.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "AppDelegate.h"



#import <UserNotifications/UserNotifications.h>
#import <AdSupport/ASIdentifierManager.h>


/*
#if (defined(DEBUG) || defined(ADHOC))
#define JPushIsProduction NO // 发布环境为YES 开发环境为NO
//static NSString *appKey = @"f613444543f2b750182929d7";
//static NSString *channel = @"Publish channel";

static NSString *appKey = @"b3aa9dbccfbef354b8810362";
static NSString *channel = @"Publish channel";
#else
#define JPushIsProduction YES // 发布环境为YES 开发环境为NO

#if (defined(DEBUG) || defined(ADHOC))


//static NSString *appKey = @"46005adb955b312bd9a713a2";
//static NSString *channel = @"Publish channel";

static NSString *appKey = @"b3aa9dbccfbef354b8810362";
static NSString *channel = @"Publish channel";


#else

static NSString *appKey = @"b3aa9dbccfbef354b8810362";
static NSString *channel = @"Publish channel";

#endif


#endif

*/

#define JPushIsProduction YES // 发布环境为YES 开发环境为NO
static NSString *appKey = @"b3aa9dbccfbef354b8810362";
static NSString *channel = @"Publish channel";



@implementation AppDelegate (JPush)
-(void)setupJPush:(NSDictionary *)launchOptions{
    [self registerRemoteNotification];
    
    
    /*
    //iOS10
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        if (granted) {
            //点击允许
            NSLog(@"注册通知成功");
            [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                NSLog(@"%@", settings);
            }];
        } else {
            //点击不允许
            NSLog(@"注册通知失败");
        }
        
    }];
    
     */
    //[[UIApplication sharedApplication] registerForRemoteNotifications];
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]; //Required
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:JPushIsProduction
            advertisingIdentifier:advertisingId];
    
    NSLog(@"appKeyappKey=%@",appKey);
    
    
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];

}


-(void)registerRemoteNotification{
    
    /*
     
     */
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self selector:@selector(networkDidSetup:) name:kJPFNetworkDidSetupNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidClose:) name:kJPFNetworkDidCloseNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidRegister:) name:kJPFNetworkDidRegisterNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidLogin:) name:kJPFNetworkDidLoginNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}


- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    
    //    JPUSHService 　setAlias:@"zhangegir" callbackSelector:<#(SEL)#> object:(id)
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:trackName
    //                                                        message:[NSString stringWithFormat:@"alias = %@",alias]
    //                                                       delegate: self
    //                                              cancelButtonTitle:locationString(@"btn_cancel")
    //                                              otherButtonTitles:  nil];
    //        [alert show];
    
    
}


- (void)networkDidSetup:(NSNotification *)notification {
    
}

- (void)networkDidClose:(NSNotification *)notification {
    
}

- (void)networkDidRegister:(NSNotification *)notification {
    //TODO:save to server
}

- (void)networkDidLogin:(NSNotification *)notification {
    //TODO:save to server？？
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    //NSDictionary *extras = [userInfo objectForKey:@"extras"];
    //UIApplication *application = [UIApplication sharedApplication];
    
    [AppDelegate handleRemoteNotification:userInfo];
    
    //[[DSCore globleCore] coreReceiveMessage:notification];
    
}


#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center
        willPresentNotification:(UNNotification *)notification
          withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [AppDelegate handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); //                    Badge Sound Alert
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [AppDelegate handleRemoteNotification:userInfo];
    }
    completionHandler(); //
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
    
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
    
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    [AppDelegate handleRemoteNotification:userInfo];
    
    
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    [AppDelegate handleRemoteNotification:userInfo];
    
    
    completionHandler(UIBackgroundFetchResultNewData);
}



- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}




+(void)handleRemoteNotification:(NSDictionary *)notiDic{
    if(!notiDic)
        return;
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        NSLog(@"active");
        //程序当前正处于前台
        //TODO:
        
        NSString *msg=@"";
        if(notiDic[@"aps"]&&isDictionary(notiDic[@"aps"])){
            msg=notiDic[@"aps"][@"alert"];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:locationString(@"notification")
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:locationString(@"btn_confirm")
                                              otherButtonTitles:locationString(@"go_look"),nil];
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self pushNotificationAction:notiDic];
            }
        }];
        
    }
    else if([UIApplication sharedApplication].applicationState == UIApplicationStateInactive)
    {
        NSLog(@"inactive");
        
        
        
        
        [self pushNotificationAction:notiDic];
        
    }
}


+(void)pushNotificationAction:(NSDictionary *)notiDic{
    
    NSString *url=esString(notiDic[@"url"]);
    if([url isEqualToString:@"my/product/status/4"]){
        [[LTNCore globleCore] jumpToMyIncometSatement];
    }else if([url isEqualToString:@"my/product/status/3"]){
        [[LTNCore globleCore] jumpToMyIncometSatement];
    }else if([url isEqualToString:@"my/product/status/2"]){
        [[LTNCore globleCore] jumpToMyInvestment];
    }else if([url isEqualToString:@"coupon/notice"]){
        [[LTNCore globleCore] jumpToMyTicketList];
    }else if([url hasPrefix:@"product"]){
        NSArray *stringArray = [url componentsSeparatedByString:@"/"];
        if([stringArray count]>1&&[esString(stringArray[1]) length]>0)
            [[LTNCore globleCore] jumpToProductDetailController:esString(stringArray[1])];
        
        
    }else if([url hasPrefix:@"http"]||[url hasPrefix:@"https"]){
        [[LTNCore globleCore] jumpToWebviewController:url];
        
    }
}





@end
