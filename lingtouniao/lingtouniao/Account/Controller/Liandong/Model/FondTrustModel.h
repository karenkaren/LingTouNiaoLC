//
//  FondTrustModel.h
//  lingtouniao
//
//  Created by 徐凯 on 15/12/24.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "BaseModel.h"

@interface FondTrustModel : BaseModel

///**
// *  用户实名制
// *
// *  @param userName     姓名
// *  @param identityCode 证件号码
// *  @param onSuccess    <#onSuccess description#>
// *  @param onFailure    <#onFailure description#>
// */
-(void)GET_UserAuthWith:(NSString *)userName identityCode:(NSString *)identityCode success:(void(^)(BOOL hasUserAuth))onSuccess  failure:(void(^)(NSString *error))onFailure;




@end
