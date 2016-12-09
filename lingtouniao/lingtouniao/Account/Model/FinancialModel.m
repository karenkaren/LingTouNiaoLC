//
//  FinancialModel.m
//  lingtouniao
//
//  Created by 徐凯 on 15/12/19.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "FinancialModel.h"

@implementation FinancialModel


+ (NSDictionary *)mj_objectClassInArray
{
    return @{ @"coupons" : [FinanciaCouponModel class] };
}


-(id)init
{
    if (self = [super init])
    {
        _financiaCouponArray = [[NSArray alloc]init];
    }
    return self;
}

-(void)GET_MyFinancialCouponSuccess:(void (^)(BOOL isSuccess))onSuccess failure:(void (^)(NSString *errorString))onFailure
{
    [LTNServerHelper  getCouponInfoSuccess:^(NSArray * response) {
        
        _financiaCouponArray = response;
        onSuccess(YES);
        
    } failure:^(NSError *error) {
        onFailure(error.localizedDescription);
    }];


}

@end
