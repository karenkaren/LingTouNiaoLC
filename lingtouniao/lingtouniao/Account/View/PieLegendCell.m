//
//  PieLegendCell.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/3/17.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "PieLegendCell.h"
#import "Masonry.h"

@interface PieLegendCell ()
{
    UIView * _circleView;
    UILabel * _percentLabel;
    UILabel * _titleLabel;
    UILabel * _amountLabel;
    UIButton *  _helpButton;
}

@end

@implementation PieLegendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    UIView * superView = self.contentView;
    // color percent title amount help
    
    // 圆形指示
    CGFloat circleDiam = 10;
    _circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, circleDiam, circleDiam)];
    _circleView.hidden = YES;
    _circleView.layer.cornerRadius = circleDiam * 0.5;
    _circleView.layer.masksToBounds = YES;
    [superView addSubview:_circleView];
    
    // 百分比标签
    _percentLabel = [[UILabel alloc] init];
    _percentLabel.textAlignment = NSTextAlignmentCenter;
    _percentLabel.layer.cornerRadius = 5;
    _percentLabel.layer.masksToBounds = YES;
    _percentLabel.textColor = [UIColor whiteColor];
    _percentLabel.font = kFont(12);
    [superView addSubview:_percentLabel];
    
    // 名称标签
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = HexRGB(0x3a3a3a);
    _titleLabel.font = kFont(16);
    [superView addSubview:_titleLabel];
    
    // 金额标签
    _amountLabel = [[UILabel alloc] init];
    _amountLabel.textColor = HexRGB(0x3a3a3a);
    _amountLabel.font = kFont(16);
    _amountLabel.textAlignment = NSTextAlignmentRight;
    [superView addSubview:_amountLabel];
    
    // 帮助按钮
    UIImage * helpButtonImage = [UIImage imageNamed:@"icon_help"];
    CGFloat helpButtonWidth = helpButtonImage.size.width;
    _helpButton = [[UIButton alloc] init];
    [_helpButton setEnlargeEdge:20];
    [_helpButton setImage:helpButtonImage forState:UIControlStateNormal];
    [_helpButton addTarget:self action:@selector(help:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:_helpButton];
    
    // 设置约束
    [_circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(circleDiam));
        make.left.equalTo(superView.mas_left).offset(20);
        make.centerY.equalTo(superView.mas_centerY);
    }];
    
    [_percentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_circleView.mas_right).offset(10);
        make.centerY.equalTo(superView.mas_centerY);
        make.width.equalTo(@50);
        make.height.equalTo(@25);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_percentLabel.mas_right).offset(20);
        make.centerY.equalTo(superView.mas_centerY);
    }];
    
    [_helpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.mas_right).offset(-10);
        make.centerY.equalTo(superView.mas_centerY);
        make.width.height.equalTo(@(helpButtonWidth));
    }];
    
    [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_helpButton.mas_left).offset(-10);
        make.centerY.equalTo(superView.mas_centerY);
    }];
}

- (void)help:(UIButton *)button
{
    DLog(@"说明");
}

- (void)setData:(id)data
{
    _data = data;
    // indicateColor
    // percent
    // title
    // amount
    // hiddenHelp
    UIColor * indicateColor = data[@"indicateColor"];
    NSString * percent = data[@"percent"];
    NSString * title = data[@"title"];
    NSString * amount = data[@"amount"];
    BOOL hiddenHelp = [data[@"hiddenHelp"] boolValue];
    
    _circleView.backgroundColor = indicateColor;
    _percentLabel.text = percent;
    _percentLabel.backgroundColor = indicateColor;
    _titleLabel.text = title;
    [_titleLabel sizeToFit];
    _amountLabel.text = amount;
    [_amountLabel sizeToFit];
    _helpButton.hidden = hiddenHelp;
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    UIColor * indicateColor = isSelected ? self.data[@"indicateColor"] : HexRGB(0x3a3a3a);
    _circleView.hidden = !isSelected;
    _titleLabel.textColor = indicateColor;
    _amountLabel.textColor = indicateColor;
}

@end
