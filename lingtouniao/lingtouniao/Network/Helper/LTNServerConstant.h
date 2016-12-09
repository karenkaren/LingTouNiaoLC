//
//  LTNServerConstant.h
//  lingtouniao
//
//  Created by LiuFeifei on 15/11/24.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#ifndef LTNServerConstant_h
#define LTNServerConstant_h

#import "ServerEnvironmentConstants.h"

/**
 *  网络接口
 */
// baseUrl：基地址
#define kBaseUrl API_BASE_URL

// url：获取图片验证码
#define kGetPictureCaptchaUrl  @"/user/register/pictureCode"
// url：获取手机短信验证码
#define kGetMobileCaptchaUrl  @"/mobile/mobilecode/getMobileCode"
//@"user/login/mobileCode"
// url：用户注册
#define kUserRegisterUrl  @"/user/register/registerUser"
// url：用户登录
#define kUserLoginUrl  @"/user/login/login"
// url：修改密码
#define kModifyPasswordUrl  @"/user/login/editPwd"
// url：找回密码（忘记密码）
#define kRetrievePasswordUrl  @"/user/login/retrievePwd"
// url：服务端验证短信验证码
#define kVerifyMobileCodeUrl  @"/mobile/mobilecode/verifyMobileCode"
// url：用户推出
#define kUserLogoutUrl  @"/user/login/logout"
// url：首页推荐产品和banner
#define kHomeRecommendUrl  @"/homepage/recommendnew"
// url：产品列表
#define kProductsListUrl  @"/product/lists"
// url: 产品详情
#define kProductsDetailUrl  @"/productDetail"
// url：确认购买产品
#define kUserOrderOrderPrepareUrl  @"/user/order/orderPrepare"
// url: 互助下单准备
#define kUserOrderhzOrderhzprepareUrl @"/user/orderhz/orderhzprepare"
// url: 互助确认下单
#define kUserOrderconfirmUrl @"/user/orderconfirm"
// url: 众筹下单准备
#define kOrderZcOrderZcPrepareUrl @"/orderZc/orderZcPrepare"
// url: 众筹确认下单
#define kProductZcOrderSubmitUrl @"/product/zc/order/submit"
// url：2.4 我要理财—确认购买 （体验标＋虚拟标）
#define kBuyProductConfirmUrl  @"/product/buy/confirm"
// url：我的账户
#define kUserAccountUrl  @"/user/account/myAccount"
// url：我的账户-免费提现次数
#define kUserAccountContainFreeCountUrl  @"/user/account/myAccount/freeCount"
// url: 我的帐户拆分
#define kUserAccountSpiltUrl @"/user/account/myAccountAffiliated"
// url：账户信息
#define kUserAccountInfoUrl  @"/user/account/userInfo"
// url：我的投资
#define kUserInvestUrl  @"/user/account/orders"
// url：我的理财金券
#define kUserCouponUrl  @"/user/account/myFinancialCoupon"
//url:  用户实名制
#define kUserAuthUrl   @"/user/register/userAuthPwd"
// url: 总资产
#define kTotalAccountUrl @"/user/account/totalaccount"
// url: 鸟币明细
#define kBirdCoinAmountUrl @"/user/account/birdCoinAmount"
// url: 余额明细
#define kBalanceDetailUrl @"/account/balanceDetail"
// url: 购买记录
#define kPurchaseHistoryUrl @"/product/purchasehistory"
//url:  获取银行卡限额
#define kLimitAmountUrl @"/bank/limitAmount"
//url:  绑卡--[需要去联动网页]
#define kUserBindBankCardUrl   @"/user/bindBankCard"
//url:  充值-[需要去联动网页]
#define kUserRechargeUrl   @"/user/recharge"
//url:  提现-[需要去联动网页]
#define kUserWithdrawalseUrl   @"/user/withdrawals"
//url:  收益明细
#define kUncRevenueUrl @"/user/uncRevenue"
//url:好友统计
#define kFriendsCountUrl @"/user/account/friends"
//url:合伙人
#define kPartnerUrl @"/user/partner"
//url:已发放奖励
#define kEarningUrl @"/user/partner/earnings"
//url:补充合伙人
#define kReplenishUrl @"/user/partner/replenish"
// update
#define kCheckUpdateUrl @"/app/global/checkupdate"
//url:feedback
#define kFeedbackUrl @"/user/aboutus/feedback"
// user information
#define kUserInfoUrl @"/user/userInfo"
//银行卡列表
#define kBankBankList @"/bank/bankList"
//查看换卡状态
#define kScheduleStatus @"/user/replaceBankCard/status"
//提交换卡的阅读结果
#define kHasReadDesStatus @"/user/replaceBankCard/read"
//my investiment
#define kMyInvestimentUrl @"/user/account/myInvestment"
// url:活期
#define kCurrentDepositUrl @"/product/current/homepage"
// url:活期转入
#define kCurrentRollInUrl @"/product/current/buy"
// url:活期转出
#define kCurrentRollOutUrl @"/product/current/extract"
// url:活期明细
#define kCurrentIncomeListUrl @"/user/current/incomeList"
// url:安心投列表
#define kFindOfflineOrder @"/product/findOfflineOrder"
// url:免密支付申请
#define kUserAgreeMianMiUrl @"/user/agreement"
//url:换卡申请
#define kChangeCardUrl @"/user/replaceBankCard"
// url:获取金蛋接口
#define kGoldenEggGetUrl @"/goldenegg/get"
// url:砸蛋之后提交接口
#define kGoldenEggSubmitUrl @"/goldenegg/submit"
// url:消息中心数据接口
#define kMessageList @"/message/list"
// url :消息中心全读
#define kMessageRead @"/message/read"
// url:借款进度查询
#define kLoanQuery @"/loan/query"
// url:理财金券兑换
#define kExchangeCode @"/user/exchangeCode/exchange"  
// url:生成赠券码
#define kPresentCode @"/app/presentCoupon/presentCode/get"
// url:我的任务
#define kTaskListUrl @"/task/list"
// url:领取奖励
#define kTaskSubmitUrl @"/task/submit"
// url:任务状态进度
#define kTaskNum @"/task/num"
// url:检查是否完成任务
#define kTaskCheck @"/task/check"
// URL:可运营启动页
#define kFirstPage @"/firstPage"
// url:banner
#define kBannerList @"/page/banner"
// url:我的互助
#define kMyHelpUrl @"/help/myHelp"
// url:互助列表
#define kHelpListUrl @"/help/helpList"
// url:我的众筹
#define kOrderZcUrl @"/orderZc/myOrderZc"
// url:众筹列表
#define kProductZcUrl @"/productZc/producZcSearch"
// url:众筹购买记录
#define kSearchOrderZc @"/orderZc/searchOrderZc"
// url:互助购买记录
#define kMemberListUrl @"/help/memberList"
// url:我的地址
#define kGetAddressUrl @"/addressManage/getAddress"
// url:编辑地址
#define kUpdateAddressUrl @"/addressManage/updateAddress"
// url:删除地址
#define kDelteAddressUrl @"/addressManage/delAddress"
// url:增加地址
#define kCreateAddressUrl @"/addressManage/addAddress"


