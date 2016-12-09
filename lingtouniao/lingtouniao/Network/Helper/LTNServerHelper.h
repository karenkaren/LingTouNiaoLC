//
//  LTNServerHelper.h
//  lingtouniao
//
//  Created by LiuFeifei on 15/11/24.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(id response);
typedef void(^FailureBlock)(NSError * error);

@interface LTNServerHelper : NSObject

#pragma mark - 登录、注册、注销、修改、忘记相关接口
/**
 *  获取图片验证码
 *
 *  @param machineNo 机器唯一码
 *  @param success   获取图片验证码成功block
 *  @param failure   获取图片验证码失败block
 */
+ (void)getPictureCodeWithMachineNo:(NSString *)machineNo success:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 *  获取短信验证码用于注册
 *
 *  @param mobileNo 手机号码
 *  @param success  获取短信验证码成功block
 *  @param failure  获取短信验证码失败block
 */
+ (void)getMobileCodeForRegisterWithMobileNo:(NSString *)mobileNo success:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 *  获取短信验证码用于找回密码
 *
 *  @param mobileNo      手机号码
 *  @param success       获取短信验证码成功block
 *  @param failure       获取短信验证码失败block
 */
+ (void)getMobileCodeForRetrieveWithMobileNo:(NSString *)mobileNo success:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 *  用户注册
 *
 *  @param mobileNo   手机号码
 *  @param password   设定的登录密码
 *  @param mobileCode 短信验证码
 *  @param referee    推荐人
 *  @param agree      是否同意用户协议
 *  @param success    用户注册成功block
 *  @param failure    用户注册失败block
 */
+ (void)registerWithMobileNo:(NSString *)mobileNo password:(NSString *)password mobileCode:(NSString *)mobileCode referee:(NSString *)referee agreeProtocol:(BOOL)agree success:(SuccessBlock)success failure:(FailureBlock)failure;
/**
 *  修改密码
 *
 *  @param mobileNo        手机号码
 *  @param primaryPassword 原始密码
 *  @param newPassword     新密码
 *  @param mobileCode      手机验证码
 *  @param success         修改密码成功block
 *  @param failure         修改密码失败block
 */
+ (void)modifyPasswordWithMobileNo:(NSString *)mobileNo primaryPassword:(NSString *)primaryPassword newPassword:(NSString *)newPassword mobileCode:(NSString *)mobileCode success:(SuccessBlock)success failure:(FailureBlock)failure;
/**
 *  找回密码
 *
 *  @param mobileNo    手机号码
 *  @param newPassword 新密码
 *  @param mobileCode  手机验证码
 *  @param idCard      身份证号码
 *  @param success     找回密码成功block
 *  @param failure     找回密码失败block
 */
+ (void)retrievePasswordWithMobileNo:(NSString *)mobileNo newPassword:(NSString *)newPassword mobileCode:(NSString *)mobileCode idCard:(NSString *)idCard success:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 *  验证短信验证码与身份证号
 *
 *  @param mobilCode     短信验证码
 *  @param certification 身份证号码
 *  @param success        短信验证码、身份证号验证成功block
 *  @param failure       短信验证码、身份证号验证失败block
 */
+ (void)verifyMobilCodeWithMobileNo:(NSString *)mobileNo mobilCode:(NSString *)mobilCode idCard:(NSString *)idCard success:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 *  用户注销
 *
 *  @param sessionKey 用户唯一识别码
 *  @param success    注销成功
 *  @param failure    注销失败
 */
+ (void)logoutSuccess:(SuccessBlock)success failure:(FailureBlock)failure;

#pragma mark - 业务
/**
 *  获取首页banner列表url地址、推荐产品
 *
 *  @param success    获取成功
 *  @param failure    获取失败
 */
+ (void)getBannersListAndRecommendProductsSuccess:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 *  获取产品列表
 *
 *  @param currentPage 当前页
 *  @param success     获取产品列表成功
 *  @param failure     获取产品列表失败
 */
+ (void)getProductsListWithCurrentPage:(int)currentPage success:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 *  确认购买
 *
 *  @param productNo      产品编号
 *  @param orderAmount    支付金额
 *  @param birdCoin       鸟币
 *  @param cashbackCoupon 返现券
 *  @param success        购买成功
 *  @param failure        购买失败
 */
+ (void)confirmToBuyProductWithProductId:(long)productId orderAmount:(double)orderAmount birdCoin:(double)birdCoin userCouponId:(long)userCouponId success:(void(^)(ProductBuyConfirmModel *model))onSuccess  failure:(FailureBlock)onFailure;

