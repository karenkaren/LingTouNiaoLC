//
//  CrowdfundingInvestSummaryController.h
//  lingtouniao
//
//  Created by LiuFeifei on 16/9/29.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "InvestSummaryViewController.h"

@interface CrowdfundingInvestSummaryController : InvestSummaryViewController

// 众筹档位
@property (nonatomic, assign) NSInteger stepId;
// 奖励类型
@property (nonatomic, assign) BOOL isRealObject;

@end
