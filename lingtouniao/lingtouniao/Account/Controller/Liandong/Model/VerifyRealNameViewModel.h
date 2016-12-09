//
//  VerifyRealNameViewModel.h
//  lingtouniao
//
//  Created by 徐凯 on 15/12/23.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "BaseModel.h"

@interface VerifyRealNameViewModel : BaseModel

@property(nonatomic,copy)NSString * certification;//是否已经实名
@property(nonatomic,copy)NSString *userName;//用户姓名
@property(nonatomic,copy)NSString *cardId;//身份证id

/**
 *  用户实名制
 *
 *  @param userName     姓名
 *  @param identityCode 证件号码
 *  @param onSuccess    <#onSuccess description#>
 *  @param onFailure    <#onFailure description#>
 */
-(void)GET_UserAuthWith:(NSString *)userName identityCode:(NSString *)identityCode success:(void(^)(BOOL hasUserAuth))onSuccess  failure:(void(^)(NSString *error))onFailure;

@end
