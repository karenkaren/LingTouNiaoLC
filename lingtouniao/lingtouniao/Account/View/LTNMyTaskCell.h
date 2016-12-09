//
//  LTNMyTaskCell.h
//  lingtouniao
//
//  Created by 郑程锋 on 16/4/27.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTNMyTaskModel.h"

@interface LTNMyTaskCell : UITableViewCell

@property (nonatomic) UIImageView *imgV;
@property (nonatomic) UILabel *titleLab;
@property (nonatomic) UILabel *detailLab;

@property (nonatomic) UILabel *taskProgressLab;//任务进度

@property (nonatomic) LTNMyTaskModel *myTaskModel;

@end
