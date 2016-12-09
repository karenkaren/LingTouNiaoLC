//
//  FondTrustModel.m
//  lingtouniao
//
//  Created by 徐凯 on 15/12/24.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "FondTrustModel.h"

@implementation FondTrustModel

-(void)GET_UserAuthWith:(NSString *)userName identityCode:(NSString *)identityCode success:(void(^)(BOOL hasUserAuth))onSuccess  failure:(void(^)(NSString *error))onFailure
{

   [LTNServerHelper userAuthWith:userName identityCode:identityCode success:^(BOOL hasUserAuth) {
       
       onSuccess(hasUserAuth);
       
   } failure:^(NSError *error) {
       onFailure(error.localizedDescription);
   }];

}

@end
