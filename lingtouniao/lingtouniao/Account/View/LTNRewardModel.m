//
//  LTNRewardModel.m
//  lingtouniao
//
//  Created by 郑程锋 on 15/12/28.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNRewardModel.h"

@implementation LTNRewardModel

@end


@implementation LTNRewardModelList

+ (NSDictionary *)mj_objectClassInArray
{
    return @{ @"listPartnerEarnings" : [LTNRewardModel class] };
}

@end
