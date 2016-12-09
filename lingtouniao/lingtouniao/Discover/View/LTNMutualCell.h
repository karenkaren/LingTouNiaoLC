//
//  LTNMutualCell.h
//  lingtouniao
//
//  Created by 郑程锋 on 16/9/21.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTNMutualModel.h"

@interface LTNMutualCell : UITableViewCell

@property (nonatomic) UIImageView *iconView;//图片
@property (nonatomic) UILabel *titleLab;//标题
@property (nonatomic) UILabel *startMoneyLab;//起薪
@property (nonatomic) UILabel *descLab;//小标题1
@property (nonatomic) UILabel *detaLab;//小标题2
@property (nonatomic) UILabel *joinLab;//加入
@property (nonatomic) UIView *line;

@property (nonatomic) LTNMutualModel *mutualModel;

@end
