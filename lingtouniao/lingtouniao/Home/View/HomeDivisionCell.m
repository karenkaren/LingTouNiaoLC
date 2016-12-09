//
//  HomeDivisionCell.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/5/23.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "HomeDivisionCell.h"

@interface HomeDivisionCell()

@property (nonatomic, strong) UIImageView * shakeImageView;

@end

@implementation HomeDivisionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    UIImageView * backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kDivisionCellHeight)];
    backgroundImageView.image = [UIImage imageNamed:@"xszq"];
    [self.contentView addSubview:backgroundImageView];
    
    // 抖动叹号
    UIImageView * shakeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dou"]];
    shakeImageView.right = kScreenWidth - 10;
    shakeImageView.top = 10;
    [self.contentView addSubview:shakeImageView];
    self.shakeImageView = shakeImageView;
}

- (void)startShake {
    double angle1 = -5.0 / 180.0 * M_PI;
    double angle2 = 5.0 / 180.0 * M_PI;
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    
    anim.values = @[@(angle1), @(angle2), @(angle1)];
    anim.duration = 0.3;
    // 动画的重复执行次数
    anim.repeatCount = MAXFLOAT;
    
    // 保持动画执行完毕后的状态
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    
    [self.shakeImageView.layer addAnimation:anim forKey:@"shake"];
}

// 停止抖动
- (void)stopShake {
    
    [self.shakeImageView.layer removeAnimationForKey:@"shake"];
}

@end
