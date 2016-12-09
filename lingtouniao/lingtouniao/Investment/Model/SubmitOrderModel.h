//
//  SubmitOrderModel.h
//  lingtouniao
//
//  Created by 徐凯 on 15/12/19.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "BaseModel.h"

typedef NS_ENUM(NSUInteger, ProductType) {
    ProductTypeOfLC,
    ProductTypeOfHZ,
    ProductTypeOfZC
};

@interface SubmitOrderModel : BaseModel


@property(nonatomic,strong,readonly)OrderPrepareModel *orderPrepareModel;
@property(nonatomic,strong)ProductBuyConfirmModel *productBuyConfirmModel;
@property(nonatomic,strong,readonly)NSArray *coupounArray;
@property(nonatomic,copy,readonly) NSString *productId;



/**
 *  我要理财—马上购买
 *
 *  @param productId    productId
 *  @param investAmount 购买金额
 *  @param onSuccess    <#onSuccess description#>
 *  @param failure      <#failure description#>
 */
-(void)GET_getBuyWithProductId:(NSString *)productId andInvestAmount:(NSString *)investAmount  Success:(void(^)(BOOL isSuccess))onSuccess failure:(void (^)(NSString *error))failure;
//-(void)GET_getBuyWithProductType:(ProductType)productType productId:(NSString *)productId andInvestAmount:(NSString *)investAmount  Success:(void(^)(BOOL isSuccess))onSuccess failure:(void (^)(NSString *error))failure;
-(void)GET_cooperationBuyWithProductId:(NSString *)productId andInvestAmount:(NSString *)investAmount  Success:(void(^)(BOOL isSuccess))onSuccess failure:(void (^)(NSString *error))failure;
-(void)GET_crowdfingBuyWithProductId:(NSString *)productId andInvestAmount:(NSString *)investAmount stepId:(NSInteger)stepId  Success:(void(^)(BOOL isSuccess))onSuccess failure:(void (^)(NSString *error))failure;

/**
 *  提交订单确认
 *
 *  @param productId    产品编号
 *  @param orderAmount  支付金额
 *  @param birdCoin     鸟币
 *  @param userCouponId 用户返现券ID
 *  @param onSuccess    <#onSuccess description#>
 *  @param failure      <#failure description#>
 */
-(void)GET_ConfirmToBuyProductWithProductId:(long)productId andOrderAmount:(double)orderAmount birdCoin:(double)birdCoin userCouponId:(long)userCouponId Success:(void(^)(BOOL isSuccess))onSuccess failure:(void (^)(NSString *error))failure;

@end
