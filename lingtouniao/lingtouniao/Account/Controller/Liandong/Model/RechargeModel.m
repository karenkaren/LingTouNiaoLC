//
//  RechargeModel.m
//  lingtouniao
//
//  Created by 徐凯 on 15/12/25.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "RechargeModel.h"

@implementation RechargeModel

-(NSString *)belongBank
{
    return  [CurrentUser mine].userInfo.belongBank;
}

-(NSString *)bankNo
{
    return  [CurrentUser mine].userInfo.bankNo;

}



-(NSString *)logoUrl{
  //   return [NSString stringWithFormat:@"icon_%@",[CurrentUser mine].userInfo.belongBank];
    return [CurrentUser mine].userInfo.logoUrl;
}

-(void)GET_UserRechargeWithOrderAmount:(NSString *)orderAmount success:(void(^)(BOOL success))onSuccess  failure:(void(^)(NSString *error))onFailure
{
    [LTNServerHelper userRechargeWithOrderAmount:orderAmount success:^(BindBankCardModel *model) {
        
        _bindBankCardModel = model;
        onSuccess(YES);
        
    } failure:^(NSError *error) {
         onFailure(error.localizedDescription);
    }];


}

/*
 
 
 {
 plain = "account_id=02000000122378&amount=100&charset=UTF-8&com_amt_type=2&mer_date=20160830&mer_id=7050189&notify_url=http%3A%2F%2F192.168.18.194%3A8080%2FumpayGateway&order_id=CZ20160830_360005&pay_type=DEBITCARD&ret_url=http%3A%2F%2F192.168.18.194%3A8080%2FumpayGateway%2Fmer_recharge_person&service=mer_recharge_person&sign_type=RSA&user_id=UB201606291929520000000000071739&user_ip=192.168.18.17&version=4.0";
 sign = "asmbqy1MzwM%2B55cIsJ2lcm1qBC8Bq%2FPblafgZpLCbtmPzdYff1tDQCjG%2FhdpKoACZPx2ypdgHjed9eBbcaqyW%2BRRSL14KJ50d%2FTgs7jY9YFr8DPpepAfLtwnL2KMEAMCqxCBdaWYieVSlEA%2BrQOLQeLXDtembbAquBVzqi7BVrY%3D";
 url = "http://114.113.159.196:9200/spay/pay/payservice.do?account_id=02000000122378&amount=100&charset=UTF-8&com_amt_type=2&mer_date=20160830&mer_id=7050189&notify_url=http%3A%2F%2F192.168.18.194%3A8080%2FumpayGateway&order_id=CZ20160830_360005&pay_type=DEBITCARD&ret_url=http%3A%2F%2F192.168.18.194%3A8080%2FumpayGateway%2Fmer_recharge_person&service=mer_recharge_person&sign_type=RSA&user_id=UB201606291929520000000000071739&user_ip=192.168.18.17&version=4.0&sign=asmbqy1MzwM%2B55cIsJ2lcm1qBC8Bq%2FPblafgZpLCbtmPzdYff1tDQCjG%2FhdpKoACZPx2ypdgHjed9eBbcaqyW%2BRRSL14KJ50d%2FTgs7jY9YFr8DPpepAfLtwnL2KMEAMCqxCBdaWYieVSlEA%2BrQOLQeLXDtembbAquBVzqi7BVrY%3D";
 }

 
 
 继续走联动 ，如果返回失败，将会有一个失败的页面 里面可以获取懂啊联动的订单号
 
 
 成功 联动返回 URL
 
 <NSMutableURLRequest: 0x7fbf2599f000> { URL: http://114.113.159.196:9200/spay/pay/wyP2PPayReturn.do?certType=1&rpid=WPG1808012847029&amount=100&payState=0&mobileId=17760000050&certCode=c4ceba8822ca93cb7748af4d5b726d4308fe3c14d7a6626a&notifyType=1&retMsg=%E4%BA%A4%E6%98%93%E6%88%90%E5%8A%9F&retUrl=http%253A%252F%252F114.113.159.196%253A9200%252Fspay%252Fpay%252FwyP2PPayReturn.do&bankCheckDate=20160830&orderId=CZ20160830_360006&bankCardType=0&instId=00000012&orderDate=20160830&trace=1608301808654822&merId=7050189&paySeq=4403940108605760&merCheckDate=20160830&bankId=00019000&productId=P15600G0&accType=0&sign=7b2cd53e43a9519cdd2d3c4c6e7f9cb8a2068dea&stlDate=20160830&retCode=0000&cardHolder=C1F5B7C6B7C6&binBankId=B004&Memo=%E4%BA%A4%E6%98%93%E6%88%90%E5%8A%9F&bankTrace=598730622488&accessType=W&bankAccount=b56aa38dbe521d722db012e8893a2698039c3d72060fb92d }
 
 
 
 
 成功跳转h5
 
 
 2016-08-30 18:18:18.383 lingtouniao[7558:156404] void SendDelegateMessage(NSInvocation *): delegate (webView:decidePolicyForNavigationAction:request:frame:decisionListener:) failed to return after waiting 10 seconds. main run loop mode: kCFRunLoopDefaultMode
 2016-08-30 18:18:23.017 lingtouniao[7558:155906] -[BaseWebViewController webView:shouldStartLoadWithRequest:navigationType:] #302 <CustomizedBackWebViewController: 0x7fbf25d4a4d0> shouldStartLoadRequest:
 =====
 <NSMutableURLRequest: 0x7fbf25a63640> { URL: http://192.168.18.194:8080/umpayGateway/mer_recharge_person?trade_no=1608301808017862&com_amt_type=2&mer_date=20160830&sign_type=RSA&ret_msg=%E5%85%85%E5%80%BC%E6%88%90%E5%8A%9F&order_id=CZ20160830_360006&com_amt=200&version=4.0&sign=qUGoPCx9rH%2F0cEybKi3AMLPBjFqKnRHCjR%2BiBFYlE%2BgDF0O0rLBZVzq7KP8MCfM4gppcsDn8tXdoReWxSl7patTvet9%2BYEKyIVgl2VKYezBRy979LdW6k33WOPSsq%2BZfwN2DRrloGcpgRkdFf8owMGStIjV%2BJNO265r1xVRy1U8%3D&balance=100100&ret_code=0000&mer_id=7050189&mer_check_date=20160824&service=recharge_notify }
 =====
 2016-08-30 18:18:47.560 lingtouniao[7558:156404] void SendDelegateMessage(NSInvocation *): delegate (webView:decidePolicyForNavigationAction:request:frame:decisionListener:) failed to return after waiting 10 seconds. main run loop mode: kCFRunLoopDefaultMode

 
 
 */


@end
