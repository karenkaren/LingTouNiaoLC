//
//  LTNSuccessView.h
//  lingtouniao
//
//  Created by LiuFeifei on 16/2/22.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ButtonActionBlock)(UIButton *button);
typedef void (^ButtonInvestBlock)(UIButton *button);
typedef void (^ButtonShareBlock)(UIButton *button);
typedef void (^ButtonInviteBlock)(UIButton *button);

@interface LTNSuccessView : UIView

@property (nonatomic, copy) NSString * prompt;
@property (nonatomic, strong) UIColor * buttonBackgroundColor;
@property (nonatomic, strong) UIColor * buttonTitleColor;

- (instancetype)initWithSuccessTitle:(NSString *)successTitle buttonTitle:(NSString *)buttonTitle actionBlock:(ButtonActionBlock)actionBlock;

- (instancetype)initWithSuccessTitle:(NSString *)successTitle buttonTitle:(NSString *)buttonTitle buttonInvestTitle:(NSString *)investTitle buttonShareTitle:(NSString *)shareTitle buttonInviteTitle:(NSString *)inviteTitle actionBlock:(ButtonActionBlock)actionBlock investBlock:(ButtonInvestBlock)investBlock shareBlock:(ButtonShareBlock)shareBlock inviteBlock:(ButtonInviteBlock)inviteBlock;

@end
