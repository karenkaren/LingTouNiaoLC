//
//  CurrentUser+Helper.m
//  lingtouniao
//
//  Created by  mathe on 15/12/17.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "CurrentUser.h"

@implementation CurrentUser (Helper)


+(BOOL)setUserInfoWithDic:(NSDictionary *)userInfo{
    if(![[CurrentUser mine] hasLogged])
        return NO;
    [CurrentUser mine].userInfo = [UserInfoModel mj_objectWithKeyValues:userInfo];
    return YES;
}

+(BOOL)setAccountInfoWithDic:(NSDictionary *)accountInfo{
    if(![[CurrentUser mine] hasLogged])
        return NO;
    
    [CurrentUser mine].accountInfo = [AccountInfoModel mj_objectWithKeyValues:accountInfo];
    
    return YES;
}

+(BOOL)verifyedRealName{
    if(![[CurrentUser mine] hasLogged])
        return NO;
    return  [[CurrentUser mine].userInfo.certification boolValue];
}

+(BOOL)bindedBankCard{
    if(![[CurrentUser mine] hasLogged])
        return NO;
    return  [[CurrentUser mine].userInfo.bankAuthStatus boolValue];
    
}


+ (void)userLogoutSuccess:(SuccessBlock)success failure:(FailureBlock)failure{

    [LTNServerHelper logoutSuccess:^(id response) {
        //
        [[CurrentUser mine] reset];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_Exit_Success object:nil];
        success(nil);
    } failure:^(NSError *error) {
        DLog(@"%@", error.localizedDescription);
        //failure(error);
        [[CurrentUser mine] reset];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_Exit_Success object:nil];
        success(nil);
    }];
    
}

-(NSString *)userNameForGesturePassword{
    NSString *userName=[CurrentUser mine].userInfo.userName;
    if(userName&& [userName length]>0)
        return userName;
    else{
        return [CurrentUser mine].userInfo.mobile;
    }
}

@end
