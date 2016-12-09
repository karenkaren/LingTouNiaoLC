//
//  MessageModel.h
//  lingtouniao
//
//  Created by 徐凯 on 15/12/19.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>

@interface MessageModel : BaseModel

@end


@interface FinanciaCouponModel : MessageModel

@property(nonatomic)NSString *amount;//面值
@property(nonatomic,copy)NSString *couponDate;//优惠券到期时间
@property(nonatomic,copy)NSString *couponId; //优惠券编号
@property(nonatomic,copy)NSString *couponName;//优惠券名称
@property(nonatomic, copy) NSString *couponType;//优惠券类型: 理财金券，判断是否投资，如果已经使用则是disable状      态，否则是enable状态。
@property(nonatomic, copy) NSString *couponTypeDes;//优惠券是加息券还是返现券
@property(nonatomic, assign) NSInteger duration;
@property(nonatomic,copy)NSString *getDate;//优惠券开始时间
@property(nonatomic,copy)NSString *userCouponId;
@property(nonatomic,copy)NSString *limitAmount;
@property(nonatomic,copy)NSString *status;
@property(nonatomic, copy)NSString *validDateCount;//优惠券状态
@property(nonatomic,copy)NSString *activityType;//优惠券活动描述
@property(nonatomic,copy)NSString *desc;//优惠券描述
@property(nonatomic) NSString *isGive;//2是不可赠送1是可以
//券码
@property (nonatomic,copy)NSString *presentCode;

@end


@interface CouponsModel : MessageModel

@property(nonatomic,copy)NSString *couponId; //优惠券编号
@property(nonatomic,copy)NSString *couponName;//优惠券名称
@property(nonatomic, assign) NSInteger couponAmount;//优惠券价格
@property(nonatomic,copy)NSString *couponDesc;//优惠券描述
@property(nonatomic, assign) NSInteger couponType;//优惠券类型: 理财金券，判断是否投资，如果已经使用则是disable状      态，否则是enable状态。
@property(nonatomic,copy)NSString *productDueDay;//优惠券到期时间
@property(nonatomic,assign)double *productProfit;//收益 （如果是鸟币，显示单位为鸟币？）



@end


@interface BankListModel : MessageModel

@property(nonatomic,copy) NSString *bankName;//银行名称
@property(nonatomic,copy) NSString *chargeDateLimit;//每日限额
@property(nonatomic,copy) NSString *chargeTimeLimit;//每次限额
@property(nonatomic,copy) NSString *bankId;//银行卡id
@property (nonatomic,copy) NSString *bankMessage;//银行说明


+(NSArray *)getBankNameList:(NSArray *)bankListModelList;

+(NSArray *)getBankLimit:(NSArray *)bankListModelList;


+(NSDictionary *)bankListNotice;
@end



@interface LimitMountModel : MessageModel

@property(nonatomic,copy)NSString *onceLimit;//每次限额
@property(nonatomic,copy)NSString *dailyLimit;//每日限额

@end

@interface OrderPrepareModel : MessageModel

@property(nonatomic,assign)double revenue; //预期收益
@property(nonatomic,copy)NSString *productExpireDate; //产品到期时间
@property(nonatomic,assign)double birdCoin; //我的鸟币
@property(nonatomic,strong)NSArray<FinanciaCouponModel *> *coupons; //理财金券列表
@property(nonatomic,copy)NSString *productType;//标的的区分类型
// 众筹奖励
@property (nonatomic, copy) NSString * stepAward;

@end

@interface BindBankCardModel : MessageModel
@property(nonatomic,copy)NSString *plain; //待签名数据
@property(nonatomic,copy)NSString *url;//连接地址
@property(nonatomic,copy)NSString *sign;//签名数据
@end



@interface ProductBuyConfirmModel : MessageModel

@property(nonatomic,copy)NSString *plain; //待签名数据
@property(nonatomic,copy)NSString *url;//连接地址
@property(nonatomic,copy)NSString *sign;//签名数据
@property(nonatomic,copy)NSString *orderNo;//订单编号

@end
