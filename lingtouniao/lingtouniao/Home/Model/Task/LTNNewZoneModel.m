//
//  LTNNewZoneModel.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/4/26.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNNewZoneModel.h"

@implementation LTNNewZoneList

+ (NSDictionary *)mj_objectClassInArray
{
    return @{ @"taskList" : [LTNNewZoneModel class] };
}

@end

@implementation LTNNewZoneModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}

@end
