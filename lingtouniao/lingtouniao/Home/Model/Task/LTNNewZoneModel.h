//
//  LTNNewZoneModel.h
//  lingtouniao
//
//  Created by 郑程锋 on 16/4/26.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "BaseModel.h"

@interface LTNNewZoneList : BaseModel

@property (nonatomic) NSArray *taskList;

@end

@interface LTNNewZoneModel : BaseModel

// 用户达到值
@property (nonatomic, copy) NSString * taskCurrentValue;
// 结束需达到的条件
@property (nonatomic, copy) NSString * taskEndValue;

@property (nonatomic, copy) NSString * taskGroupId;
@property (nonatomic) NSString *taskIcon;//图片
@property (nonatomic) NSString *taskName;//标题
@property (nonatomic) NSString *taskDesc;//说明
@property (nonatomic) NSString *awardDesc;//奖励描述
@property (nonatomic) NSString *taskUserStatus;//用户完成任务状态 0-未完成 1-完成未领奖 2-已领奖

@property (nonatomic) NSString *awardIcon;//奖励图片

@property (nonatomic) NSString *ID;//任务id
@property (nonatomic) BOOL isLogin;//是否登陆(0:要;1:不要)
@property (nonatomic) BOOL isEnd;//任务是否结束(0:未结束,1:结束)
@property (nonatomic) BOOL isStart;//是否开始(0:未开始，1：开始)

@property (nonatomic) NSString *taskStatus;//任务本身状态(任务状态:草稿:CG;未开始:WKS;开始:KS;已结束:JS)
@property (nonatomic) NSString * taskEndCondtion;//结束条件:累投:LT;累冲:LC;单笔投资:DBTZ;单笔充值:DBCZ;其他:OTHER

@property (nonatomic) NSString *skipType;//跳转类别(0:原生页面,1:h5页面)
@property (nonatomic) NSString *skipMode;//跳转URL(原生跳native url, h5跳 网页url),跟skipType对应，如果是0,做任务的时候那么就跳转到对应的地方：ZC:注册 SM:实名 CZ:充值 BK：绑卡 TZ:投资 OTHER:其他  目前冗余类型；如果是skipType为1,那么就跳转到对应的url

@end
