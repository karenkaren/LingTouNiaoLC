//
//  LTNBaseSlideViewController.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/2/22.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNBaseSlideViewController.h"
#import "QCSlideSwitchView.h"

@interface LTNBaseSlideViewController ()<QCSlideSwitchViewDelegate>

@end

@implementation LTNBaseSlideViewController

- (void)setViewControllers:(NSArray *)viewControllers
{
    _viewControllers = viewControllers;
    [self createQCSlideSwitchView];
}

- (void)createQCSlideSwitchView
{
    QCSlideSwitchView * slideSwitchView = [[QCSlideSwitchView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:slideSwitchView];
    
    CGFloat topHeight = NavigationBarHeight;
    slideSwitchView.slideSwitchViewDelegate = self;
    slideSwitchView.topScrollViewHeight = topHeight;
    
    UIView *lineView = [[UIView alloc] initWithFrame: CGRectMake(0, topHeight - [Utility lineWidth], slideSwitchView.width, [Utility lineWidth])];
    lineView.backgroundColor = HexRGB(0xe5e5e5);
    [slideSwitchView addSubview:lineView];
    
    slideSwitchView.buttonWidthOffset = 44;
    slideSwitchView.buttonLabelFont = [CustomerizedFont systemFontOfSize:14.0];
    slideSwitchView.topScrollView.backgroundColor = [UIColor whiteColor];
    slideSwitchView.tabItemNormalColor = HexRGB(0x666666);
    slideSwitchView.tabItemSelectedColor = COLOR_MAIN;
    UIView *bottomSlideView = [[UIView alloc] initWithFrame:CGRectMake(0, slideSwitchView.topScrollViewHeight-2, 0, 2)];
    bottomSlideView.backgroundColor = COLOR_MAIN;
    slideSwitchView.shadowView = bottomSlideView;
    
    [slideSwitchView buildUI];
    [slideSwitchView adjustScreenWidth];
    [slideSwitchView setSelectIndex:0 animated:NO];
}

#pragma mark -- QCSlideSwitchViewDelegate
- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view
{
    return self.viewControllers.count;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    return self.viewControllers[number];
}

- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    [self slideSwitchViewWithSelectTab:number];
}

- (void)slideSwitchViewWithSelectTab:(NSUInteger)number{};

@end
