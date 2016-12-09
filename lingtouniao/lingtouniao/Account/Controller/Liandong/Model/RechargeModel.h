//
//  RechargeModel.h
//  lingtouniao
//
//  Created by 徐凯 on 15/12/25.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "BaseModel.h"

@interface RechargeModel : BaseModel

@property(nonatomic,strong)BindBankCardModel *bindBankCardModel;

@property(nonatomic,copy)NSString *belongBank;//银行卡名称
@property(nonatomic,copy)NSString *bankNo;//银行卡卡号
@property(nonatomic)NSString *logoUrl;//银行图标

-(void)GET_UserRechargeWithOrderAmount:(NSString *)orderAmount success:(void(^)(BOOL success))onSuccess  failure:(void(^)(NSString *error))onFailure;


@end
