//
//  HomeModel.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/6/15.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "HomeModel.h"
#import "LTNProduct.h"
#import "CooperationModel.h"
#import "CrowdfundingModel.h"

@implementation HomeModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{ @"productList" : [LTNProduct class],
              @"productHzList" : [CooperationModel class],
              @"productZcList" : [CrowdfundingModel class]};
}

@end
