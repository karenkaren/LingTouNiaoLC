//
//  LTNBaseStatisticsModel.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/3/17.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNBaseStatisticsModel.h"

@implementation LTNBaseStatisticsModel

- (instancetype)initWithData:(id)data withColors:(NSArray *)colors
{
    self = [super init];
    if (self) {
        [self parseWithData:(id)data withColors:colors];
    }
    return self;
}

- (void)parseWithData:(id)data withColors:(NSArray *)colors
{
    NSMutableArray * arrayM = [NSMutableArray array];
    
    // 总资产解析
    //    "collectCapital":101000,
    //    "collectRevenue":61.17,
    //    "frozenAmount":0,
    //    "totalAsset":131061.17,
    //    "usableBalance":30000,
    //    "userId":1000001
    if (data[@"totalAsset"]) {
        
        double total = [data[@"totalAsset"] doubleValue];
        self.total = [NSString stringWithFormat:@"%.2f", total];
        
        NSString * usableBalance = [NSString stringWithFormat:@"%.2f", [data[@"usableBalance"] doubleValue]];
        NSString * usableBalancePercent = total ? [NSString stringWithFormat:@"%.2f%%", [data[@"usableBalance"] doubleValue] * 100 / total] : @"0.00%";
        NSDictionary * dic1 = @{@"indicateColor" : colors[0], @"percent" : usableBalancePercent, @"title" : locationString(@"usable_balance"), @"amount" : usableBalance, @"hiddenHelp" : @(YES)};
        
        NSString * collectCapital = [NSString stringWithFormat:@"%.2f", [data[@"collectCapital"] doubleValue]];
        NSString * collectCapitalPercent = total ? [NSString stringWithFormat:@"%.2f%%", [data[@"collectCapital"] doubleValue] * 100 / total] : @"0.00%";
        NSDictionary * dic2 = @{@"indicateColor" : colors[1], @"percent" : collectCapitalPercent, @"title" : locationString(@"toreceive_principal"), @"amount" : collectCapital, @"hiddenHelp" : @(YES)};
        
        NSString * collectRevenue = [NSString stringWithFormat:@"%.2f", [data[@"collectRevenue"] doubleValue]];
        NSString * collectRevenuePercent = total ? [NSString stringWithFormat:@"%.2f%%", [data[@"collectRevenue"] doubleValue] * 100 / total] : @"0.00%";
        NSDictionary * dic3 = @{@"indicateColor" : colors[2], @"percent" : collectRevenuePercent, @"title" : locationString(@"toreceive_balance"), @"amount" : collectRevenue, @"hiddenHelp" : @(YES)};
        
        NSString * frozenAmount = [NSString stringWithFormat:@"%.2f", [data[@"frozenAmount"] doubleValue]];
        NSString * frozenAmountPercent = total ? [NSString stringWithFormat:@"%.2f%%", [data[@"frozenAmount"] doubleValue] * 100 / total] : @"0.00%";
        
        
        //todo：
        NSString * other = [NSString stringWithFormat:@"%.2f", [data[@"otherAmount"] doubleValue]];
        NSString * otherPercent = total ? [NSString stringWithFormat:@"%.2f%%", [data[@"otherAmount"] doubleValue] * 100 / total] : @"0.00%";
        NSDictionary * dic6 = @{@"indicateColor" : [UIColor colorWithHexString:@"#800080"], @"percent" : otherPercent, @"title" : @"其他", @"amount" : other, @"hiddenHelp" : @(YES)};
        
        
        if ([LTNCore shouldShowCurrentInvestment]) {
            NSString * currentHoldAmountPercent = total ? [NSString stringWithFormat:@"%.2f%%", [data[@"currentHoldAmount"] doubleValue] * 100 / total] : @"0.00%";
            NSString * currentHoldAmount = [NSString stringWithFormat:@"%.2f", [data[@"currentHoldAmount"] doubleValue]];
            NSDictionary * dic4 = @{@"indicateColor" : colors[3], @"percent" : currentHoldAmountPercent, @"title" : locationString(@"current_hold_amount"), @"amount" : currentHoldAmount, @"hiddenHelp" : @(YES)};
            NSDictionary * dic5 = @{@"indicateColor" : colors[4], @"percent" : frozenAmountPercent, @"title" : locationString(@"blocked_balance"), @"amount" : frozenAmount, @"hiddenHelp" : @(YES)};
            
            [arrayM addObjectsFromArray:@[dic1, dic2, dic3, dic4, dic5, dic6]];
        } else {
            
            NSDictionary * dic4 = @{@"indicateColor" : colors[3], @"percent" : frozenAmountPercent, @"title" : locationString(@"blocked_balance"), @"amount" : frozenAmount, @"hiddenHelp" : @(YES)};
            [arrayM addObjectsFromArray:@[dic1, dic2, dic3, dic4, dic6]];
        }
        
    }
    
    // 已收收益解析
    /*
    "birdTotal": 0, 鸟币收益
    "couponTotal": 0,返现券收益
    "currentTotal": 0,活期收益
    "financeTotal": 0,理财收益
    "partnerTotal": 0,合伙人收益
    "uncRevenueTotal": 0总额收益
     */
    if (data[@"uncRevenueTotal"]) {
        double total = [data[@"uncRevenueTotal"] doubleValue];
        self.total = [NSString stringWithFormat:@"%.2f", total];
        
        // 固定收益类
        NSString * financeTotal = [NSString stringWithFormat:@"%.2f", [data[@"financeTotal"] doubleValue]];
        NSString * financeTotalPercent = total ? [NSString stringWithFormat:@"%.2f%%", [financeTotal doubleValue] * 100 / total] : @"0.00%";
        NSDictionary * dic1 = @{@"indicateColor" : colors[0], @"percent" : financeTotalPercent, @"title" : locationString(@"income_type_1"), @"amount" : financeTotal, @"hiddenHelp" : @(YES)};
        
        // 随心投收益
        NSString * currentTotal = [NSString stringWithFormat:@"%.2f", [data[@"currentTotal"] doubleValue]];
        NSString * currentTotalPercent = total ? [NSString stringWithFormat:@"%.2f%%", [currentTotal doubleValue] * 100 / total] : @"0.00%";
        NSDictionary * dic2 = @{@"indicateColor" : colors[1], @"percent" : currentTotalPercent, @"title" : locationString(@"income_type_2"), @"amount" : currentTotal, @"hiddenHelp" : @(YES)};
        
        // 鸟币收益
        NSString * birdTotal = [NSString stringWithFormat:@"%.2f", [data[@"birdTotal"] doubleValue]];
        NSString * birdTotalPercent = total ? [NSString stringWithFormat:@"%.2f%%", [birdTotal doubleValue] * 100 / total] : @"0.00%";
        NSDictionary * dic3 = @{@"indicateColor" : colors[2], @"percent" : birdTotalPercent, @"title" : locationString(@"income_type_3"), @"amount" : birdTotal, @"hiddenHelp" : @(YES)};
        
        // 理财金券收益
        NSString * couponTotal = [NSString stringWithFormat:@"%.2f", [data[@"couponTotal"] doubleValue]];
        NSString * couponTotalPercent = total ? [NSString stringWithFormat:@"%.2f%%", [couponTotal doubleValue] * 100 / total] : @"0.00%";
        NSDictionary * dic4 = @{@"indicateColor" : colors[3], @"percent" : couponTotalPercent, @"title" : locationString(@"income_type_4"), @"amount" : couponTotal, @"hiddenHelp" : @(YES)};
        
        // 合伙人收益
        NSString * partnerTotal = [NSString stringWithFormat:@"%.2f", [data[@"partnerTotal"] doubleValue]];
        NSString * partnerTotalPercent = total ? [NSString stringWithFormat:@"%.2f%%", [partnerTotal doubleValue] * 100 / total] : @"0.00%";
        NSDictionary * dic5 = @{@"indicateColor" : colors[4], @"percent" : partnerTotalPercent, @"title" : locationString(@"income_type_5"), @"amount" : partnerTotal, @"hiddenHelp" : @(YES)};

        [arrayM addObjectsFromArray:@[dic1, dic2, dic3, dic4, dic5]];
    }
    
    self.datas = arrayM;
}

@end
