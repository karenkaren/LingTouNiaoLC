//
//  AccountInfoModel.h
//  lingtouniao
//
//  Created by 徐凯 on 15/12/23.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "BaseModel.h"

@interface AccountInfoModel : BaseModel

// 鸟币待收收益
@property (nonatomic, assign) CGFloat birdCoinRevenue;
// 鸟币
@property (nonatomic, assign) CGFloat birdCoin;
// 待收本金
@property (nonatomic, assign) CGFloat collectCapital;
// 待收收益
@property (nonatomic, assign) CGFloat collectRevenue;
// 冻结金额
@property (nonatomic, assign) CGFloat frozenAmount;
// 活期金额
@property (nonatomic, assign) CGFloat liveAmount;
// 累积收益
@property (nonatomic, assign) CGFloat sumRevenue;
// 未读消息数
@property (nonatomic, assign) NSInteger unreadMessageCount;

// 总资产
@property (nonatomic, assign) CGFloat totalAsset;
// 可用余额
@property (nonatomic, assign) CGFloat usableBalance;
// 用户编号
@property (nonatomic, assign) CGFloat userId;
//提现次数
@property (nonatomic,assign) NSInteger freeCounter;

//是否显示随心投
@property (nonatomic, assign) BOOL sxtIsShow;
//是否显示安心投
@property (nonatomic, assign) BOOL axtIsShow;

// 我的理财金券可用数量
@property (nonatomic, assign) int myCoupons;
// 我的当前投资个数
@property (nonatomic, assign) int myOrder;
// 我的全部任务个数
@property (nonatomic, assign) int myTask;
// 已完成的任务个数
@property (nonatomic, assign) int myTasking;

//- (void)modifyAccountWithDictionary:(NSDictionary *)dic;



@end
