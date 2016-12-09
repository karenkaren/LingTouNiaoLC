//
//  LTNInvestViewCell.h
//  lingtouniao
//
//  Created by 郑程锋 on 16/11/1.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTNInvestViewCell : UITableViewCell

@property (nonatomic) UILabel *titleLabel,*dateLab;
@property (nonatomic) NSMutableArray *dateLables;
@property (nonatomic) id data;
@property (nonatomic) UIImageView *imgView;
@property (nonatomic) NSString *couponRevenue;//返现收益
@property (nonatomic) UIView *backView;
@property (nonatomic) UILabel *invLab,*reveLab,*rateLab;
@property (nonatomic) UILabel *invTitleLab,*reveTitleLab,*rateTitleLab;
@property (nonatomic) UIView *linedown;

@end
