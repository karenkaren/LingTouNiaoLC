//
//  LTNMyCurrentDepositModel.h
//  lingtouniao
//
//  Created by LiuFeifei on 16/1/21.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTNMyCurrentDepositModel : NSObject

/*
 年化收益率
 annual_income_rate String 5.5%
 每日万元收益
 per_million_income String ￥1.51/天
 持有金额累计收益
 total_income Double 23.00
 昨日收益
 lastday_income Double 23.00
 申请中转出金额
 applying_extract_amount String 50.00元
 可用余额
 available_amount Double 150.00
 活期持有金额
 current_hold_amount Double 150.00
 活期标的当天总金额
 current_total_amount Double 200000.00
 活期标的当天剩余金额
 current_remain_amount Double 10000.00
 */

// 年化收益率
@property (nonatomic, copy) NSString * annual_income_rate;
// 每日万元收益
@property (nonatomic, copy) NSString * per_million_income;
// 活期持有金额
@property (nonatomic, assign) double current_hold_amount;
// 可用余额
@property (nonatomic, assign) double available_amount;
// 活期标的当天总金额
@property (nonatomic, assign) double current_total_amount;
// 活期标的当天剩余金额
@property (nonatomic, assign) double current_remain_amount;
// 持有金额累计收益
@property (nonatomic, assign) double total_income;
// 昨天收益
@property (nonatomic, assign) double lastday_income;
// 申请中转出金额
@property (nonatomic, assign) double applying_extract_amount;

@end
