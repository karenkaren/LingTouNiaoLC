//
//  ChargeModel.m
//  lingtouniao
//
//  Created by 徐凯 on 15/12/25.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "ChargeModel.h"

@implementation ChargeModel


-(CGFloat)usableBalance
{
    return [CurrentUser mine].accountInfo.usableBalance;
}

-(NSInteger)freeCounter
{
    return [CurrentUser mine].accountInfo.freeCounter;
}

-(NSString *)belongBank
{
    return [CurrentUser mine].userInfo.belongBank;
}

-(NSString *)bankNo
{
    return [CurrentUser mine].userInfo.bankNo;
}

-(CGFloat)birdCoin
{
    return [CurrentUser mine].accountInfo.birdCoin;
}

-(NSString *)logoUrl{
   // return [NSString stringWithFormat:@"icon_%@",[CurrentUser mine].userInfo.belongBank];
   return [CurrentUser mine].userInfo.logoUrl;
}

-(void)GET_UserWithdrawalsWithOrderAmount:(NSString *)orderAmount birdCoin:(NSString *)birdCoin buckle:(NSString *)buckle success:(void(^)(BOOL success))onSuccess  failure:(void(^)(NSString *error))onFailure
{
    [LTNServerHelper userWithdrawalsWithOrderAmount:orderAmount birdCoin:birdCoin buckle:buckle success:^(BindBankCardModel *model) {
        
        _bindBankCardModel = model;
        onSuccess(YES);

    } failure:^(NSError *error) {
        
         onFailure(error.localizedDescription);
    }];



}

@end
