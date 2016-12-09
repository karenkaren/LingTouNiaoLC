//
//  HomeSectionHeaderView.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/5/20.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "HomeSectionHeaderView.h"
#import "LTNLoginController.h"
#import "DetailButton.h"

//#define kSeparatorHeight DimensionBaseIphone6(8)
#define kMargin DimensionBaseIphone6(15)

@interface HomeSectionHeaderView ()
{
    BOOL _isShake;
    UIButton * _PoundsEggTitleButton;
}

@end

@implementation HomeSectionHeaderView

+ (HomeSectionHeaderView *)getHomeSectionHeaderViewWithTitle:(NSString *)title titleDetail:(NSString *)titleDetail
{
    HomeSectionHeaderView * homeSectionHeaderView = [[HomeSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSectionHeight) title:title titleDetail:titleDetail];
    homeSectionHeaderView.backgroundColor = [UIColor whiteColor];
    return homeSectionHeaderView;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title  titleDetail:(NSString *)titleDetail
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel * titleLabel = [Utility createLabel:kFontBold(20) color:HexRGB(0x666666)];
        titleLabel.text = title;
        [titleLabel sizeToFit];
        [self addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(kMargin);
            make.centerY.equalTo(self);
        }];

        if (titleDetail && ![titleDetail isEqualToString:@""]) {
            kWeakSelf
            DetailButton * detailButton = [DetailButton creatDetailButtonWithTitle:titleDetail rightImage:[UIImage imageNamed:@"icon_arrow1"] handle:^(id sender) {
                kStrongSelf
                if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(showMore:)]) {
                    [strongSelf.delegate showMore:self];
                }
            }];
            [self addSubview:detailButton];
            [detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-kMargin);
                make.centerY.equalTo(titleLabel);
            }];
        }
        
//        UIButton * button = [Utility createButtonWithTitle:locationString(@"tab_home_bird_coin") color:COLOR_MAIN font:[CustomerizedFont heiti:10] block:^(UIButton *btn) {
//            [self clickPoundsEgg:btn];
//        }];
//        [button sizeToFit];
//        button.width += 20;
//        button.height -= 5;
//        button.layer.cornerRadius = button.height * 0.5;
//        button.layer.masksToBounds = YES;
//        UIColor * borderColor = COLOR_MAIN;
//        button.layer.borderColor = borderColor.CGColor;
//        button.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
//        button.right = titleView.width - 10;
//        button.centerY = titleView.height * 0.5;
//        [titleView addSubview:button];
//        _PoundsEggTitleButton = button;
//        
//        [self loadAvatarInCustomViewInitInView:self];
    }
    return self;
}

#pragma mark 其他
//- (void)clickPoundsEgg:(UIButton *)btn
//{
////    _avatar.enabled = NO;
////    [self performSelector:@selector(enabledAvatar) withObject:nil afterDelay:3.0];
//    if ([self.delegate respondsToSelector:@selector(startShowGoldenEggs)]) {
//        [self.delegate startShowGoldenEggs];
//    }
//    
////    [self stop:_avatar];
//}
//
//-(void)enabledAvatar{
//    _avatar.enabled = YES;
//}

#pragma mark setter
//- (void)setShowAction:(BOOL)showAction
//{
//    _showAction = showAction;
//    _PoundsEggTitleButton.hidden = !showAction;
//    _avatar.hidden = !showAction;
//}

#pragma mark 砸金蛋相关
//- (void)loadAvatarInCustomViewInitInView:(UIView *)view {
//
//    _avatar = [[GoldenEggButton alloc] initInView:view WithFrame:CGRectMake(_PoundsEggTitleButton.left - 15 , 15 , 27, 27)];
////    [_avatar setBackgroundImage:[UIImage imageNamed:@"btn_homepage"] forState:UIControlStateNormal];
//    if (_isShake) {
//        for (UIView *view in [_avatar subviews]) {
//            if ([view isKindOfClass:[UIButton class]]) {
//                [view removeFromSuperview];
//            }
//        }
////        [self stop:_avatar];
//        _isShake = !_isShake;
//    }
//    else {
//
////            [self start:_avatar];
//            _isShake = !_isShake;
//
//    }
//    __weak typeof(self) _weakSelf = self;
//    _avatar.tapBlock = ^(GoldenEggButton *_avatarButton) {
////        if(![[CurrentUser mine] sessionKey].length) {
////            [LTNCore presentViewController:[LTNLoginController class] withFinishBlock:^(void){
////            }];
////        } else {
////            /**
////             *显示砸金蛋界面
////             */
////            if ([_weakSelf.delegate respondsToSelector:@selector(startShowGoldenEggs)]) {
////                [_weakSelf.delegate startShowGoldenEggs];
////            }
////            _avatarButton.enabled = NO;
////            [_weakSelf stop:_avatarButton];
////        }
//        [_weakSelf clickPoundsEgg:_avatarButton];
//    };
//}

@end
