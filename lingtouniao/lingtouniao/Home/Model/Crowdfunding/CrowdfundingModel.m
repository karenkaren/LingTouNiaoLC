//
//  CrowdfundingModel.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/9/21.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "CrowdfundingModel.h"

@implementation CrowdfundingModel

@end

@implementation CrowdfundingList

+ (NSDictionary *)mj_objectClassInArray
{
    return @{ @"productZcList" : [CrowdfundingModel class] };
}

@end
