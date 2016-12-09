//
//  ChargeModel.h
//  lingtouniao
//
//  Created by 徐凯 on 15/12/25.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "BaseModel.h"

@interface ChargeModel : BaseModel

@property(nonatomic,assign)CGFloat usableBalance;//可用余额
@property(nonatomic,assign)NSInteger freeCounter;//提现次数
@property(nonatomic,copy)NSString *belongBank;//银行卡名称
@property(nonatomic,copy)NSString *bankNo;//银行卡号
@property(nonatomic,assign)CGFloat birdCoin;//鸟币
@property(nonatomic)NSString *logoUrl;//银行图标




@property(nonatomic,strong)BindBankCardModel *bindBankCardModel;

/**
 *  提现-[需要去联动网页]
 *
 *  @param orderAmount 提现金额
 *  @param birdCoin    鸟币抵扣手续费
 *  @param buckle      手续费承担方
 *  @param onSuccess   <#onSuccess description#>
 *  @param onFailure   <#onFailure description#>
 */
-(void)GET_UserWithdrawalsWithOrderAmount:(NSString *)orderAmount birdCoin:(NSString *)birdCoin buckle:(NSString *)buckle success:(void(^)(BOOL success))onSuccess  failure:(void(^)(NSString *error))onFailure;

@end
