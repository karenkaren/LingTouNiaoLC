//
//  LTNProductList.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/6/15.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNProductList.h"

@implementation LTNProductList

+ (NSDictionary *)mj_objectClassInArray
{
    return @{ @"productList" : [LTNProduct class]};
}

+ (NSArray *)sortArray:(NSArray *)array{
    /*
     加息标在前
     投资期限短的在前
     */
    // 1.区分加息标和非加息标
    NSMutableArray * JXBArray = [NSMutableArray array];
    NSMutableArray * NJXBArray = [NSMutableArray array];
    for (LTNProduct * product in array) {
        NSRange range = [product.annualIncomeText rangeOfString:@"+"];
        if (range.length > 0) {
            [JXBArray addObject:product];
        } else {
            [NJXBArray addObject:product];
        }
    }
    
    // 2.两类标的按投资期限排序
    // todo:如果是浮动期限，该如何排序
    NSComparator cmptr = ^(id obj1, id obj2){
        LTNProduct *product1=(LTNProduct *)obj1;
        LTNProduct *product2=(LTNProduct *)obj2;
        if (product1.convertDay > product2.convertDay) {
            return (NSComparisonResult)NSOrderedDescending;
        } else if (product1.convertDay < product2.convertDay){
            return (NSComparisonResult)NSOrderedAscending;
        } else {
            return (NSComparisonResult)NSOrderedSame;
        }
    };
    
    [JXBArray sortUsingComparator:cmptr];
    [NJXBArray sortUsingComparator:cmptr];
    [JXBArray addObjectsFromArray:NJXBArray];
    return [NSArray arrayWithArray:JXBArray];
}

@end
