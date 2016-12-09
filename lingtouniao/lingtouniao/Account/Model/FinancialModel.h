//
//  FinancialModel.h
//  lingtouniao
//
//  Created by 徐凯 on 15/12/19.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "BaseModel.h"

@interface FinancialModel : BaseModel

@property(nonatomic,strong)NSArray *coupons;

@property(nonatomic,strong,readonly)NSArray *financiaCouponArray;//理财金券列表

@property(assign,nonatomic )BOOL hasMoreRecord;//是否拥有更多的理财金券记录


/**
 *  获取理财金券
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
-(void)GET_MyFinancialCouponSuccess:(void (^)(BOOL isSuccess))onSuccess failure:(void (^)(NSString *errorString))onFailure;;




@end
