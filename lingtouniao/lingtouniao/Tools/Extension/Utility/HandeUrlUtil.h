//
//  HandeUrlUtil.h
//  haowan
//
//  Created by lihuaming on 15/3/18.
//  Copyright (c) 2015年 iyaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#define kTargetURLKangDa @"kangdayuzhen"

@interface HandeUrlUtil : NSObject
+ (void)receiveOpenUrlString:(NSString *)urlString fromNavViewController:(UINavigationController*)navController andHaveNav:(BOOL)isHaveNav andHaveBtn:(BOOL)isHaveBtn andShareName:(NSString *)shareName andShareIcon:(NSString *)shareIcon andShareUrl:(NSString *)shareUrl andShareContent:(NSString *)shareContent;
// 收到 外部打开的链接
+ (void)receiveOpenUrlString:(NSString *)urlString fromNavViewController:(UINavigationController*)navConreoller;
+ (void)handleOpenUrlWithParameter:(NSDictionary *)parameter fromNavViewController:(UINavigationController*)navConreoller;
+ (BaseViewController *)createWebViewWithData:(NSDictionary *)parameter;

@end
