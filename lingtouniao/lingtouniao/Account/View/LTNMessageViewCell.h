//
//  LTNMessageViewCell.h
//  lingtouniao
//
//  Created by 郑程锋 on 16/3/14.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTNMessageModel.h"


@interface LTNMessageViewCell : UITableViewCell

@property (nonatomic) UILabel *titleLabel;//标题
@property (nonatomic) UILabel *dateLabel;//时间
@property (nonatomic) UILabel *contentLabel;//内容

//@property (nonatomic) UIView *lineView;//竖线
@property (nonatomic) UIView *backView; //背景框试图
@property (nonatomic) UIView *circleView;//红点

@property (nonatomic) UIView *uplineView;//上竖线
@property (nonatomic) UIView *downlineView;//下竖线

- (void)reloadModel:(LTNMessageModel *)messageModel;
+ (CGFloat)heightForModel:(LTNMessageModel *)messageModel;

- (void)reloadModel:(LTNMessageModel *)messageModel Index:(NSInteger)Index withCount:(NSInteger)count;

@end
