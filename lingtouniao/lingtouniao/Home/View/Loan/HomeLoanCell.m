//
//  HomeLoanCell.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/9/22.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "HomeLoanCell.h"

#define kMargin DimensionBaseIphone6(25.0 / 2)

@implementation HomeLoanCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    UIImage * loanImage = [UIImage imageNamed:@"jiekuan"];
    UIImageView * loanImageView = [[UIImageView alloc] initWithImage:loanImage];
    [self.contentView addSubview:loanImageView];
    
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = HexRGB(0xe2e2e2);
    [self.contentView addSubview:lineView];
    
    UIView * superView = self.contentView;
    UIEdgeInsets insets = UIEdgeInsetsMake(kMargin * 0.5, kMargin, kMargin, kMargin);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(superView).insets(insets);
        make.top.equalTo(superView);
        make.height.equalTo(@(1.0 / [UIScreen mainScreen].scale));
    }];
    [loanImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(superView).insets(insets);
        make.width.equalTo(loanImageView.mas_height).multipliedBy(loanImage.size.width / loanImage.size.height);
    }];
}

@end
