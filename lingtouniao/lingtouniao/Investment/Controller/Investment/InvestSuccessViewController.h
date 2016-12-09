//
//  InvestSuccessViewController.h
//  lingtouniao
//
//  Created by LiuFeifei on 16/10/9.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "BaseViewController.h"

@interface InvestSuccessViewController : BaseViewController

@property (nonatomic,assign)double investment;
@property (nonatomic,assign) BOOL hasGoldenEgg;

- (void)setupUIWithSuccessTitle:(NSString *)successTitle buttonTitle:(NSString *)buttonTitle handle:(VoidBlock)handleBlock;

//zcf
- (void)setupUIWithSuccessTitle:(NSString *)successTitle buttonTitle:(NSString *)buttonTitle buttonInvestTitle:(NSString *)investTitle buttonShareTitle:(NSString *)shareTitle buttonInviteTitle:(NSString *)inviteTitle handle:(VoidBlock)handleBlock;

@end
