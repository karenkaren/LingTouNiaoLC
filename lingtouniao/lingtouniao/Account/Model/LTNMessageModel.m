//
//  LTNMessageModel.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/3/14.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNMessageModel.h"

@implementation LTNMessageModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}


@end
@implementation LTNMessageList

+ (NSDictionary *)mj_objectClassInArray
{
    return @{ @"messages" : [LTNMessageModel class] };
}
@end