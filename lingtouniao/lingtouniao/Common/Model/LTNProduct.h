//
//  LTNProduct.h
//  111
//
//  Created by LiuFeifei on 15/12/8.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LTNProduct : BaseModel

// 最后购买人
@property (nonatomic, copy) NSString * lastBuyer;
@property (nonatomic, copy) NSString * arrangeDate;
// 是否可以预约
@property (nonatomic, copy) NSString * isArrange;
@property (nonatomic, assign) NSInteger isFisrtPage;
// 投资最小递增倍数
@property (nonatomic, assign) double multipleTequire;
// 产品ID
@property (nonatomic, assign) NSInteger productId;
// 购买订单数
@property (nonatomic, assign) NSInteger buyCount;
// 购买人数
@property (nonatomic, assign) NSInteger buyPersonCount;
// 产品编号
@property (nonatomic, copy) NSString * productNo;
// 产品名称
@property (nonatomic, copy) NSString * productName;
// 产品类型
@property (nonatomic, copy) NSString * productType;
// 年化收益
@property (nonatomic, assign) double annualIncome;
// 年化收益字符串
@property (nonatomic, copy) NSString * annualIncomeText;
// 产品标签
@property (nonatomic, copy) NSString * productTag;
// 产品简介
@property (nonatomic, copy) NSString * productTitle;
// 产品期限
@property (nonatomic, assign) NSInteger productDeadline;
// 起投金额
@property (nonatomic, assign) double staInvestAmount;

// 产品总金额
@property (nonatomic, assign) double productTotalAmount;
// 产品剩余金额
@property (nonatomic, assign) double productRemainAmount;
// 标的最大天数
@property (nonatomic, assign) NSInteger convertDay;
// 产品期限单位
@property (nonatomic, copy) NSString * deadlineUnit;
// 还款方式
@property (nonatomic, copy) NSString * repaymentType;
// 起息日期 yyyy-MM-dd HH:mm:ss
@property (nonatomic, copy) NSString * staRateDate;
// 起息计算方式
@property (nonatomic, copy) NSString * rateCalculateType;
// 项目状态
@property (nonatomic, assign) NSInteger productStatus;
// 募集结束时间 yyyy-MM-dd HH:mm:ss
@property (nonatomic, copy) NSString * raiseEndDate;
// 标的发布时间 yyyy-MM-dd HH:mm:ss
@property (nonatomic, copy) NSString * bidPublishDate;
// 满标时间 yyyy-MM-dd HH:mm:ss
@property (nonatomic, copy) NSString * overBidDate;
// 流标时间 yyyy-MM-dd HH:mm:ss
@property (nonatomic, copy) NSString * offBidDate;
// 排序号
@property (nonatomic, assign) NSInteger orderNo;
// 创建时间 yyyy-MM-dd HH:mm:ss
@property (nonatomic, copy) NSString * createDate;
// 创建人
@property (nonatomic, copy) NSString * createBy;
//// 新老用户投资限制
//@property (nonatomic, copy) NSString * oldNewLimit;
// 提取手续费用
@property (nonatomic, assign) double extractCharge;
//// 提取手续费计算方式
//@property (nonatomic, copy) NSString * extractCaculateType;
// 提取限额
@property (nonatomic, assign) double extractChargeLimit;
// 项目详情url地址
@property (nonatomic, copy) NSString * detailsUrl;

//// 标的最大天数
//@property (nonatomic) NSInteger convertDay;

//是否浮动标的
@property (nonatomic)BOOL floatTag;

// 剩余可投资金额
@property (nonatomic) double lastAmount;//number

// 单笔限额
@property (nonatomic) double singleLimitAmount;//number


// 浮动标的最小天数
@property (nonatomic) NSInteger standardConvertDay;

// 单人累计限额
@property (nonatomic) double totalLimitAmount;//number


//鸟币支持
@property (nonatomic)BOOL useBirdCoinTag;

//优惠券支持
@property (nonatomic)BOOL useCouponTag;






#pragma mark fuction

-(double)startAmount;

-(double)getOnceMaxAccount;


-(BOOL)hasSingleLimitAmount;
-(BOOL)hasTotalLimitAmount;

- (NSString *)deadlineString;


@end
