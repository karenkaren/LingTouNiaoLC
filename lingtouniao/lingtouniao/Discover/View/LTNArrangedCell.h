//
//  LTNArrangedCell.h
//  lingtouniao
//
//  Created by 郑程锋 on 16/9/21.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTNBarProgressView.h"
#import "LTNArrangeModel.h"


@interface LTNArrangedCell : UITableViewCell

@property (nonatomic) UILabel *titleLab;//标题
@property (nonatomic) UILabel *incomeLab;//收益
@property (nonatomic) UILabel *startSalaryLab;//起薪
@property (nonatomic) UIImageView *iconView;//图片
@property (nonatomic, strong) LTNBarProgressView *barProgress; //进度

@property (nonatomic) LTNArrangeModel *arrangeModel;

@end
