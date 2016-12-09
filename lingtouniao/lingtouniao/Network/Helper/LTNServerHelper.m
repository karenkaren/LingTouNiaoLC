//
//  LTNServerHelper.m
//  lingtouniao
//
//  Created by LiuFeifei on 15/11/24.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNServerHelper.h"
#import "LTNServerConstant.h"
#import "LTNNetHelper.h"
#import <UIKit/UIKit.h>
#import "LTNUtilsHelper.h"
#import "DtoContainer.h"
#import "LTNBanner.h"



static int const RESULTCODE_SUCCESS = 0;//成功


@implementation LTNServerHelper
#pragma mark - 账号相关
/**
 *  获取图片验证码
 *
 *  @param machineNo 机器唯一标识码
 *  @param success   获取图片验证码成功block
 *  @param failure   获取图片验证码失败block
 */
+ (void)getPictureCodeWithMachineNo:(NSString *)machineNo success:(SuccessBlock)success failure:(FailureBlock)failure
{
    // url字符串
    NSString * urlString = [kBaseUrl stringByAppendingPathComponent:kGetPictureCaptchaUrl];
    // 参数字典
    NSDictionary * dictionary = @{@"clientType" : [self getClientType],
                                  @"machineNo" : machineNo};
    // 获取图片验证码
    [LTNNetHelper postWithPath:urlString params:dictionary success:^(id response) {
        NSDictionary * resultsDic = (NSDictionary *)response;
        DLog(@"%s, %@", __func__, resultsDic);
        if ([resultsDic[@"resultCode"] isEqualToString:@"0"]) {
            NSString * path = [kBaseUrl stringByAppendingPathComponent:resultsDic[@"data"][@"pictureCode"]];
            DLog(@"%s, %@", __func__, path);
            
            // 发送一个异步请求(在主线程发送请求)
            // ios9方法
//            [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:path] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//                DLog(@"%s, data:%@", __func__, data);
//                if (success) {
//                    success(data);
//                }
//            }];
            // 创建一个请求
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                DLog(@"%s, data:%@", __func__, data);
                if (success) {
                    success(data);
                }
            }];
        }
    } failure:^(NSError * error) {
        DLog(@"%s, %@", __func__, error.localizedDescription);
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  获取短信验证码用于找回密码
 *
 *  @param mobileNo      手机号码
 *  @param success       获取短信验证码成功block
 *  @param failure       获取短信验证码失败block
 */
+ (void)getMobileCodeForRetrieveWithMobileNo:(NSString *)mobileNo success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:@{@"mobileNo" : mobileNo, @"sendType" : @2}];
    [BaseDataEngine apiForPath:kGetMobileCaptchaUrl method:kGetMethod parameter:dic responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        if (error) {
            if (failure) {
                failure(error);
            }
        } else {
            if (success) {
                success(response);
            }
        }
    }];
}

/**
 *  获取短信验证码用于注册
 *
 *  @param mobileNo 手机号码
 *  @param success  获取短信验证码成功block
 *  @param failure  获取短信验证码失败block
 */
