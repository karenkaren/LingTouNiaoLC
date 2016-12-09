//
//  CrowdfundingModel.h
//  lingtouniao
//
//  Created by LiuFeifei on 16/9/21.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "BaseModel.h"

@interface CrowdfundingModel : BaseModel

/*
 annualIncome		number	年华收益@mock=$order(0.01,0.11)
 annualIncomeText		string	年化显示@mock=$order('2%','11%')
 beginTime		number	开始日期@mock=$order(1474693328000,1474646399000)
 convertDay		number	折算天@mock=$order(20,11)
 createTime		number	创建时间@mock=$order(1474549868000,1474615171000)
 createUserId		string	@mock=$order('1666','100000')
 endRateDate		number	@mock=$order(1474693328000,1475942399000)
 endTime		number	@mock=$order(1474693328000,1475942399000)
 isFirstPage		number	是否显示在首页@mock=$order(1,1)
 overBidDate		number	@mock=$order(1474693328000,)
 productContent		string	@mock=$order('内容xxxxx','内容xxxxx')
 productDesc		string	产品描述@mock=$order('描述xxxx','描述xxxx')
 productFirstTitle		string	引导页主标题@mock=$order('主标题','主标题')
 productId		number	@mock=$order(100000,100014)
 productName		string	@mock=$order('测试众筹产品00001','测试')
 productNo		string	@mock=$order('ZC00001','ZC_1474615171335')
 productRuleText		string	产品规则@mock=$order('xxxx','xxxx')
 productSoldedAmount		number	已投金额@mock=$order(1000000,10000)
 productStatus		string	@mock=$order('1','1')
 productSubTitle		string	产品副标题@mock=$order('副标题xxx','副标题xxx')
 productTopPic		string	首页配图@mock=$order('http://123132.jpg','http://123132.jpg')
 productTotalAmount		number	@mock=$order(1000000,10000)
 productType		string	@mock=$order('A','B')
 productWiki		string	@mock=$order('Wiki','Wiki')
 raiseEndDate		number	@mock=$order(1474693328000,1474646399000)
 remark		string	@mock=$order('remarkxxxxx','remarkxxxxx')
 sortNo		number	@mock=$order(1234,1234)
 staInvestAmount		number	@mock=$order(1000,1000)
 staRateDate		number	@mock=$order(1474693328000,1474646399000)
 updateTime		number	@mock=$order(1474693328000,1474697229000)
 updateUserId		string	@mock=$order('123','100000')
 useBridcoinTag		number	@mock=$order(1,1)
 useCouponTag		number	@mock=$order(1,1)
 useEquipment		number	@mock=$order(2,2)
 zcDetailUrl		string	@mock=$order('zCDetailUrlA?productId=100000','zCDetailUrlB?productId=100014')
 */

@property (nonatomic, assign) double annualIncome;   //年华收益，如：0.01,0.11
@property (nonatomic, copy) NSString * annualIncomeText;    //年化显示,如'2%','11%'
@property (nonatomic, assign) NSUInteger beginTime; //开始日期
@property (nonatomic, assign) NSInteger convertDay;   //折算天
@property (nonatomic, assign) NSUInteger createTime;    //创建时间
@property (nonatomic, copy) NSString * createUserId;
@property (nonatomic, assign) NSUInteger endRateDate;
@property (nonatomic, assign) NSUInteger endTime;
@property (nonatomic, assign) BOOL isFirstPage; //是否显示在首页
@property (nonatomic, assign) NSUInteger overBidDate;
@property (nonatomic, copy) NSString * productContent;  //产品详情
@property (nonatomic, copy) NSString * productDesc; //产品描述
@property (nonatomic, copy) NSString * productFirstTitle;   //引导页主标题
@property (nonatomic, assign) NSInteger productId;  //产品id
@property (nonatomic, copy) NSString * productName; //产品名称
@property (nonatomic, copy) NSString * productNo; //产品编号
@property (nonatomic, copy) NSString * productRuleText; //产品规则
@property (nonatomic, assign) double productSoldedAmount;   //已投金额
@property (nonatomic, copy) NSString * productStatus;   //产品状态i，跟标的状态一样
@property (nonatomic, copy) NSString * productSubTitle; //产品副标题
@property (nonatomic, copy) NSString * productTopPic;   //首页配图,eg:'http://123132.jpg','http://123132.jpg'
@property (nonatomic, copy) NSString * productPic;  // 众筹列表图片
@property (nonatomic, assign) double productTotalAmount;    //产品总金额
@property (nonatomic, copy) NSString * productType; //产品类型
@property (nonatomic, copy) NSString * productWiki; //wiki
@property (nonatomic, assign) NSUInteger raiseEndDate;  // 募集结束日期
@property (nonatomic, copy) NSString * remark;
@property (nonatomic, assign) NSInteger sortNo; //排序
@property (nonatomic, assign) double staInvestAmount;   // 起投金额
@property (nonatomic, assign) NSInteger staRateDate;
@property (nonatomic, assign) NSInteger updateTime;
@property (nonatomic, assign) NSInteger updateUserId;
@property (nonatomic, assign) BOOL useBridcoinTag;  //是否使用鸟币
@property (nonatomic, assign) BOOL useCouponTag;    //是否能使用返现券
@property (nonatomic, assign) NSInteger useEquipment;   //平台类型 1-PC 2-APP
@property (nonatomic, copy) NSString * zcDetailUrl;    // 众筹详情url

@end

@interface CrowdfundingList : BaseModel

@property (nonatomic) NSArray * productZcList;

@end
