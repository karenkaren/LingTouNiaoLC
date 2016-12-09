//
//  AppDelegate.h
//  lingtouniao
//
//  Created by LiuFeifei on 15/11/10.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JPUSHService.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) NSInteger numberRows;

@end


@interface AppDelegate (JPush)<JPUSHRegisterDelegate>
-(void)setupJPush:(NSDictionary *)launchOptions;
-(void)registerRemoteNotification;
+(void)handleRemoteNotification:(NSDictionary *)notiDic;
+(void)pushNotificationAction:(NSDictionary *)notiDic;
@end

