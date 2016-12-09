//
//  CooperationHeaderView.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/9/24.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "CooperationHeaderView.h"
#import "StringUtil.h"

#define kMargin DimensionBaseIphone6(15)

@interface CooperationHeaderView ()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * detailLabel;

@end

@implementation CooperationHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kCooperationHeaderHeight)];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    UILabel * titleLabel = [Utility createLabel:kFontBold(24) color:HexRGB(0x666666)];
    titleLabel.text = locationString(@"cooperation_title");
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel * detailLabel = [Utility createLabel:kFont(15) color:HexRGB(0x666666)];
    detailLabel.text = locationString(@"cooperation_subtitle");
    [self addSubview:detailLabel];
    self.detailLabel = detailLabel;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).offset(-2 * kMargin);
        make.height.equalTo(@24);
        make.bottom.equalTo(self.mas_centerY).offset(5);
        make.left.equalTo(@(kMargin));
    }];
    
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(titleLabel);
        make.height.equalTo(@15);
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
        make.left.equalTo(@(kMargin));
    }];
}

- (void)setData:(id)data
{
    if (isDictionary(data)) {
        NSDictionary * dic = (NSDictionary *)data;
        self.titleLabel.text = [StringUtil filterHTML:dic[@"productFirstTitle"]];
        self.detailLabel.text = [StringUtil filterHTML:dic[@"productSubTitle"]];
    }
}

@end
