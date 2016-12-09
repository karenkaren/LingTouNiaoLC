//
//  GesturePasswordController.h
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "TentacleView.h"
#import "GesturePasswordView.h"
#import "GestureNavigationController.h"

@interface GesturePasswordController : UIViewController <VerificationDelegate,ResetDelegate,GesturePasswordDelegate>

@property (nonatomic,copy)void (^dissmissBlock)(void);
@property (nonatomic,copy)void (^finishBlock)(void);//TODO:????

+(instancetype)createGesturePasswordController:(void (^)(void))dissmissBlock;
+(instancetype)modifyGesturePasswordController;
+(instancetype)gesturePasswordController:(void (^)(void))finishBlock;

+ (BOOL)existKeychainPassword;
+ (void)clearKeychainPassword;

@end
