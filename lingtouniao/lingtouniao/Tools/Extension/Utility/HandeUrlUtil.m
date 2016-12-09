//
//  HandeUrlUtil.m
//  haowan
//
//  Created by lihuaming on 15/3/18.
//  Copyright (c) 2015年 iyaya. All rights reserved.
//

#import "HandeUrlUtil.h"
#import "UrlParamUtil.h"
#import "BaseWebViewController.h"

@implementation HandeUrlUtil
// 收到 外部打开的链接
+ (void)receiveOpenUrlString:(NSString *)urlString fromNavViewController:(UINavigationController*)navController andHaveNav:(BOOL)isHaveNav andHaveBtn:(BOOL)isHaveBtn andShareName:(NSString *)shareName andShareIcon:(NSString *)shareIcon andShareUrl:(NSString *)shareUrl andShareContent:(NSString *)shareContent{
    if (!urlString.length) {
        NSLog(@"跳转的URL不能为nil");
        return;
    }
    NSURL *url = [NSURL URLWithString:urlString];
    if ([[url scheme] isEqualToString:@"com.wuyou.lingtouniao"]) {
        [self receiveOpenUrlString:urlString fromNavViewController:navController];
    } else {
        UINavigationController * currentNavController = nil;
        if (navController) {
            currentNavController = navController;
        }
        BaseWebViewController * viewController = [[BaseWebViewController alloc] initWithURL:[url absoluteString]];
        viewController.hasNav = isHaveNav;
        viewController.isHaveRightBtn = isHaveBtn;
        
        viewController.shareUrl = shareUrl;
        viewController.shareContent = shareContent;
        viewController.shareIcon = shareIcon;
        viewController.shareName = shareName;
        
        viewController.hidesBottomBarWhenPushed = YES;
        [currentNavController pushViewController:viewController animated:YES];
    }
}

// 收到 外部打开的链接
+ (void)receiveOpenUrlString:(NSString *)urlString fromNavViewController:(UINavigationController*)navController
{
    if (!urlString.length) {
        NSLog(@"跳转的URL不能为nil");
        return;
    }
    NSURL *url = [NSURL URLWithString:urlString];
    if (!url.scheme) {
        NSLog(@"跳转URL不合法错误：%@",urlString);
        return;
    }
    // 打开界面
//    NSDictionary *parameter = [UrlParamUtil getParamsFromOtherApp:url];
//    BaseViewController *currentController = (BaseViewController *)navController.visibleViewController;
//    [self handleOpenUrlWithParameter:parameter fromNavViewController:navController];
}

//create webview
+ (BaseViewController *)createWebViewWithData:(NSDictionary *)parameter {
    BaseWebViewController *viewController;
    return viewController;
}

+ (void)handleOpenUrlWithParameter:(NSDictionary *)parameter fromNavViewController:(UINavigationController*)navConreoller {

}


@end
