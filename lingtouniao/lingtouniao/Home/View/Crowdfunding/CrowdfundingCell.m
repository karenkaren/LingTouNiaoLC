//
//  CrowdfundingCell.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/9/21.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "CrowdfundingCell.h"
#import "LTNBarProgressView.h"
#import "UIImageView+WebCache.h"
#import "StringUtil.h"

#define kSpacing DimensionBaseIphone6(15)
#define kRatioOfLeftAndRight (1.0 / 2.0)

@interface CrowdfundingCell ()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * incomeLabel;
@property (nonatomic, strong) UILabel * startInvestLabel;
@property (nonatomic, strong) LTNBarProgressView * crowdfundingProgress;
@property (nonatomic, strong) UIImageView * contentImageView;
@property (nonatomic, strong) UIView * topLineView;
@property (nonatomic, strong) UIImageView * lookForwardIV;

@end

@implementation CrowdfundingCell

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
    
    UIView * topLineView = [[UIView alloc] init];
    topLineView.backgroundColor = DEVIDE_LINE_COLOR;
    [superView addSubview:topLineView];
    self.topLineView = topLineView;
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superView).insets(UIEdgeInsetsMake(kSpacing, kSpacing, kSpacing, kSpacing));
    }];
    
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(superView).insets(UIEdgeInsetsMake(kSpacing, kSpacing, kSpacing, kSpacing));
        make.height.equalTo(@(1.0 / [UIScreen mainScreen].scale));
        make.top.equalTo(superView);
    }];
    
    superView = backgroundView;
    UIView * leftView = [[UIView alloc] init];
    [superView addSubview:leftView];
    
    UIView * rightView = [[UIView alloc] init];
    [superView addSubview:rightView];
    
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@[superView, rightView]);
        make.width.equalTo(@(superView.width - kSpacing)).offset(-rightView.width);
        make.width.equalTo(rightView).multipliedBy(kRatioOfLeftAndRight);
        make.left.top.equalTo(superView);
        make.right.equalTo(rightView.mas_left).offset(-kSpacing);
    }];
    
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@[superView, leftView]);
        make.left.equalTo(leftView.mas_right).offset(kSpacing);
        make.right.top.equalTo(superView);
    }];
    
    superView = leftView;
    UILabel * titleLabel = [Utility createLabel:kFont(16) color:HexRGB(0x666666)];
    titleLabel.numberOfLines = 2;
    //titleLabel.adjustsFontSizeToFitWidth = YES;
    [superView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel * incomeLabel = [Utility createLabel:kFont(14) color:HexRGB(0x999999)];
    incomeLabel.numberOfLines = 2;
   // incomeLabel.adjustsFontSizeToFitWidth = YES;
    [superView addSubview:incomeLabel];
    self.incomeLabel = incomeLabel;
    
    UILabel * startInvestLabel = [Utility createLabel:kFont(12) color:HexRGB(0x999999)];
    [superView addSubview:startInvestLabel];
    self.startInvestLabel = startInvestLabel;
    
    LTNBarProgressView * crowdfundingProgress = [[LTNBarProgressView alloc] init];
    [superView addSubview:crowdfundingProgress];
    self.crowdfundingProgress = crowdfundingProgress;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@[superView, incomeLabel, startInvestLabel, crowdfundingProgress]);
        make.height.lessThanOrEqualTo(superView).multipliedBy(1.0 / 2);
        make.left.top.equalTo(superView);
    }];
    
    [incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@[superView, titleLabel, startInvestLabel, crowdfundingProgress]);
        make.height.equalTo(@48);
        make.center.equalTo(superView);
    }];
    
    [startInvestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@[superView, titleLabel, incomeLabel, crowdfundingProgress]);
        make.height.equalTo(@12);
        make.left.equalTo(superView);
        make.bottom.equalTo(crowdfundingProgress.mas_top).offset(-5);
    }];
    
    [crowdfundingProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@[superView, titleLabel, incomeLabel, startInvestLabel]);
        make.height.equalTo(@8);
        make.left.equalTo(superView);
        make.bottom.equalTo(superView.mas_bottom).offset(-5);
    }];
    
    superView = rightView;
    UIImageView * contentImageView = [[UIImageView alloc] init];
    contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    contentImageView.clipsToBounds = YES;
    [superView addSubview:contentImageView];
    self.contentImageView = contentImageView;
    
    [contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superView);
    }];
    
    UIImageView * lookForwardIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_look_forward"]];
    [self.contentView addSubview:lookForwardIV];
    self.lookForwardIV = lookForwardIV;
    
    [lookForwardIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, kSpacing, 0, kSpacing));
    }];
}

- (void)setData:(id)data
{
    _data = data;
    if ([data isKindOfClass:[CrowdfundingModel class]]) {
        self.lookForwardIV.hidden = YES;
        CrowdfundingModel * crowdfundingModel = (CrowdfundingModel *)data;
        
        // 需要过滤html
        self.titleLabel.text = [StringUtil filterHTML:crowdfundingModel.productFirstTitle];

        if ([crowdfundingModel.productType isEqualToString:@"B"]) {
            self.incomeLabel.text = [NSString stringWithFormat:@"%@%@", [StringUtil filterHTML:crowdfundingModel.annualIncomeText], [StringUtil filterHTML:crowdfundingModel.productSubTitle]];
            [self.incomeLabel addAttributes:@{NSForegroundColorAttributeName : COLOR_MAIN} forString:[StringUtil filterHTML:crowdfundingModel.annualIncomeText]];
        } else {
            self.incomeLabel.text = [NSString stringWithFormat:@"%@", [StringUtil filterHTML:crowdfundingModel.productSubTitle]];
        }

        self.startInvestLabel.text = [NSString stringWithFormat:locationString(@"product_start_amount2"), @(crowdfundingModel.staInvestAmount)];
        if (crowdfundingModel.productTotalAmount) {
            self.crowdfundingProgress.progress = crowdfundingModel.productSoldedAmount / crowdfundingModel.productTotalAmount;
        } else {
            self.crowdfundingProgress.progress = 0;
        }
        
        [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:crowdfundingModel.productTopPic] placeholderImage:[UIImage imageNamed:@"placeholder_banner"]];
    } else {
        self.lookForwardIV.hidden = NO;
    }
}

- (void)setHideTopLine:(BOOL)hideTopLine
{
    _hideTopLine = hideTopLine;
    self.topLineView.hidden = hideTopLine;
}

@end
