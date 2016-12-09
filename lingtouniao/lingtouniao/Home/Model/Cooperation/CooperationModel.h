//
//  CooperationModel.h
//  lingtouniao
//
//  Created by LiuFeifei on 16/9/21.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "BaseModel.h"

@interface CooperationModel : BaseModel

/*
createTime		number	@mock=1474544466000
hzDetailUrl		string	互助详情页@mock=hzDetailUrlB?productId=1
isFirstPage		number	是否首页显示@mock=0
productContent		string	产品详情@mock=bbbbbaasada
productDesc		string	产品描述@mock=asaaa
productFirstTitle		string	引导页主标题@mock=aaa
productId		number	@mock=1
productMaxpayAmount		number	最高赔偿金额@mock=0
productName		string	产品名称@mock=aaa
productNo		string	产品编号@mock=123
productPic		string	引导页图片@mock=aaa
productSoldedAmount		number	@mock=0
productStatus		string	产品状态i，跟标的状态一样@mock=1
productSubTitle		string	引导页副标题@mock=ssd
productTotalAmount		number	产品总金额@mock=0
productType		string	产品类型@mock=a
productWiki		string	wiki@mock=vvv
remark		string	@mock=aaaa
singleLimitAmount		string	单笔限制金额@mock=1000
sortNo		number	排序@mock=2
useBridCoinTag		number	是否使用鸟币@mock=0
useCouponTag		number	是否能使用返现券@mock=0
useEquipment		number	平台类型 1-PC 2-APP@mock=0
waitDays		number	等待日期@mock=0
 */


@property (nonatomic, assign) double createTime;    // 创建时间
@property (nonatomic, copy) NSString * hzDetailUrl;	// 互助详情页
@property (nonatomic, assign) BOOL isFirstPage; //是否首页显示@mock=0
@property (nonatomic, copy) NSString * productContent;  //产品详情
@property (nonatomic, copy) NSString * productDesc;     //产品描述@mock=asaaa
@property (nonatomic, copy) NSString * productFirstTitle;   //引导页主标题
@property (nonatomic, assign) NSInteger productId;  //产品id
@property (nonatomic, assign) double productMaxpayAmount;    //最高赔偿金额
@property (nonatomic, copy) NSString * productName; //产品名称
@property (nonatomic, copy) NSString * productNo;	//产品编号
@property (nonatomic, copy) NSString * productPic;	//详情页图片
@property (nonatomic, copy) NSString * productTopPic;   // 简介图片
@property (nonatomic, assign) double productSoldedAmount; // 已投金额
@property (nonatomic, copy) NSString * productStatus;   //产品状态i，跟标的状态一样
@property (nonatomic, copy) NSString * productSubTitle; //引导页副标题
@property (nonatomic, assign) double productTotalAmount; //产品总金额
@property (nonatomic, copy) NSString * productType; //产品类型
@property (nonatomic, copy) NSString * productWiki; //wiki
@property (nonatomic, copy) NSString * remark;
@property (nonatomic, copy) NSString * singleLimitAmount;   //单笔限制金额，即起投金额
@property (nonatomic, assign) NSInteger sortNo; //排序
@property (nonatomic, assign) BOOL useBridCoinTag;  //是否使用鸟币
@property (nonatomic, assign) BOOL useCouponTag;   //是否能使用返现券
@property (nonatomic, assign) NSInteger useEquipment;   //平台类型 1-PC 2-APP
@property (nonatomic, assign) double waitDays;   //等待日期

@end

@interface CooperationList : BaseModel

@property (nonatomic) NSArray * helpList;

@end