/**
 *  h5页面
 */
// 安全保障
#define kH5InsuranceUrl @"/h5/insurance.html"
// 首页风险备用金
#define kH5ReservefundUrl @"/h5/reservefund.html"
// 关于领投鸟
#define kH5AboutUrl @"/h5/about.html"
// 帮助中心
#define kH5HelpCenter @"/h5/help-center.html"
//鸟币帮助
#define kH5BirdCoinHelp @"/h5/help-money-use.html"
// 砸金蛋
#define kH5Drawaward @"/h5/drawaward.html"


// 同意协议书
#define kH5AcceptUrl @"/h5/accept-register.html"
// 身份认证协议
#define kH5Accept_IDUrl @"/h5/accept-id.html"
// 绑定银行卡
#define kH5AcceptBindUrl @"/h5/accept-bind.html"
// 随心投协议书
#define kH5AcceptCurrentUrl @"/h5/project-accept-current.html"


// 产品分享链接
#define kH5ShareUrl @"/h5/share.html"
// 首页信托
#define kH5ProfitUrl @"/h5/profit.html"

// 会员公约
#define kH5HuiyuanUrl @"/h5/protocol/vipProtocol/protocol.html"
// 奖励规则
#define kH5RewardruleUrl  @"/h5/rewardrule.html"
// 合伙人特权
#define kH5PartnerUrl  @"/native/app_partner/app_partner.html"  
//提现说明
#define kH5WithDrawIntroUrl  @"/h5/withdrawintro.html"
//跳往成功界面
#define kH5ProjectTransferUrl  @"/h5/success-invest.html"
// 随心投转入成功界面
#define kH5CurrentTransferinUrl  @"/h5/success-transferin.html"
// 联动介绍
#define kH5AboutUmpayUrl @"/h5/link-info.html"
// 新手指引
#define kH5IntroGuideUrl @"/h5/newsguid.html"
//借款列表
#define kLoanShow @"/loan/loanType"
//借款
#define kRequestLoan @"/loan/submit"
// 借款开关
#define kLoanSettingUrl @"/loan/loanSetting"