+ (void)getMobileCodeForRegisterWithMobileNo:(NSString *)mobileNo success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:@{@"mobileNo" : mobileNo, @"sendType" : @1}];
    [BaseDataEngine apiForPath:kGetMobileCaptchaUrl method:kGetMethod parameter:dic responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        if (error) {
            if (failure) {
                failure(error);
            }
        } else {
            if (success) {
                success(response);
            }
        }
    }];
}


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
+ (void)registerWithMobileNo:(NSString *)mobileNo password:(NSString *)password mobileCode:(NSString *)mobileCode referee:(NSString *)referee agreeProtocol:(BOOL)agree success:(SuccessBlock)success failure:(FailureBlock)failure
{
    // url字符串
    NSString * urlString = [kBaseUrl stringByAppendingPathComponent:kUserRegisterUrl];
    // 参数字典
    NSDictionary * dictionary = @{@"clientType" : [self getClientType],
                                  @"mobileNo" : mobileNo,
                                  @"password" : password,
                                  @"mobileCode" : mobileCode,
                                  @"partnerMobile" : referee,
                                  @"readAndAgree" : @(agree)};
    // 用户注册
    [LTNNetHelper postWithPath:urlString params:dictionary success:^(id response) {
        if ([response[@"resultCode"] integerValue] == 0) {
            NSDictionary * dic = [NSDictionary dictionary];
            if (response[@"resultMessage"]) {
                dic = @{@"sessionKey" : response[@"data"][@"sessionKey"], @"resultMessage" : response[@"resultMessage"]};
            } else {
                dic = response[@"data"];
            }
            if (success) {
                success(dic);
            }
            return;
        }
        [self returnErrorInfoWithDomain:urlString response:response failureBolck:failure];
    } failure:^(NSError * error) {
        if (failure) {
            failure(error);
        }
    }];
}

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
+ (void)modifyPasswordWithMobileNo:(NSString *)mobileNo primaryPassword:(NSString *)primaryPassword newPassword:(NSString *)newPassword mobileCode:(NSString *)mobileCode success:(SuccessBlock)success failure:(FailureBlock)failure
{
    // url字符串
    NSString * urlString = [kBaseUrl stringByAppendingPathComponent:kModifyPasswordUrl];
    // 参数字典
    NSDictionary * dictionary = @{@"clientType" : [self getClientType],
                                  @"mobileNo" : mobileNo,
                                  @"primaryCode" : primaryPassword,
                                  @"newCode" : newPassword,
                                  @"mobileCode" : mobileCode};
    // 修改密码
    [LTNNetHelper postWithPath:urlString params:dictionary success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError * error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  找回密码
 *
 *  @param mobileNo    手机号码
 *  @param newPassword 新密码
 *  @param mobileCode  手机验证码
 *  @param idCard      身份验证码（身份证号后四位）
 *  @param success     找回密码成功block
 *  @param failure     找回密码失败block
 */
+ (void)retrievePasswordWithMobileNo:(NSString *)mobileNo newPassword:(NSString *)newPassword mobileCode:(NSString *)mobileCode idCard:(NSString *)idCard success:(SuccessBlock)success failure:(FailureBlock)failure
{
    // url字符串
    NSString * urlString = [kBaseUrl stringByAppendingPathComponent:kRetrievePasswordUrl];
    if (idCard == nil) {
        idCard = @"";
    }
    // 参数字典
    NSDictionary * dictionary = @{@"clientType" : [self getClientType],
                                  @"mobileNo" : mobileNo,
                                  @"newPwd" : newPassword,
                                  @"mobileCode" : mobileCode,
                                  @"idCard" : idCard};
    // 找回密码
    [LTNNetHelper postWithPath:urlString params:dictionary success:^(id response) {
        if ([response[@"resultCode"] integerValue] == 0) {
            if (success) {
                success(response);
            }
            return;
        }
        [self returnErrorInfoWithDomain:urlString response:response failureBolck:failure];
    } failure:^(NSError * error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  验证短信验证码与身份证号
 *
 *  @param mobilCode     短信验证码
 *  @param certification 身份证号码
 *  @param success        短信验证码、身份证号验证成功block
 *  @param failure       短信验证码、身份证号验证失败block
 */
+ (void)verifyMobilCodeWithMobileNo:(NSString *)mobileNo mobilCode:(NSString *)mobilCode idCard:(NSString *)idCard success:(SuccessBlock)success failure:(FailureBlock)failure
{
    // url字符串
    NSString * urlString = [kBaseUrl stringByAppendingPathComponent:kVerifyMobileCodeUrl];
    // 参数字典
    if (idCard == nil) {
        idCard = @"";
    }
    NSDictionary * dictionary = @{@"clientType" : [self getClientType],
                                  @"sendType" : @2,
                                  @"mobileNo" : mobileNo,
                                  @"mobileCode" : mobilCode,
                                  @"idCard" : idCard};
    // 找回密码
    [LTNNetHelper postWithPath:urlString params:dictionary success:^(id response) {
        if ([response[@"resultCode"] integerValue] == 0) {
            if (success) {
                success(response);
            }
            return;
        }
        [self returnErrorInfoWithDomain:urlString response:response failureBolck:failure];
    } failure:^(NSError * error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  用户注销
 *
 *  @param sessionKey 用户唯一识别码
 *  @param success    注销成功
 *  @param failure    注销失败
 */
+ (void)logoutSuccess:(SuccessBlock)success failure:(FailureBlock)failure
{
    [BaseDataEngine apiForPath:kUserLogoutUrl method:kPostMethod parameter:nil responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        if (error) {
            if (failure) {
                failure(error);
            }
        } else {
            if (success) {
                success(response);
            }
        }
    }];
    
//    NSString * sessionKey = [[NSUserDefaults standardUserDefaults] objectForKey:kUserSessionKey];
//    if (!sessionKey) return;
//    
//    // url字符串
//    NSString * urlString = [kBaseUrl stringByAppendingPathComponent:kUserLogoutUrl];
//    // 参数字典
//    NSDictionary * dictionary = @{@"clientType" : [self getClientType],
//                                  @"sessionKey" : sessionKey};
//    // 找回密码
//    [LTNNetHelper postWithPath:urlString params:dictionary success:^(id response) {
//        if ([response[@"resultCode"] integerValue] == 0) {
//            if (success) {
//                success(response);
//            }
//            return;
//        }
//        [self returnErrorInfoWithDomain:urlString response:response failureBolck:failure];
//    } failure:^(NSError * error) {
//        if (failure) {
//            failure(error);
//        }
//    }];
}

#pragma mark - 业务相关
/**
 *  获取首页banner列表url地址、推荐产品
 *
 *  @param success    获取成功
 *  @param failure    获取失败
 */
+ (void)getBannersListAndRecommendProductsSuccess:(SuccessBlock)success failure:(FailureBlock)failure
{
    // url字符串
    NSString * urlString = [kBaseUrl stringByAppendingPathComponent:kHomeRecommendUrl];
    // 参数字典
    NSDictionary * dictionary = @{@"clientType" : [self getClientType]};
    // 找回密码
    [LTNNetHelper postWithPath:urlString params:dictionary success:^(id response) {
        if ([response[@"resultCode"] integerValue] == 0) {
            NSArray * bannersArray = response[@"data"][@"bannersList"];
            NSArray * productsList = response[@"data"][@"productList"];
            NSDictionary * dic = @{@"bannersList" : bannersArray,
                                   @"productList" : productsList};
            if (success) {
                success(dic);
            }
            return;
        }
        [self returnErrorInfoWithDomain:urlString response:response failureBolck:failure];
    } failure:^(NSError * error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  获取产品列表
 *
 *  @param currentPage 当前页
 *  @param success     获取产品列表成功
 *  @param failure     获取产品列表失败
 */
+ (void)getProductsListWithCurrentPage:(int)currentPage success:(SuccessBlock)success failure:(FailureBlock)failure
{
   
}

/**
 *  确认购买
 *
 *  @param sessionKey     用户sessionKey
 *  @param productNo      产品编号
 *  @param orderAmount    支付金额
 *  @param birdCoin       鸟币
 *  @param cashbackCoupon 返现券
 *  @param success        购买成功
 *  @param failure        购买失败
 */
+ (void)confirmToBuyProductWithProductId:(long)productId orderAmount:(double)orderAmount birdCoin:(double)birdCoin userCouponId:(long)userCouponId success:(void(^)(ProductBuyConfirmModel *model))onSuccess  failure:(FailureBlock)onFailure
{
    // url字符串
    NSString * urlString = [kBaseUrl stringByAppendingPathComponent:kBuyProductConfirmUrl];
     // 参数字典
    NSDictionary * parameters = @{@"clientType" : [self getClientType],
                                  @"sessionKey" : [CurrentUser mine].sessionKey,
                                  @"productId" :[NSNumber numberWithLong:productId],
                                  @"orderAmount" : [NSNumber numberWithDouble:orderAmount],
                                  @"birdCoin" : [NSNumber numberWithDouble:birdCoin],
                                  @"userCouponId" :[NSNumber numberWithLong:userCouponId]
                                  };
    
    [LTNNetHelper postWithPath:urlString params:parameters success:^(id response) {
        TempdtoContainer *dto = [TempdtoContainer mj_objectWithKeyValues:response];
        if (dto) {
     
            if (dto.resultCode == RESULTCODE_SUCCESS) {
                ProductBuyConfirmModel *model = [ProductBuyConfirmModel mj_objectWithKeyValues:dto.data];
              
                    onSuccess(model);
                
                return ;
            }
            
        }
        
        [self returnErrorInfoWithDomain:urlString response:response failureBolck:onFailure];
        
    } failure:^(NSError *error) {
        onFailure(error);
    }];
}

#pragma mark - 账户相关
/**
 *  获取账户信息
 *
 *  @param success 获取账户信息
 *  @param failure 获取账户信息
 */
+ (void)getAccountInfoSuccess:(SuccessBlock)success failure:(FailureBlock)failure
{
    // url字符串
    NSString * urlString = [kBaseUrl stringByAppendingPathComponent:kUserAccountUrl];
    // 参数字典
    NSDictionary * dictionary = @{@"clientType" : [self getClientType],
                                  @"sessionKey" : [CurrentUser mine].sessionKey};
    // 获取账户信息
    [LTNNetHelper postWithPath:urlString params:dictionary success:^(id response) {
        if ([response[@"resultCode"] intValue] == 0) {
            if (success) {
                success(response[@"data"]);
            }
            return;
        }
        [self returnErrorInfoWithDomain:urlString response:response failureBolck:failure];
    } failure:^(NSError * error) {
        if (failure) {
            failure(error);
        }
    }];
}


/**
 *  获取我的投资
 *
 *  @param orderStatus 投资状态
 *  @param pageNum     当前页
 *  @param success     获取投资信息成功
 *  @param failure     获取投资信息失败
 */
+ (void)getInvestInfoWithOrderStatus:(int)orderStatus pageNum:(int)pageNum success:(SuccessBlock)success failure:(FailureBlock)failure
{
    // url字符串
    NSString * urlString = [kBaseUrl stringByAppendingPathComponent:kUserInvestUrl];
    // 参数字典
    NSDictionary * dictionary = @{@"clientType" : [self getClientType],
                                  @"sessionKey" : [CurrentUser mine].sessionKey,
                                  @"pageNum" : @(pageNum),
                                  @"orderStatus" : @(orderStatus)};
    // 找回密码
    [LTNNetHelper postWithPath:urlString params:dictionary success:^(id response) {
        if ([response[@"resultCode"] intValue] == 0) {
            NSArray * array = response[@"data"][@"orders"];
            if (success) {
                success(array);
            }
            return;
        }
        [self returnErrorInfoWithDomain:urlString response:response failureBolck:failure];
    } failure:^(NSError * error) {
        if (failure) {
            failure(error);
        }
    }];
}

/**
 *  获取我的理财金券信息
 *
 *  @param success 获取理财金券信息成功
 *  @param failure 获取理财金券信息失败
 */
+ (void)getCouponInfoSuccess:(void (^)( NSArray *result))success failure:(FailureBlock)failure
{
    // url字符串
    NSString * urlString = [kBaseUrl stringByAppendingPathComponent:kUserCouponUrl];
    // 参数字典
    NSDictionary * dictionary = @{@"clientType" : [self getClientType],
                                  @"sessionKey" : [CurrentUser mine].sessionKey};
 
    [LTNNetHelper postWithPath:urlString params:dictionary success:^(id response) {
        
       TempdtoContainer *dto = [TempdtoContainer mj_objectWithKeyValues:response];
       if (dto) {
            if (dto.resultCode == RESULTCODE_SUCCESS) {
            if(dto.data)
                {
                  NSArray *array = [FinanciaCouponModel  mj_objectArrayWithKeyValuesArray:[dto.data valueForKey:@"coupons"]];
                    if(array)
                    {
                        success(array);
                    }
                return ;
                }
           }
       }
       
    [self returnErrorInfoWithDomain:urlString response:response failureBolck:failure];
       
        } failure:^(NSError *error) {
            
            if (failure) {
                failure(error);
            }
            
        }];
}


/**
 *  我要理财—马上购买
 *
 *  @param productId    产品类型
 *  @param investAmount 购买金额  体验标不需要输入，直接传为0
 *  @param success      <#success description#>
 *  @param failure      <#failure description#>
 */
//+(void)getBuyWithProductId:(NSString *)productId andInvestAmount:(NSString *)investAmount Success:(void(^)( OrderPrepareModel*))success failure:(FailureBlock)failure
//{
//    // url字符串
//    NSString * urlString = [kBaseUrl stringByAppendingPathComponent:kUserOrderOrderPrepareUrl];
//    
//    // 参数字典
//    NSDictionary * dictionary = @{@"clientType" : [self getClientType],
//                                  @"sessionKey" : [CurrentUser mine].sessionKey,
//                                  @"productId" : productId,
//                                  @"orderAmount":investAmount
//                                  };
//
//    [LTNNetHelper postWithPath:urlString params:dictionary success:^(id response) {
//        
//        TempdtoContainer *dto = [TempdtoContainer mj_objectWithKeyValues:response];
//        if (dto) {
//               OrderPrepareModel *orderPrepareModel = [[OrderPrepareModel alloc]init];
//            if (dto.resultCode == RESULTCODE_SUCCESS) {
//             
//                [orderPrepareModel setValuesForKeysWithDictionary:dto.data];
//                 NSMutableArray *arr = [NSMutableArray arrayWithCapacity:orderPrepareModel.coupons.count];
//                for (NSDictionary *dic_c in orderPrepareModel.coupons) {
//                    FinanciaCouponModel *model = [[FinanciaCouponModel alloc]init];
//                    [model setValuesForKeysWithDictionary:dic_c];
//                    [arr addObject:model];
//                }
//                orderPrepareModel.coupons=arr;
//                
//          if (orderPrepareModel) {
//                    success(orderPrepareModel);
//                }
//                return ;
//            }
//        }
//        
//        [self returnErrorInfoWithDomain:urlString response:response failureBolck:failure];
//        
//    } failure:^(NSError *error) {
//        
//        if (failure) {
//            failure(error);
//        }
//
//    }];
//
//
//}

/**
 *  普通下单准备
 */
+(void)getBuyWithUrlString:(NSString *)urlStr productId:(NSString *)productId andInvestAmount:(NSString *)investAmount Success:(void(^)( OrderPrepareModel*))success failure:(FailureBlock)failure
{
    // 参数字典
    NSDictionary * dictionary = @{@"clientType" : [self getClientType],
                                  @"sessionKey" : [CurrentUser mine].sessionKey,
                                  @"productId" : productId,
                                  @"orderAmount":investAmount
                                  };
    [LTNServerHelper prepareBuyWithUrlString:urlStr params:dictionary success:success failure:failure];
}

+(void)cooperationBuyWithUrlString:(NSString *)urlStr productId:(NSString *)productId andInvestAmount:(NSString *)investAmount Success:(void(^)( OrderPrepareModel*))success failure:(FailureBlock)failure
{
    // 参数字典
    NSDictionary * dictionary = @{@"clientType" : [self getClientType],
                                  @"sessionKey" : [CurrentUser mine].sessionKey,
                                  @"productId" : productId,
                                  @"orderAmount":investAmount
                                  };
    [LTNServerHelper prepareBuyWithUrlString:urlStr params:dictionary success:success failure:failure];
}

+(void)crowdfundingBuyWithUrlString:(NSString *)urlStr stepId:(NSInteger)stepId productId:(NSString *)productId andInvestAmount:(NSString *)investAmount Success:(void(^)( OrderPrepareModel*))success failure:(FailureBlock)failure
{
    // 参数字典
    NSDictionary * dictionary = @{@"clientType" : [self getClientType],
                                  @"sessionKey" : [CurrentUser mine].sessionKey,
                                  @"productId" : productId,
                                  @"orderAmount":investAmount,
                                  @"stepId" : @(stepId)
                                  };
    [LTNServerHelper prepareBuyWithUrlString:urlStr params:dictionary success:success failure:failure];
}

// 购买准备
+(void)prepareBuyWithUrlString:(NSString *)urlStr params:(NSDictionary *)params success:(void(^)(OrderPrepareModel*))success failure:(FailureBlock)failure
{
    // url字符串
    NSString * urlString = [kBaseUrl stringByAppendingPathComponent:urlStr];
    [LTNNetHelper postWithPath:urlString params:params success:^(id response) {
        
        TempdtoContainer *dto = [TempdtoContainer mj_objectWithKeyValues:response];
        if (dto) {
            OrderPrepareModel *orderPrepareModel = [[OrderPrepareModel alloc]init];
            if (dto.resultCode == RESULTCODE_SUCCESS) {
                
                [orderPrepareModel setValuesForKeysWithDictionary:dto.data];
                NSMutableArray *arr = [NSMutableArray arrayWithCapacity:orderPrepareModel.coupons.count];
                for (NSDictionary *dic_c in orderPrepareModel.coupons) {
                    FinanciaCouponModel *model = [[FinanciaCouponModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic_c];
                    [arr addObject:model];
                }
                orderPrepareModel.coupons=arr;
                
                if (orderPrepareModel) {
                    success(orderPrepareModel);
                }
                return ;
            }
        }
        [self returnErrorInfoWithDomain:urlString response:response failureBolck:failure];
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
        
    }];
}

/**
 *  用户实名制
 *
 *  @param userName     姓名
 *  @param identityCode 证件号码
 *  @param onSuccess    <#onSuccess description#>
 *  @param onFailure    <#onFailure description#>
 */
+(void)userAuthWith:(NSString *)userName identityCode:(NSString *)identityCode success:(void(^)(BOOL hasUserAuth))onSuccess  failure:(FailureBlock)onFailure
{
    // url字符串
    NSString * urlString = [kBaseUrl stringByAppendingPathComponent:kUserAuthUrl];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:[self getClientType] forKey:@"clientType"];
    [parameters setValue:[CurrentUser mine].sessionKey forKey:@"sessionKey"];
    [parameters setValue:userName forKey:@"userName"];
    [parameters setValue:identityCode forKey:@"identityCode"];
       
      [LTNNetHelper postWithPath:urlString params:parameters success:^(id response) {
          
          SingleBoolDto *dto = [SingleBoolDto mj_objectWithKeyValues:response];
          if (dto) {
              if (dto.resultCode == RESULTCODE_SUCCESS) {
                  if (dto.resultMessage) {
                      onSuccess(dto.resultMessage);
                      
                  }
                    return ;
              }
            
          }
          [self returnErrorInfoWithDomain:urlString response:response failureBolck:onFailure];
          
          
      } failure:^(NSError *error) {
          
          //实名失败
          NSArray *piwikArr=@[
                              @[@"user_id",esString([CurrentUser mine].userInfo.mobile)],
                              @[@"result",@"0"],
                              @[@"reason",esString(error.description)]
                              ];
          
          piwikEvent(@"auth_name",piwikArr);
          
          

          if (onFailure) {
              onFailure(error);
          }

      }];

}



/**
 *  银行卡消息
 *
 *  @param sessionKey
 
 */
+ (void)bankNotice:(SuccessBlock)success failure:(FailureBlock)failure
{
    [BaseDataEngine apiForPath:kBankListNotice method:kPostMethod parameter:nil responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        if (error) {
            if (failure) {
                failure(error);
            }
        } else {
            if (success) {
                success(response);
            }
        }
    }];
    
    
}

/**
 *  tips消息
 *
 *  @param sessionKey
 
 */
+ (void)sysConfig:(SuccessBlock)success failure:(FailureBlock)failure{
    [BaseDataEngine apiForPath:kSysConfig method:kPostMethod parameter:nil responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        if (error) {
            if (failure) {
                failure(error);
            }
        } else {
            if (success) {
                success(response);
            }
        }
    }];

}





/**
 *  绑卡--[需要去联动网页]
 *
 *  @param cardId    银行卡号
 *  @param onSuccess <#onSuccess description#>
 *  @param onFailure <#onFailure description#>
 */
+(void)bindBankCardWithCardId:(NSString *)cardId andBelongBank:(NSString *)belongBank success:(void(^)(BindBankCardModel *model))onSuccess  failure:(FailureBlock)onFailure
{
    // url字符串
    NSString * urlString = [kBaseUrl stringByAppendingPathComponent:kUserBindBankCardUrl];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:[self getClientType] forKey:@"clientType"];
    [parameters setValue:[CurrentUser mine].sessionKey forKey:@"sessionKey"];
    [parameters setValue:cardId forKey:@"cardId"];
    [parameters setValue:belongBank forKey:@"belongBank"];

    [LTNNetHelper postWithPath:urlString params:parameters success:^(id response) {
    TempdtoContainer *dto = [TempdtoContainer mj_objectWithKeyValues:response];
        if (dto) {
            if (dto.resultCode == RESULTCODE_SUCCESS) {
                BindBankCardModel *model = [BindBankCardModel mj_objectWithKeyValues:dto.data];
                if (model) {
                    onSuccess(model);
                }
                return ;
            }
            
        }
       
                         
       [self returnErrorInfoWithDomain:urlString response:response failureBolck:onFailure];
                         
    } failure:^(NSError *error) {
        onFailure(error);
        
        //邦卡失败
        NSArray *piwikArr=@[
                            @[@"user_id",esString([CurrentUser mine].userInfo.mobile)],
                            @[@"result",@"0"],
                            
                            @[@"reason",esString(error.description)]
                            
                            ];
        piwikEvent(@"bind_card",piwikArr);
    }];

    
}

/**
 *  充值-[需要去联动网页]
 *
 *  @param orderAmount 充值金额
 *  @param onSuccess   <#onSuccess description#>
 *  @param onFailure   <#onFailure description#>
 */
+(void)userRechargeWithOrderAmount:(NSString *)orderAmount success:(void(^)(BindBankCardModel *model))onSuccess failure:(FailureBlock)onFailure
{
    // url字符串
    NSString * urlString = [kBaseUrl stringByAppendingPathComponent:kUserRechargeUrl];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:[self getClientType] forKey:@"clientType"];
    [parameters setValue:[CurrentUser mine].sessionKey forKey:@"sessionKey"];
    [parameters setValue:orderAmount forKey:@"orderAmount"];
    
    [LTNNetHelper postWithPath:urlString params:parameters success:^(id response) {
        TempdtoContainer *dto = [TempdtoContainer mj_objectWithKeyValues:response];
        if (dto) {
            if (dto.resultCode == RESULTCODE_SUCCESS) {
                BindBankCardModel *model = [BindBankCardModel mj_objectWithKeyValues:dto.data];
                if (model) {
                    onSuccess(model);
                }
                  return ;
            }
        }

        [self returnErrorInfoWithDomain:urlString response:response failureBolck:onFailure];
        
    } failure:^(NSError *error) {
        onFailure(error);
    }];
}

/**
 *  提现-[需要去联动网页]
 *
 *  @param orderAmount 提现金额
 *  @param birdCoin    鸟币抵扣手续费
 *  @param buckle      手续费承担方
 *  @param onSuccess   <#onSuccess description#>
 *  @param onFailure   <#onFailure description#>
 */
+(void)userWithdrawalsWithOrderAmount:(NSString *)orderAmount birdCoin:(NSString *)birdCoin buckle:(NSString *)buckle success:(void(^)(BindBankCardModel *model))onSuccess failure:(FailureBlock)onFailure
{
    // url字符串
    NSString * urlString = [kBaseUrl stringByAppendingPathComponent:kUserWithdrawalseUrl];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setValue:[self getClientType] forKey:@"clientType"];
        [parameters setValue:[CurrentUser mine].sessionKey forKey:@"sessionKey"];
        [parameters setValue:orderAmount forKey:@"orderAmount"];
        [parameters setValue:birdCoin forKey:@"birdCoin"];
    
    [LTNNetHelper postWithPath:urlString params:parameters success:^(id response) {
        TempdtoContainer *dto = [TempdtoContainer mj_objectWithKeyValues:response];
        if (dto) {
            if (dto.resultCode == RESULTCODE_SUCCESS) {
                BindBankCardModel *model = [BindBankCardModel mj_objectWithKeyValues:dto.data];
                if (model) {
                    onSuccess(model);
                }
                return ;
            }
            
        }
        
        [self returnErrorInfoWithDomain:urlString response:response failureBolck:onFailure];
        
    } failure:^(NSError *error) {
        onFailure(error);
        //提现失败
        NSArray *piwikArr=@[
                            @[@"order_no",@""],
                            @[@"result",@"0"],
                            @[@"reason",esString(error.description)],
                            @[@"amt",esString(orderAmount)],
                            @[@"datepoint",timeForStatistics()],
                            
                            ];
        
        piwikEvent(@"withdraw",piwikArr);

    }];
}

#pragma mark - 其他
/**
 *  获取客户端设备类型
 *
 *  @return 客户端设备类型
 */
+ (NSString *)getClientType
{
    
    return @"I";
    /*
    NSString * deviceModel = [[UIDevice currentDevice] model];
    if ([deviceModel isEqualToString:@"iPhone"]) {
        return @"I";
    }
    return @"M";
     */
}

+ (void)returnErrorInfoWithDomain:(NSString *)domain response:(id)response failureBolck:(FailureBlock)failure
{
    NSDictionary * userInfo = nil;
    if (response[@"resultMessage"]) {
        NSLog(@"resultMessage = %@",response[@"resultMessage"]);
        userInfo = @{NSLocalizedDescriptionKey : response[@"resultMessage"]};
        [LTNUtilsHelper boxShowWithMessage:response[@"resultMessage"]];
        //网络失败
        /*
        NSArray *piwikArr=@[
                            @[@"order_no",@""],
                            @[@"result",@"0"],
                            @[@"reason",esString(error.description)],
                            @[@"amt",esString(orderAmount)],
                            @[@"datepoint",timeForStatistics()],
                            
                            ];
         */
        
        NSArray *piwikArr=@[
                            @[@"result",@"0"],
                            @[@"reason",esString(response[@"resultMessage"])],
                            @[@"datepoint",timeForStatistics()],
                            ];
        
        piwikEvent(@"resultMessage",piwikArr);
    }
    
    NSError * error = [[NSError alloc] initWithDomain:domain code:[response[@"resultCode"] intValue] userInfo:userInfo];
    if (failure) {
        failure(error);
    }
}

//添加block回调
+ (void)retrieveUserInfoWithFinishBlock:(VoidBlock)finishBlock{

    [BaseDataEngine apiForPath:kUserInfoUrl method:kGetMethod parameter:nil responseModelClass:[UserInfoModel class] onComplete:^(id response, id data, NSError *error) {
        if (!error) {
            [CurrentUser mine].userInfo = data;
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_Update_UserInfo object:nil userInfo:nil];
        }
        if(finishBlock)
            finishBlock();
    }];
}

+ (void)retrieveAccountInfoWithFinishBlock:(VoidBlock)finishBlock{
    
    [BaseDataEngine apiForPath:kUserAccountUrl method:kGetMethod parameter:nil responseModelClass:[AccountInfoModel class] onComplete:^(id response, id data, NSError *error) {
        if (!error) {
            [CurrentUser mine].accountInfo = data;
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_Update_UserInfo object:nil userInfo:nil];
        }
        if(finishBlock)
            finishBlock();
    }];
}

+ (void)retrieveAccountInfoContainFreeCountWithFinishBlock:(VoidBlock)finishBlock{
    
    [BaseDataEngine apiForPath:kUserAccountContainFreeCountUrl method:kGetMethod parameter:nil responseModelClass:[AccountInfoModel class] onComplete:^(id response, id data, NSError *error) {
        if (!error) {
            [CurrentUser mine].accountInfo = data;
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_Update_UserInfo object:nil userInfo:nil];
        }
        if(finishBlock)
            finishBlock();
    }];
}

+ (void)retrieveBankListWithFinishBlock:(ESHandlerBlock)finishBlock{
    
    ESDispatchOnDefaultQueue(^{
        [BaseDataEngine apiForPath:kBankBankList method:kGetMethod parameter:nil responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
            if (!error && data && isDictionary(data)) {
                [[NSUserDefaults standardUserDefaults] setValue:data forKey:kBankListAndBankIntroduction];
                if(finishBlock)
                    finishBlock(data);
            }
        }];
    });
}

+ (void)retrieveBannerListWithFinishBlock:(ESHandlerBlock)finishBlock{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"location":@0}];
        [BaseDataEngine apiForPath:kBannerList method:kGetMethod parameter:dic responseModelClass:[LTNBannerList class] onComplete:^(id response, id data, NSError *error) {
            if (!error) {
                LTNBannerList *list = (LTNBannerList *)data;
                if ([list isKindOfClass:[LTNBannerList class]]) {
                    NSMutableArray *listArray = [NSMutableArray array];
                    [listArray addObjectsFromArray:list.bannerList];
                    
                    NSMutableArray *arryHome = [NSMutableArray array];
                    NSMutableArray *arrayMutual = [NSMutableArray array];
                    NSMutableArray *arrayCrowding = [NSMutableArray array];
                    NSMutableArray *arrayLoan = [NSMutableArray array];
                    NSMutableArray *arrayTask = [NSMutableArray array];
                    
                    for (LTNBanner *banner in listArray) {
                        if ([banner.forModel isEqualToString:@"1"]) {//首页
                            [arryHome addObject:banner];
                        }else if([banner.forModel isEqualToString:@"2"]){//互助
                            [arrayMutual addObject:banner];
                        }else if ([banner.forModel isEqualToString:@"3"]){//众筹
                            [arrayCrowding addObject:banner];
                        }else if ([banner.forModel isEqualToString:@"4"]){//借款
                            [arrayLoan addObject:banner];
                        }else if ([banner.forModel isEqualToString:@"5"]){//任务
                            [arrayTask addObject:banner];
                        }
                    }
                    
                    [[NSUserDefaults standardUserDefaults] setValue:[NSKeyedArchiver archivedDataWithRootObject:arryHome] forKey:kBannerHomeAndBannerIntroduction];
                   
                    [[NSUserDefaults standardUserDefaults] setValue:[NSKeyedArchiver archivedDataWithRootObject:arrayMutual] forKey:kBannerMutualAndBannerIntroduction];
                    
                    [[NSUserDefaults standardUserDefaults] setValue:[NSKeyedArchiver archivedDataWithRootObject:arrayCrowding] forKey:kBannerCrowdingAndBannerIntroduction];
                   
                    [[NSUserDefaults standardUserDefaults] setValue:[NSKeyedArchiver archivedDataWithRootObject:arrayLoan] forKey:kBannerLoanAndBannerIntroduction];
                    
                    [[NSUserDefaults standardUserDefaults] setValue:[NSKeyedArchiver archivedDataWithRootObject:arrayTask] forKey:kBannerTaskAndBannerIntroduction];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
               
                if(finishBlock)
                    finishBlock(data);
            }
        }];
}

@end
