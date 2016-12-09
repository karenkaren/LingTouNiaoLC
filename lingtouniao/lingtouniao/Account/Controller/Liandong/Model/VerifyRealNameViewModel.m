//
//  VerifyRealNameViewModel.m
//  lingtouniao
//
//  Created by 徐凯 on 15/12/23.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "VerifyRealNameViewModel.h"

@implementation VerifyRealNameViewModel
/**
 *  是否用户认证
 *
 *  @return <#return value description#>
 */
-(NSString *)certification
{
    return [CurrentUser mine].userInfo.certification;
}
/**
 *  用户姓名
 *
 *  @return <#return value description#>
 */
-(NSString *)userName
{
    return [CurrentUser mine].userInfo.userName;
}
/**
 *  身份证id
 *
 *  @return <#return value description#>
 */
-(NSString *)cardId
{
    return [CurrentUser mine].userInfo.cardId;

}

-(void)GET_UserAuthWith:(NSString *)userName identityCode:(NSString *)identityCode success:(void(^)(BOOL hasUserAuth))onSuccess  failure:(void(^)(NSString *error))onFailure
{
    
    [LTNServerHelper userAuthWith:userName identityCode:identityCode success:^(BOOL hasUserAuth) {
        
        onSuccess(hasUserAuth);
        
    } failure:^(NSError *error) {
        onFailure(error.localizedDescription);
    }];
    
}


@end
