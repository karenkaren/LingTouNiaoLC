//
//  LTNAccountDetailCollectionCell.h
//  lingtouniao
//
//  Created by 郑程锋 on 16/5/23.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTNAccountDetailCollectionCell : UICollectionViewCell
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *detailLabel;
@property (nonatomic) UIImageView *img;

@property (nonatomic) UIView *view1;

@property (nonatomic) UILabel *taskSchedul;//我的任务进度

@property (nonatomic) UIImageView *lineView;//合伙人左边的线
@end
