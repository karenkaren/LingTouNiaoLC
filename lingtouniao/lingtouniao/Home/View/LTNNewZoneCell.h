//
//  LTNNewZoneCell.h
//  lingtouniao
//
//  Created by 郑程锋 on 16/4/26.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTNNewZoneModel.h"
#import "LTNBarProgressView.h"

@interface LTNNewZoneCell : UITableViewCell

@property (nonatomic) UIImageView *lineImageV;//shuxiantupian
@property (nonatomic) UIImageView *imageV;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *detailLabel;
@property (nonatomic) UILabel *rewardLabel;
@property (nonatomic, strong) UIView * progressView;
@property (nonatomic, strong) LTNBarProgressView * barProgress;
@property (nonatomic, strong) UILabel * progressLabel;

@property (nonatomic) UILabel *actionLab;

@property (nonatomic) LTNNewZoneModel *ZoneModel;

@property (nonatomic) UIView *lineView2;

-(void)setUpLine:(NSInteger)index withCount:(NSInteger)count;

+ (CGFloat)heightForModel:(LTNNewZoneModel *)zoneModel;

@end
