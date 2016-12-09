//
//  SplashController.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/8/10.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "SplashController.h"
#import "CustomizedBackWebViewController.h"
#import "LTNTabBarController.h"
#import "SplashModel.h"
#import "UIImageView+WebCache.h"

static NSInteger seconds = 3;

@interface SplashController ()

@property(nonatomic, strong) UIButton * skipButton;
@property(nonatomic, strong) NSTimer * timer;
@property(nonatomic, assign) BOOL isClose;

@end

@implementation SplashController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 可运营图片
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[SplashModel sharedSplash].splash.pageUrl]];
    [self.view addSubview:imageView];
    
    // 跳过按钮
    self.isClose = [SplashModel sharedSplash].splash.isClose;
    NSString * skipTitle = self.isClose ? [NSString stringWithFormat:@"%@\n%lds", locationString(@"yunying_skip"), seconds] : [NSString stringWithFormat:@"%lds", seconds];
    self.skipButton = [Utility createButtonWithTitle:skipTitle color:[UIColor whiteColor] font:[CustomerizedFont heiti:11] block:^(UIButton *btn) {
        if (self.isClose) {
            [self.timer invalidate];
            [LTNCore gesturePasswordController];
            [[LTNCore globleCore] loadMainTabbarController];
        }
    }];
    self.skipButton.size = CGSizeMake(40, 40);
    self.skipButton.top = 22;
    self.skipButton.right = self.view.width - 12;
    self.skipButton.backgroundColor = kRGBAColor(0, 0, 0, 0.6);
    self.skipButton.layer.cornerRadius = self.skipButton.width * 0.5;
    self.skipButton.layer.masksToBounds = YES;
    self.skipButton.titleLabel.numberOfLines = 0;
    self.skipButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.skipButton];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCountdown) userInfo:nil repeats:YES];
    
    // 查看详情按钮
    NSInteger isSkip = [SplashModel sharedSplash].splash.isSkip;//是否跳转， 0-不跳转 1-h5 2-原生模块
    if (isSkip == 1 || isSkip == 2) {
        UIButton * checkDetailButton = [Utility createButtonWithTitle:locationString(@"yunying_detail") color:[UIColor whiteColor] font:[CustomerizedFont heiti:16] block:^(UIButton *btn) {
            [self.timer invalidate];
            [self gotoDetail:isSkip];
        }];
        checkDetailButton.size = CGSizeMake(120, 40);
        checkDetailButton.bottom = self.view.height - DimensionBaseIphone6(70);
        checkDetailButton.centerX = self.view.width * 0.5;
        checkDetailButton.backgroundColor = HexRGB(0xea5504);
        checkDetailButton.layer.cornerRadius = checkDetailButton.height * 0.5;
        checkDetailButton.layer.masksToBounds = YES;
        [self.view addSubview:checkDetailButton];
    }
}

// 查看详情
- (void)gotoDetail:(NSInteger)isSkip
{
    [[LTNCore globleCore] loadMainTabbarControllerOne];
    [LTNCore gesturePasswordControllerWithBlock:^{
        //isSkip:是否跳转， 0-不跳转 1-h5 2-原生模块(此处必大于0)
        if (isSkip == 1) {
            [self gotoH5];
            return;
        }
        [self gotoNative];
    }];
}

// 详情为h5
- (void)gotoH5
{
    [[LTNCore globleCore] jumpToWebviewController:[SplashModel sharedSplash].splash.skipModel];
}

// 详情为原生模块
- (void)gotoNative
{
    NSString * modelString = [SplashModel sharedSplash].splash.skipModel;
    // 项目列表
    if ([modelString isEqualToString:@"LB"]) {
        [[LTNCore globleCore] jumpToInvestmentController];
        return;
    }
    // 新手专区
    if ([modelString isEqualToString:@"XS"]) {
        [[LTNCore globleCore] jumpToNewHandArea];
        return;
    }
    [LTNUtilsHelper actionWhenLogin:^{
        // 我的投资
        if ([modelString isEqualToString:@"TZ"]) {
            [[LTNCore globleCore] jumpToMyInvestment];
            return;
        }
        // 我的任务
        if ([modelString isEqualToString:@"RW"]) {
            [[LTNCore globleCore] jumpToMyTask];
            return;
        }
        // 进阶专区
        if ([modelString isEqualToString:@"JJ"]) {
            [[LTNCore globleCore] jumpToStageArea];
            return;
        }
        // 活动专区
        if ([modelString isEqualToString:@"HD"]) {
            [[LTNCore globleCore] jumpToLimitTimeArea];
            return;
        }
        // 合伙人
        if ([modelString isEqualToString:@"HH"]) {
            [[LTNCore globleCore] jumpToMyPartner];
            return;
        }
    } onVC:self];
    
    return;
}

- (void)updateCountdown
{
    seconds--;
    if (seconds) {
        NSString * skipTitle = self.isClose ? [NSString stringWithFormat:@"%@\n%lds", locationString(@"yunying_skip"), seconds] : [NSString stringWithFormat:@"%lds", seconds];
        [self.skipButton setTitle:[NSString stringWithFormat:skipTitle, seconds] forState:UIControlStateNormal];
        return;
    }
    [self.timer invalidate];
    [LTNCore gesturePasswordController];
    [[LTNCore globleCore] loadMainTabbarController];
}

@end
