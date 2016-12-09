//
//  LTNBaseDetailCellModel.m
//  lingtouniao
//
//  Created by LiuFeifei on 15/12/28.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNBaseDetailCellModel.h"
#import "NSStringUtil.h"

@implementation LTNBaseDetailCellModel

- (instancetype)initWithData:(id)data
{
    self = [super init];
    if (self) {
        [self parseWithData:(id)data];
    }
    return self;
}

- (void)parseWithData:(id)data
{
    NSMutableArray * arrayM = [NSMutableArray array];
    // 余额明细解析
    if (data[@"usableBalance"]) {
        self.total = [NSString stringWithFormat:@"%.2f", [data[@"usableBalance"] doubleValue]];
        NSArray * balanceDetails = data[@"balanceDetails"];
        for (NSDictionary * balanceDetailDic in balanceDetails) {
            NSDictionary * dic = @{@"title" : safeEmpty(balanceDetailDic[@"operateType"]), @"time" : safeEmpty([balanceDetailDic[@"operateDate"] componentsSeparatedByString:@" "].firstObject), @"money" : safeEmpty(balanceDetailDic[@"amountText"]),@"total":safeEmpty(balanceDetailDic[@"total"])};
            [arrayM addObject:dic];
        }
    }
    
    // 总资产解析
//    "collectCapital":101000,
//    "collectRevenue":61.17,
//    "frozenAmount":0,
//    "totalAsset":131061.17,
//    "usableBalance":30000,
//    "userId":1000001
    if (data[@"totalAsset"]) {
        self.total = [NSString stringWithFormat:@"%.2f", [data[@"totalAsset"] doubleValue]];
        NSDictionary * dic1 = @{@"title" : locationString(@"usable_balance"), @"time" : @"" , @"money" : [NSString stringWithFormat:@"%.2f", [data[@"usableBalance"] doubleValue]]};
        NSDictionary * dic2 = @{@"title" : locationString(@"blocked_balance"), @"time" : @"" , @"money" : [NSString stringWithFormat:@"%.2f", [data[@"frozenAmount"] doubleValue] ]};
        NSDictionary * dic3 = @{@"title" : locationString(@"toreceive_principal"), @"time" : @"" , @"money" : [NSString stringWithFormat:@"%.2f", [data[@"collectCapital"] doubleValue]]};
        NSDictionary * dic4 = @{@"title" : locationString(@"toreceive_balance"), @"time" : @"" , @"money" : [NSString stringWithFormat:@"%.2f", [data[@"collectRevenue"] doubleValue]]};
        NSArray * array = [NSArray array];
        if ([LTNCore shouldShowCurrentInvestment]) {
            NSDictionary * dic5 = @{@"title" : locationString(@"current_total_amount"), @"time" : @"" , @"money" : [NSString stringWithFormat:@"%.2f", [data[@"currentHoldAmount"] doubleValue]]};
            array = @[dic1, dic2, dic3, dic4, dic5];
        } else {
            array = @[dic1, dic2, dic3, dic4];
        }
        
        [arrayM addObjectsFromArray:array];
    }
    
    // 我的鸟币解析
//    {"amount":13.33,"createDate":"2015-12-19","typeName":"体验标"},
//    "totalAmount":13.33,
//    "updateDate":"2015-12-18"
    if (data[@"totalAmount"]) {
        self.total = [NSString stringWithFormat:@"%.2f", [data[@"totalAmount"] doubleValue]];
        NSArray * birdCoins = data[@"birdCoins"];
        for (NSDictionary * birdCoinDic in birdCoins) {
            NSDictionary * dic = @{@"title" : safeEmpty(birdCoinDic[@"typeName"]), @"time" : safeEmpty([birdCoinDic[@"createDate"] componentsSeparatedByString:@" "].firstObject), @"money" : [NSString stringWithFormat:@"%.2f", [birdCoinDic[@"amount"] doubleValue]],@"total":safeEmpty(birdCoinDic[@"total"])};
            [arrayM addObject:dic];
        }
    }

//uncRevenueTotal:总收益
//    uncRevenueList：{
//        earningName;//收益名称
//        earningDate;//收益时间
//        earning;//收益钱
//        
//    }
    // 已收收益解析
    // 待收收益解析
    if (data[@"uncRevenueTotal"]) {
        self.total = [NSString stringWithFormat:@"%.2f", [data[@"uncRevenueTotal"] doubleValue]];
        NSArray * uncRevenueList = data[@"uncRevenueList"];
        for (NSDictionary * uncRevenueDic in uncRevenueList) {
            NSDictionary * dic = @{@"title" : safeEmpty(uncRevenueDic[@"earningName"]), @"time" : safeEmpty([uncRevenueDic[@"earningDate"] componentsSeparatedByString:@" "].firstObject), @"money" : [NSString stringWithFormat:@"+%.2f", [uncRevenueDic[@"earning"] doubleValue]]};
            [arrayM addObject:dic];
        }
    }
    
//    data:{currentIncomeList：[{income:123,time:2015-10-10},{income:123,time:2015-10-10}],currentTotalIncome : 150},totalCount:11
    // 活期收入明细解析
    if (data[@"currentTotalIncome"]) {
        self.total = [NSString stringWithFormat:@"%.2f", [data[@"currentTotalIncome"] doubleValue]];
        NSArray * currentIncomeList = data[@"currentIncomeList"];
        for (NSDictionary * currentIncomeDic in currentIncomeList) {
            NSDictionary * dic = @{@"title" : safeEmpty(currentIncomeDic[@"time"]), @"time" : @"", @"money" : [NSString stringWithFormat:@"+%.2f", [currentIncomeDic[@"income"] doubleValue]]};
            [arrayM addObject:dic];
        }
    }
    
    self.datas = arrayM;
}

@end
