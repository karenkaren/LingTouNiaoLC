//
//  LTNCrowdFundingCell.h
//  lingtouniao
//
//  Created by 郑程锋 on 16/9/21.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTNBarProgressView.h"

@interface LTNCrowdFundingCell : UITableViewCell

@property (nonatomic) UILabel *titleLabel,*dateLab;
@property (nonatomic) NSMutableArray *dateLables;
@property (nonatomic) UIView *backView;
@property (nonatomic) UILabel *perLab,*amountLab,*rateLab;
@property (nonatomic) UILabel *perTitleLab,*amountTitleLab,*rateTitleLab;
@property (nonatomic) UIImageView *imgView;
@property (nonatomic) NSString *denominationStr;//返现收益
@property (nonatomic) id data;

//@property (nonatomic, strong) LTNBarProgressView *barProgress;

@property (nonatomic) UILabel *invLab,*rewardLab;//投资金额 可获奖励
@property (nonatomic) UILabel *invTitleLab,*rewardTitleLab;

@end
