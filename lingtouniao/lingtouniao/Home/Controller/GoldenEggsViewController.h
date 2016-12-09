//
//  GoldenEggsViewController.h
//  lingtouniao
//
//  Created by 徐凯 on 16/3/15.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "BaseViewController.h"
#import "LTNTabBarController.h"

@interface GoldenEggsViewController : BaseViewController
@property (strong, nonatomic) UIButton *cancelButton;//取消按钮

@property (strong, nonatomic) UIButton *clickButton;//返回或者在砸一次按钮
@property (strong, nonatomic) UILabel *eggChanceLabel;//砸蛋机会label
@property (strong, nonatomic) UILabel *birdCoinLabel;//鸟币金额
@property (strong, nonatomic) UIWindow *goldenEggsWindow;
@property (strong, nonatomic) UIImageView *goldenEggsImageView;//金蛋
@property (strong, nonatomic) UIImageView *handimageView;//锤子
@property (strong, nonatomic) UIImageView *plateImageView;//托盘
@property (strong, nonatomic) UIImageView *moneyImageView;//砸金蛋之后的界面
@property (strong, nonatomic) UIImageView *cryImageView;//未中奖的界面
@property (strong, nonatomic) UIView *rareBookView;//砸金蛋秘籍
@property (strong, nonatomic) UIView *lineview;//下划线
@property (strong, nonatomic) UIButton *rarebookButton;//砸蛋秘籍按钮

@property (nonatomic,copy) void(^callBack)();//回调领投鸟理财首页按钮变为nable
@property (nonatomic,copy) void(^investCallBack)();//投资成功界面 跳往查看鸟币  ，需回调释放投资成功界面以及砸金蛋界面
@property (strong, nonatomic) UILabel *rareLabel;//砸蛋秘籍

@end