#pragma mark - 账户信息
/**
 *  获取账户信息
 *
 *  @param success 获取账户信息
 *  @param failure 获取账户信息
 */
+ (void)getAccountInfoSuccess:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 *  获取我的投资
 *
 *  @param orderStatus 投资状态
 *  @param pageNum     当前页
 *  @param success     获取投资信息成功
 *  @param failure     获取投资信息失败
 */

+ (void)getInvestInfoWithOrderStatus:(int)orderStatus pageNum:(int)pageNum success:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 *  获取我的理财金券信息
 *
 *  @param success 获取理财金券信息成功
 *  @param failure 获取理财金券信息失败
 */
+ (void)getCouponInfoSuccess:(void (^)( NSArray *result))success failure:(FailureBlock)failure;


/**
 *  我要理财—马上购买
 *
 *  @param productId    产品类型
 *  @param investAmount 购买金额  体验标不需要输入，直接传为0
 *  @param success      <#success description#>
 *  @param failure      <#failure description#>
 */
//+(void)getBuyWithProductId:(NSString *)productId andInvestAmount:(NSString *)investAmount Success:(void(^)(OrderPrepareModel *))success failure:(FailureBlock)failure;
+(void)getBuyWithUrlString:(NSString *)urlStr productId:(NSString *)productId andInvestAmount:(NSString *)investAmount Success:(void(^)( OrderPrepareModel*))success failure:(FailureBlock)failure;
+(void)cooperationBuyWithUrlString:(NSString *)urlStr productId:(NSString *)productId andInvestAmount:(NSString *)investAmount Success:(void(^)( OrderPrepareModel*))success failure:(FailureBlock)failure;
+(void)crowdfundingBuyWithUrlString:(NSString *)urlStr stepId:(NSInteger)stepId productId:(NSString *)productId andInvestAmount:(NSString *)investAmount Success:(void(^)( OrderPrepareModel*))success failure:(FailureBlock)failure;
/**
 *  用户实名制
 *
 *  @param userName     姓名
 *  @param identityCode 证件号码
 *  @param onSuccess    <#onSuccess description#>
 *  @param onFailure    <#onFailure description#>
 */
+(void)userAuthWith:(NSString *)userName identityCode:(NSString *)identityCode success:(void(^)(BOOL hasUserAuth))onSuccess  failure:(FailureBlock)onFailure;

/**
 *  银行卡消息
 *
 *  @param sessionKey
 
 */
+ (void)bankNotice:(SuccessBlock)success failure:(FailureBlock)failure;


/**
 *  tips消息
 *
 *  @param sessionKey
 
 */
+ (void)sysConfig:(SuccessBlock)success failure:(FailureBlock)failure;
/**
 *  绑卡--[需要去联动网页]
 *
 *  @param cardId    银行卡号
 *  @param onSuccess <#onSuccess description#>
 *  @param onFailure <#onFailure description#>
 */
+(void)bindBankCardWithCardId:(NSString *)cardId andBelongBank:(NSString *)belongBank success:(void(^)(BindBankCardModel *model))onSuccess  failure:(FailureBlock)onFailure;

/**
 *  充值-[需要去联动网页]
 *
 *  @param orderAmount 充值金额
 *  @param onSuccess   <#onSuccess description#>
 *  @param onFailure   <#onFailure description#>
 */
+(void)userRechargeWithOrderAmount:(NSString *)orderAmount success:(void(^)(BindBankCardModel *model))onSuccess  failure:(FailureBlock)onFailure;
/**
 *  提现-[需要去联动网页]
 *
 *  @param orderAmount 提现金额
 *  @param birdCoin    鸟币抵扣手续费
 *  @param buckle      手续费承担方
 *  @param onSuccess   <#onSuccess description#>
 *  @param onFailure   <#onFailure description#>
 */
+(void)userWithdrawalsWithOrderAmount:(NSString *)orderAmount birdCoin:(NSString *)birdCoin buckle:(NSString *)buckle success:(void(^)(BindBankCardModel *model))onSuccess  failure:(FailureBlock)onFailure;

+ (void)retrieveUserInfoWithFinishBlock:(VoidBlock)finishBlock;
+ (void)retrieveAccountInfoWithFinishBlock:(VoidBlock)finishBlock;
+ (void)retrieveAccountInfoContainFreeCountWithFinishBlock:(VoidBlock)finishBlock;
+ (void)retrieveBankListWithFinishBlock:(ESHandlerBlock)finishBlock;
+ (void)retrieveBannerListWithFinishBlock:(ESHandlerBlock)finishBlock;

@end
