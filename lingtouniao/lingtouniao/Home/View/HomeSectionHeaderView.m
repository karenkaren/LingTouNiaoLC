//
//  HomeSectionHeaderView.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/5/20.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "HomeSectionHeaderView.h"
#import "LTNLoginController.h"

#define kSeparatorHeight DimensionBaseIphone6(8)

@interface HomeSectionHeaderView ()
{
    BOOL _isShake;
    UIButton * _PoundsEggTitleButton;
}

@end

@implementation HomeSectionHeaderView

+ (HomeSectionHeaderView *)getHomeSectionHeaderViewWithTitle:(NSString *)title
{
    HomeSectionHeaderView * homeSectionHeaderView = [[HomeSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSectionHeight) title:title];
    
    return homeSectionHeaderView;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat height = kSectionHeight - kSeparatorHeight;
        UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(0, kSeparatorHeight, kScreenWidth, height)];
        titleView.backgroundColor = [UIColor whiteColor];
        [self addSubview:titleView];
        
        UIView * topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1.0 / [UIScreen mainScreen].scale)];
        topLine.backgroundColor = DEVIDE_LINE_COLOR;
        [titleView addSubview:topLine];
        
        UIView * verLineView = [[UIView alloc] initWithFrame:CGRectMake(10, height * 0.25, 3, height * 0.5)];
        verLineView.backgroundColor = COLOR_MAIN;
        verLineView.layer.cornerRadius = verLineView.width * 0.5;
        verLineView.layer.masksToBounds = YES;
        [titleView addSubview:verLineView];
        
        UILabel * titleLabel = [Utility createLabel:[CustomerizedFont heiti:16] color:HexRGB(0x666666)];
        titleLabel.text = title;
        [titleLabel sizeToFit];
        titleLabel.left = verLineView.right + 10;
        titleLabel.centerY = verLineView.centerY;
        [titleView addSubview:titleLabel];
        
        UIButton * button = [Utility createButtonWithTitle:locationString(@"tab_home_bird_coin") color:COLOR_MAIN font:[CustomerizedFont heiti:10] block:^(UIButton *btn) {
            [self clickPoundsEgg:btn];
        }];
        [button sizeToFit];
        button.width += 20;
        button.height -= 5;
        button.layer.cornerRadius = button.height * 0.5;
        button.layer.masksToBounds = YES;
        UIColor * borderColor = COLOR_MAIN;
        button.layer.borderColor = borderColor.CGColor;
        button.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        button.right = titleView.width - 10;
        button.centerY = titleView.height * 0.5;
        [titleView addSubview:button];
        _PoundsEggTitleButton = button;
        
        [self loadAvatarInCustomViewInitInView:self];
    }
    return self;
}

#pragma mark 其他
- (void)clickPoundsEgg:(UIButton *)btn
{
//    _avatar.enabled = NO;
//    [self performSelector:@selector(enabledAvatar) withObject:nil afterDelay:3.0];
    if ([self.delegate respondsToSelector:@selector(startShowGoldenEggs)]) {
        [self.delegate startShowGoldenEggs];
    }
    
    [self stop:_avatar];
}

-(void)enabledAvatar{
    _avatar.enabled = YES;
}

#pragma mark setter
- (void)setShowAction:(BOOL)showAction
{
    _showAction = showAction;
    _PoundsEggTitleButton.hidden = !showAction;
    _avatar.hidden = !showAction;
}

#pragma mark 砸金蛋相关
- (void)loadAvatarInCustomViewInitInView:(UIView *)view {

    _avatar = [[GoldenEggButton alloc] initInView:view WithFrame:CGRectMake(_PoundsEggTitleButton.left - 15 , 15 , 27, 27)];
    [_avatar setBackgroundImage:[UIImage imageNamed:@"btn_homepage"] forState:UIControlStateNormal];
    if (_isShake) {
        for (UIView *view in [_avatar subviews]) {
            if ([view isKindOfClass:[UIButton class]]) {
                [view removeFromSuperview];
            }
        }
        [self stop:_avatar];
        _isShake = !_isShake;
    }
    else {

            [self start:_avatar];
            _isShake = !_isShake;

    }
    __weak typeof(self) _weakSelf = self;
    _avatar.tapBlock = ^(GoldenEggButton *_avatarButton) {
//        if(![[CurrentUser mine] sessionKey].length) {
//            [LTNCore presentViewController:[LTNLoginController class] withFinishBlock:^(void){
//            }];
//        } else {
//            /**
//             *显示砸金蛋界面
//             */
//            if ([_weakSelf.delegate respondsToSelector:@selector(startShowGoldenEggs)]) {
//                [_weakSelf.delegate startShowGoldenEggs];
//            }
//            _avatarButton.enabled = NO;
//            [_weakSelf stop:_avatarButton];
//        }
        [_weakSelf clickPoundsEgg:_avatarButton];
    };
}
/**
 *
 *  @param btn 砸金蛋按钮抖动
 */
- (void)start:(UIButton *)btn {
    double angle1 = -5.0 / 180.0 * M_PI;
    double angle2 = 5.0 / 180.0 * M_PI;
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";

    anim.values = @[@(angle1), @(angle2), @(angle1)];
    anim.duration = 0.25;
    // 动画的重复执行次数
    anim.repeatCount = MAXFLOAT;

    // 保持动画执行完毕后的状态
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;

    [btn.layer addAnimation:anim forKey:@"shake"];
}

// 停止抖动
- (void)stop:(UIButton *)btn {
    [btn.layer removeAnimationForKey:@"shake"];
}

@end