//银行异常信息
#define kBankListNotice @"/bank/bankList/notice"

//tips信息
#define kSysConfig @"/sys/sysConfig"

//tips信息
#define kStaticSource @"/staticSource"


 //合法域名
#define kLegalDomain @"/mobile/mobiledomain"

//赠送码获得金券

#define kPresentCoupon @"/app/presentCoupon/couponInfo/get"

ES_INLINE NSString * absolutePath(NSString *path) {

    NSString *fullPath;
    if([path hasPrefix:@"http"])
        fullPath=path;
    else{
        fullPath = [NSString stringWithFormat:@"%@%@", API_BASE_URL, path];
    }
    return fullPath;
}



static NSArray *cachePaths;
ES_INLINE BOOL shouldCache(NSString *path) {
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        NSArray *cacheURIs=@[/* TODO:注册需要缓存的URI */
                             // kHomeRecommendUrl,
                             
                             // url：我的账户
                             kUserAccountUrl,
                             // url：账户信息
                             kUserAccountInfoUrl,
                             // url：我的投资
                             kUserInvestUrl,
                             // url：我的理财金券
                             kUserCouponUrl,
                             //url:  用户实名制
                             kUserAuthUrl,
                             // url: 总资产
                             kTotalAccountUrl,
                             // url: 鸟币明细
                             kBirdCoinAmountUrl,
                             // url: 余额明细
                             kBalanceDetailUrl,
                             // url: 购买记录
                             kPurchaseHistoryUrl,
                             //url:  获取银行卡限额
                             kLimitAmountUrl,
                             
                             //url:  收益明细
                             kUncRevenueUrl,
                             //url:好友统计
                             kFriendsCountUrl,
                             //url:合伙人
                             kPartnerUrl,
                             //url:已发放奖励
                             kEarningUrl,
                            // user information
                             kUserInfoUrl,
                             //银行卡列表
                            // kBankBankList,
                             //my investiment
                             kMyInvestimentUrl,
                             // url:活期
                             kCurrentDepositUrl,
                             // url:活期明细
                             kCurrentIncomeListUrl,
                             // url:安心投列表
                             kFindOfflineOrder,
                             
        /**
         *  h5页面
         */
                             // 安全保障
                             kH5InsuranceUrl,
                             // 首页风险备用金
                             kH5ReservefundUrl,
                             // 关于领投鸟
                             kH5AboutUrl,
                             // 帮助中心
                             kH5HelpCenter,
                             
                            // 同意协议书
                             kH5AcceptUrl,
                             // 身份认证协议
                             kH5Accept_IDUrl,
                             // 绑定银行卡
                             kH5AcceptBindUrl,
                             // 随心投协议书
                             kH5AcceptCurrentUrl,
                             
                             
                            // 首页信托
                             kH5ProfitUrl,
                             // 奖励规则
                             kH5RewardruleUrl,
                             //提现说明
                             kH5WithDrawIntroUrl,
                             //借款列表
                             kLoanShow,
                             
                        
                             //:消息中心全读
                             kMessageRead,
                             
                             // url:借款进度查询
                             kLoanQuery,
                             
                             
                             //银行异常信息
                             
                             kBankListNotice,
                             
                             
                             //合法域名
                             kLegalDomain,
                              
                              ];
        
        NSMutableArray *tempArray=[NSMutableArray array];
        [cacheURIs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [tempArray addObject:absolutePath(obj)];
        }];
        
        cachePaths =[NSArray arrayWithArray:tempArray];
        
    });

    if([cachePaths count]==0)
        return NO;
 
    for(NSString *cachePath in cachePaths){
        if([path isEqualToString:cachePath])
            return YES;
    }
    return NO;
}



#endif /* LTNServerConstant_h */


