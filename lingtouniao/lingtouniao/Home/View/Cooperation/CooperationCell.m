//
//  CooperationCell.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/9/21.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "CooperationCell.h"
#import "UIImageView+WebCache.h"
#import "StringUtil.h"

#define kMargin DimensionBaseIphone6(15)
#define kRatioOfTopAndBottom (145.0 / 65.0)

@interface CooperationCell ()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * detailLabel;
@property (nonatomic, strong) UILabel * startInvestLabel;
@property (nonatomic, strong) UIImageView * contentImageView;
@property (nonatomic, strong) UILabel * joinLabel;

@end

@implementation CooperationCell

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
    UIView * backgroundView = [[UIView alloc] init];
    [superView addSubview:backgroundView];
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superView).insets(UIEdgeInsetsMake(0, kMargin, 0, kMargin));
    }];
    
    superView = backgroundView;
    UIView * topView = [[UIView alloc] init];
    [superView addSubview:topView];
    
    UIView * bottomView = [[UIView alloc] init];
    [superView addSubview:bottomView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@[superView, bottomView]);
        make.height.equalTo(@(kCooperationCellHeight)).offset(-bottomView.height);
        make.height.equalTo(bottomView).multipliedBy(kRatioOfTopAndBottom);
        make.left.top.equalTo(superView);
        make.bottom.equalTo(bottomView.mas_top);
    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@[superView, topView]);
        make.left.bottom.equalTo(superView);
        make.top.equalTo(topView.mas_bottom);
    }];
    
    superView = topView;
    UIImageView * contentImageView = [[UIImageView alloc] init];
    contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    contentImageView.clipsToBounds = YES;
    [superView addSubview:contentImageView];
    self.contentImageView = contentImageView;
    
    [contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superView);
    }];
    
    superView = bottomView;
    UILabel * titleLabel = [Utility createLabel:kFont(15) color:HexRGB(0x666666)];
//    titleLabel.adjustsFontSizeToFitWidth = YES;
    [superView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel * detailLabel = [Utility createLabel:kFont(12) color:HexRGB(0x999999)];
    //detailLabel.adjustsFontSizeToFitWidth = YES;
    [superView addSubview:detailLabel];
    self.detailLabel = detailLabel;
    
    UILabel * startInvestLabel = [Utility createLabel:kFont(16) color:HexRGB(0x666666)];
    startInvestLabel.textAlignment = NSTextAlignmentRight;
    startInvestLabel.adjustsFontSizeToFitWidth = YES;
    [superView addSubview:startInvestLabel];
    self.startInvestLabel = startInvestLabel;
    
    UILabel * joinLabel = [Utility createLabel:kFont(12) color:[UIColor colorWithHexString:@"#4A90E2"]];
    joinLabel.textAlignment = NSTextAlignmentRight;
    joinLabel.text = locationString(@"joined_RightNow");
    [superView addSubview:joinLabel];
    self.joinLabel = joinLabel;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView);
        make.width.lessThanOrEqualTo(superView).multipliedBy(2.0 / 3.0).offset(-5);
        make.height.lessThanOrEqualTo(superView).multipliedBy(0.5);
        make.bottom.equalTo(superView.mas_centerY);
    }];
    
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView);
        make.width.lessThanOrEqualTo(superView.mas_width).offset(-60);
        make.height.lessThanOrEqualTo(superView).multipliedBy(0.5).offset(-5);
        make.top.equalTo(superView.mas_centerY).offset(5);
    }];
    
    [startInvestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView);
        make.width.lessThanOrEqualTo(superView).multipliedBy(1.0 / 3.0).offset(-5);
        make.height.lessThanOrEqualTo(superView).multipliedBy(0.5);
        make.bottom.equalTo(titleLabel.mas_bottom);
    }];
    
    [joinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView);
        make.width.equalTo(@60);
        make.height.lessThanOrEqualTo(superView).multipliedBy(0.5).offset(-5);
        make.top.equalTo(superView.mas_centerY).offset(5);
    }];
}

- (void)setData:(CooperationModel *)data
{
    _data = data;
    if ([data isKindOfClass:[CooperationModel class]]) {
        CooperationModel * cooperationModel = (CooperationModel *)data;
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:cooperationModel.productTopPic] placeholderImage:[UIImage imageNamed:@"placeholder_banner"]];
        // 需要过滤html
        self.titleLabel.text = [StringUtil filterHTML:cooperationModel.productFirstTitle];
        self.detailLabel.text = [StringUtil filterHTML:cooperationModel.productSubTitle];
        self.startInvestLabel.text = [NSString stringWithFormat:locationString(@"product_start_amount2"), [StringUtil filterHTML:cooperationModel.singleLimitAmount]];
        [self.startInvestLabel sizeToFit];
        NSString * attributeString = [self.startInvestLabel.text substringToIndex:self.startInvestLabel.text.length - 3];
        [self.startInvestLabel addAttributes:@{NSForegroundColorAttributeName : HexRGB(0xea3e00)} forString:attributeString];
        return;
    }
    [self.contentImageView setImage:[UIImage imageNamed:@"placeholder_banner"]];
    self.titleLabel.text = locationString(@"cooperation_title");
    self.detailLabel.text = locationString(@"cooperation_subtitle");
    self.startInvestLabel.text = [NSString stringWithFormat:locationString(@"product_start_amount2"), @9.00];
    [self.startInvestLabel sizeToFit];
    NSString * attributeString = [self.startInvestLabel.text substringToIndex:self.startInvestLabel.text.length - 3];
    [self.startInvestLabel addAttributes:@{NSForegroundColorAttributeName : HexRGB(0xea3e00)} forString:attributeString];
}

- (void)setHideJoin:(BOOL)hideJoin
{
    _hideJoin = hideJoin;
    self.joinLabel.hidden = hideJoin;
}

@end
