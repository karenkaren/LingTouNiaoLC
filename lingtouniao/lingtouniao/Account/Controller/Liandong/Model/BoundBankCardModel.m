//
//  BoundBankCardModel.m
//  lingtouniao
//
//  Created by 徐凯 on 15/12/24.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "BoundBankCardModel.h"

@implementation BoundBankCardModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{ @"list" : [BankListModel class] };
}


-(void)GET_BindBankCardWithCardId:(NSString *)cardId andBelongBank:(NSString *)belongBank success:(void(^)(BOOL success))onSuccess failure:(void(^)(NSString *error))onFailure
{
   [LTNServerHelper bindBankCardWithCardId:cardId andBelongBank:belongBank success:^(BindBankCardModel *model) {
       
       _bindBankCardModel = model;
       onSuccess(YES);
       
   } failure:^(NSError *error) {
       onFailure(error.localizedDescription);
   }];




}

@end
