//
//  LTNRewardModel.h
//  lingtouniao
//
//  Created by 郑程锋 on 15/12/28.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "BaseModel.h"

@interface LTNRewardModelList : BaseModel

@property (nonatomic) NSArray *listPartnerEarnings;

@end


@interface LTNRewardModel : BaseModel
@property (nonatomic) NSString *reward;//奖励收益
@property (nonatomic) NSString *mobileNo;//邀请的好友
@property (nonatomic) NSString *orderReward;//投资收益
@end
