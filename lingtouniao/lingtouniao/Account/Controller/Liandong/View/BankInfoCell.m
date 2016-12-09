//
//  BankInfoCell.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/5/5.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "BankInfoCell.h"
#import "BankBoundTextField.h"

@interface BankInfoCell ()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * valueLabel;

@end

@implementation BankInfoCell

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
    // title label
    self.titleLabel =[Utility createLabel:[CustomerizedFont heiti:16] color:HexRGB(0xcccccc)];
    self.titleLabel.frame = CGRectMake(22, 0, 100, kBankInfoCellHeight);
    [self.contentView addSubview:self.titleLabel];
    
    // value label
    self.valueLabel =[Utility createLabel:[CustomerizedFont heiti:16] color:HexRGB(0x3a3a3a)];
    self.valueLabel.frame = CGRectMake(self.titleLabel.width, 0, kScreenWidth - self.titleLabel.right - 24, kBankInfoCellHeight);
    [self.contentView addSubview:self.valueLabel];
}

- (void)setCellDic:(NSDictionary *)cellDic
{
    _cellDic = cellDic;
    self.titleLabel.text = cellDic[@"title"];
    self.valueLabel.text = cellDic[@"value"];
}

@end
