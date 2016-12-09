//
//  CurrentUser.h
//  lingtouniao
//
//  Created by  mathe on 15/12/17.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNUser.h"

#define kUserDefaultsKey_Mine   @"kUserDefaultsKey_Mine"
#define kUserSessionKey_Mine    @"kUserSessionKey_Mine"
#define kDefaultUserInfoKey @"defaultUserInfo"
#define kUserNameKey @"userNameKey"

@interface CurrentUser : LTNUser

@property (nonatomic,copy)NSString *dtUrl;

@property (nonatomic,copy)NSString *sessionKey;

@property (nonatomic)BOOL haveNotShowEggToday;//砸蛋弹出

+ (instancetype)mine;

+(void)loginSuccess:(NSString *)sessionKey;

//是否登录
- (BOOL)hasLogged;

//退出登陆调用
- (void)reset;

- (void)save;

//是否登录
- (BOOL)isExpired;

+ (NSString *)urlForShare;


@end

@interface CurrentUser (Helper)

+(BOOL)setUserInfoWithDic:(NSDictionary *)userInfo;

+(BOOL)setAccountInfoWithDic:(NSDictionary *)accountInfo;

//是否实名认证
+(BOOL)verifyedRealName;
//是否绑定银行卡
+(BOOL)bindedBankCard;

 //退出登录
+ (void)userLogoutSuccess:(SuccessBlock)success failure:(FailureBlock)failure;


-(NSString *)userNameForGesturePassword;

@end

