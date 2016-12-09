//
//  UserInfoModel.h
//  lingtouniao
//
//  Created by 徐凯 on 15/12/23.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "BaseModel.h"

@interface UserInfoModel : BaseModel

// 用户id
@property (nonatomic, copy) NSString *userId;
// 用户姓名
@property (nonatomic, copy) NSString *userName;
// 手机号
@property (nonatomic, copy) NSString *mobile;
// 手机推送码
@property (nonatomic, copy) NSString *deviceToken;
// 实名认证标志
@property (nonatomic, copy) NSString *certification;//0：未实名1：已实名
// 身份证
@property (nonatomic, copy) NSString *cardId;
// 状态
@property (nonatomic, copy) NSString *state;
// 联动优势开户日期
@property (nonatomic, copy) NSString *regDate;
// 推荐码
@property (nonatomic, copy) NSString *referralCode;
// 银行卡认证状态
@property (nonatomic, copy) NSString *bankAuthStatus;//0：未实名1：已实名
// 投资状态
@property (nonatomic, copy) NSString *investStatus;
// 联动用户号
@property (nonatomic, copy) NSString *umpayUserNo;
// 联动账户号
@property (nonatomic, copy) NSString *umpayAccountNo;
// 客户类型
@property (nonatomic, copy) NSString *guestType;
// 客户等级
@property (nonatomic, copy) NSString *userLevelId;
// 是否已经体验
@property (nonatomic, assign) BOOL isExperience;//'0：未体验；1：已体验'
// 是否内部员工
@property (nonatomic, assign) BOOL isStaff;
// 是否首次下单
@property (nonatomic, assign) BOOL isFirstOrder;
// 银行卡号
@property (nonatomic, copy) NSString *bankNo;
// 银行卡名称
@property (nonatomic, copy) NSString *belongBank;
// 银行图标
@property (nonatomic, copy) NSString *logoUrl;
// 银行预留手机号码
@property (nonatomic, copy) NSString *preMoblieNo;
//是否开通免密充值
@property (nonatomic) BOOL agreementCZ;
//是否开通免密投资
@property (nonatomic) BOOL agreementTZ;


-(NSString *)sex;

@end
