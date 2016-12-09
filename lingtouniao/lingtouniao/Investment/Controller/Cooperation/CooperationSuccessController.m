//
//  CooperationSuccessController.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/10/9.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "CooperationSuccessController.h"

@interface CooperationSuccessController ()

@end

@implementation CooperationSuccessController

- (void)initUIView
{
    self.title = @"支付成功";
    [self setupUIWithSuccessTitle:@"支付成功" buttonTitle:@"查看我的互助" handle:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_Update_UserInfo object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNeedToRefreshHomePage object:nil];
        [[LTNCore globleCore] jumpToMyCooperation];
    }];
}

@end
