//
//  SubmitOrderModel.m
//  lingtouniao
//
//  Created by 徐凯 on 15/12/19.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "SubmitOrderModel.h"

@implementation SubmitOrderModel

-(id)init
{
    self = [super init];
    if (self) {
         _coupounArray = [[NSArray alloc]init];
    }
    return self;
   
}

- (void)GET_getBuyWithProductId:(NSString *)productId andInvestAmount:(NSString *)investAmount Success:(void (^)(BOOL))onSuccess failure:(void (^)(NSString *))failure
{
    [LTNServerHelper getBuyWithUrlString:kUserOrderOrderPrepareUrl productId:productId andInvestAmount:investAmount Success: ^(OrderPrepareModel *orderPrepare) {
        _orderPrepareModel = orderPrepare;
        _coupounArray = _orderPrepareModel.coupons;
        onSuccess(YES);
        
    } failure:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

-(void)GET_cooperationBuyWithProductId:(NSString *)productId andInvestAmount:(NSString *)investAmount  Success:(void(^)(BOOL isSuccess))onSuccess failure:(void (^)(NSString *error))failure
{
    [LTNServerHelper cooperationBuyWithUrlString:kUserOrderhzOrderhzprepareUrl productId:productId andInvestAmount:investAmount Success: ^(OrderPrepareModel *orderPrepare) {
        _orderPrepareModel = orderPrepare;
        _coupounArray = _orderPrepareModel.coupons;
        onSuccess(YES);
        
    } failure:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

-(void)GET_crowdfingBuyWithProductId:(NSString *)productId andInvestAmount:(NSString *)investAmount stepId:(NSInteger)stepId  Success:(void(^)(BOOL isSuccess))onSuccess failure:(void (^)(NSString *error))failure
{
    [LTNServerHelper crowdfundingBuyWithUrlString:kOrderZcOrderZcPrepareUrl stepId:stepId productId:productId andInvestAmount:investAmount Success: ^(OrderPrepareModel *orderPrepare) {
        _orderPrepareModel = orderPrepare;
        _coupounArray = _orderPrepareModel.coupons;
        onSuccess(YES);
    } failure:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

//-(void)GET_getBuyWithProductId:(NSString *)productId andInvestAmount:(NSString *)investAmount  Success:(void(^)(BOOL isSuccess))onSuccess failure:(void (^)(NSString *error))failure
//{
//    [LTNServerHelper getBuyWithProductId:productId andInvestAmount:investAmount Success: ^(OrderPrepareModel *orderPrepare) {
//        
//        _orderPrepareModel = orderPrepare;
//        _coupounArray = _orderPrepareModel.coupons;
//        onSuccess(YES);
//        
//    } failure:^(NSError *error) {
//          failure(error.localizedDescription);
//    }];
//
//
//}

  

-(void)GET_ConfirmToBuyProductWithProductId:(long)productId andOrderAmount:(double)orderAmount birdCoin:(double)birdCoin userCouponId:(long)userCouponId Success:(void(^)(BOOL isSuccess))onSuccess failure:(void (^)(NSString *error))failure
{

     [LTNServerHelper  confirmToBuyProductWithProductId:productId orderAmount:orderAmount birdCoin:birdCoin userCouponId:userCouponId success:^(ProductBuyConfirmModel *model) {
         
         _productBuyConfirmModel = model;
         onSuccess(YES);
         
     } failure:^(NSError *error) {
         failure(error.localizedDescription);
     }];
}

@end
