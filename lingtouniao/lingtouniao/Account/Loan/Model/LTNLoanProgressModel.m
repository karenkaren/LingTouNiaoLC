//
//  LTNLoanProgressModel.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/4/5.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNLoanProgressModel.h"

@implementation LTNLoanProgressModel

- (instancetype)initWithData:(id)data
{
    self = [super init];
    if (self) {
        [self parseWithData:(id)data];
    }
    return self;
}

- (void)parseWithData:(id)data
{
    /*
     {
     "data": {
     "code": null,
     "intents": [
     {
     "borrow_amount": "50-100万",
     "create_time": "2016-03-29 15:22:02",
     "cust_id": 22200910,
     "d_payment_advance": null,
     "d_payment_percent": null,
     "email": "ceshi@163.com",
     "final_payment": null,
     "follow_remark": "等待审核",
     "follow_tag": 11,
     "valid_tag":1,
     "handle_user_id": 100008,
     "house_advance": null,
     "house_cover": null,
     "house_price": null,
     "intent_area": "0021",
     "intent_id": 200001,
     "intent_remark": "说明说明文本",
     "intent_username": "测试APP",
     "loan_date": "三个月",
     "loan_type": 1,
     "loaner": null,
     "mediation_name": "中介小李",
     "mobile_phone": "17721468338",
     "owner_depart_id": 100000,
     "owner_id": 100008,
     "property_location": null,
     "pspt_no": "542224198503160096",
     "r_loan_advance": null,
     "sex": 1,
     "update_time": null
     }
     ],
     "message": null,
     "totalCount": null
     },
     "resultCode": "0",
     "resultMessage": null
     }
     */
    NSString * loanStatusPath = [[NSBundle mainBundle] pathForResource:@"LoanStatus" ofType:@"plist"];
    NSDictionary * loanStatusDic = [NSDictionary dictionaryWithContentsOfFile:loanStatusPath];
    NSDictionary * dic1 = nil;
    NSDictionary * dic2 = nil;
    NSDictionary * dic3 = nil;
    NSDictionary * dic4 = nil;
    // 11-待处理
    if ([data[@"follow_tag"] integerValue] == 11) {
        dic2 = loanStatusDic[@"21"][@"waiting"];
        dic3 = loanStatusDic[@"31"][@"waiting"];
        dic4 = loanStatusDic[@"41"][@"waiting"];
        if ([data[@"valid_tag"] boolValue]) {
            // 成功
            dic1 = loanStatusDic[@"11"][@"success"];
        } else {
            // 失败
            dic1 = loanStatusDic[@"11"][@"failure"];
        }
    }
    // 21-跟进中
    else if ([data[@"follow_tag"] integerValue] == 21) {
        dic1 = loanStatusDic[@"11"][@"success"];
        dic3 = loanStatusDic[@"31"][@"waiting"];
        dic4 = loanStatusDic[@"41"][@"waiting"];
        if ([data[@"valid_tag"] boolValue]) {
            // 成功
            dic2 = loanStatusDic[@"21"][@"success"];
        } else {
            // 失败
            dic2 = loanStatusDic[@"21"][@"failure"];
        }
    }
    // 31-审核中
    else if ([data[@"follow_tag"] integerValue] == 31) {
        dic1 = loanStatusDic[@"11"][@"success"];
        dic2 = loanStatusDic[@"21"][@"success"];
        dic4 = loanStatusDic[@"41"][@"waiting"];
        if ([data[@"valid_tag"] boolValue]) {
            // 成功
            dic3 = loanStatusDic[@"31"][@"success"];
        } else {
            // 失败
            dic3 = loanStatusDic[@"31"][@"failure"];
        }
    }
    // 41-申请成功
    else if ([data[@"follow_tag"] integerValue] == 41) {
        dic1 = loanStatusDic[@"11"][@"success"];
        dic2 = loanStatusDic[@"21"][@"success"];
        dic3 = loanStatusDic[@"31"][@"success"];
        if ([data[@"valid_tag"] boolValue]) {
            // 成功
            dic4 = loanStatusDic[@"41"][@"success"];
        } else {
            // 失败
            dic4 = loanStatusDic[@"41"][@"failure"];
        }
    } else {
        dic1 = loanStatusDic[@"11"][@"waiting"];
        dic2 = loanStatusDic[@"21"][@"waiting"];
        dic3 = loanStatusDic[@"31"][@"waiting"];
        dic4 = loanStatusDic[@"41"][@"waiting"];
    }
    
    // detail   attributeText  title
    NSArray *array=@[dic1, dic2, dic3, dic4];
    NSMutableArray *mArray=[NSMutableArray array];
    for(NSDictionary *dic in array){
        
        NSMutableDictionary *tempDic= [NSMutableDictionary dictionaryWithDictionary:dic];
        
        NSArray *keys=[tempDic allKeys];
        for(NSString *key in keys){
            if([key isEqualToString:@"detail"]||
               [key isEqualToString:@"attributeText"]||
               [key isEqualToString:@"title"]){
                [tempDic setObject:locationString(tempDic[key]) forKey:key];
            }

        }
        
        [mArray addObject:tempDic];
    }
    
    
   
    
    self.datas = mArray;
    
    
}

@end
