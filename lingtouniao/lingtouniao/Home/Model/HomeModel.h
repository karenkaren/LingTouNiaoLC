//
//  HomeModel.h
//  lingtouniao
//
//  Created by LiuFeifei on 16/6/15.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "BaseModel.h"

@interface HomeModel : BaseModel

// banner数组
//@property (nonatomic, strong) NSArray * bannersList;
// 互助列表
@property (nonatomic, strong) NSArray * productHzList;
// 众筹列表
@property (nonatomic, strong) NSArray * productZcList;
// 推荐标数组
@property (nonatomic, strong) NSArray * productList;
// 砸金蛋url 目前已无用
@property (nonatomic, copy) NSString * dtUrl;
// 活动是否开启
@property (nonatomic, assign) BOOL isAllowShown;
// 是否已显示过活动
@property (nonatomic, assign) BOOL isHasShown;
// 是否登陆 0-未登陆 1-登陆
@property (nonatomic, assign) BOOL isLogin;
// 是否显示新手模块 0-不显示1-显示
@property (nonatomic, assign) BOOL isShowXsModel;
// 平台累计投资金额
@property (nonatomic, copy) NSString * platformAllAmount;
// 平台累计注册人数
@property (nonatomic, copy) NSString * platformRegisterNum;
// 个人累计收益
@property (nonatomic, copy) NSString * sumRevenue;
// 运营报告连接地址
@property (nonatomic, copy) NSString * yyUrl;
// 未读消息数
@property (nonatomic, assign) NSInteger unreadMessageCount;

@end
