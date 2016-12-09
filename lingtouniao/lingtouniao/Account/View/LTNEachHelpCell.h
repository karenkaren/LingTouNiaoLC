//
//  LTNEachHelpCell.h
//  lingtouniao
//
//  Created by 郑程锋 on 16/9/21.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTNEachHelpCell : UITableViewCell

@property (nonatomic) UILabel *titleLab;//标题
@property (nonatomic) UIImageView *imgView;

@property (nonatomic) UILabel *remainMoneyLab;//剩余金额
@property (nonatomic) UILabel *joinTimeLab;//参与时间

@property (nonatomic) UILabel *detailLab;//观察期

@property (nonatomic) id data;

@end
