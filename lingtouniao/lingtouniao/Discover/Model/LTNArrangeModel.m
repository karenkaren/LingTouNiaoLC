//
//  LTNArrangeModel.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/9/21.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNArrangeModel.h"

@implementation LTNArrangeModel

@end

@implementation LTNArrangeList

+ (NSDictionary *)mj_objectClassInArray
{
    return @{ @"taskList" : [LTNArrangeModel class] };
}

@end
