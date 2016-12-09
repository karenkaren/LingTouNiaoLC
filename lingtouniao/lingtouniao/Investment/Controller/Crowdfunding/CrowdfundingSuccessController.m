//
//  CrowdfundingSuccessController.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/10/9.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "CrowdfundingSuccessController.h"

@interface CrowdfundingSuccessController ()

@end

@implementation CrowdfundingSuccessController

- (void)initUIView {
    self.title = @"支付成功";
    [self setupUIWithSuccessTitle:@"支付成功" buttonTitle:@"查看我的众筹" handle:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_Update_UserInfo object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNeedToRefreshHomePage object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNeedToRefreshCrowfundingList object:nil];
        [[LTNCore globleCore] jumpToMyCrowdfunding];
    }];
}

@end
