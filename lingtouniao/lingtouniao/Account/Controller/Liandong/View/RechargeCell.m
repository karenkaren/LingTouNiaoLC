//
//  RechargeCell.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/5/3.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "RechargeCell.h"

@implementation RechargeCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
        
    self.bankImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 40, 40)];
    [self.contentView addSubview:self.bankImg];
    
    self.bankName = [Utility createLabel:[CustomerizedFont heiti:15] color:[UIColor colorWithHexString:@"#3a3a3a"]];
    self.bankName.frame = CGRectMake(self.bankImg.right + 10, 20, 120, 20);
    self.bankName.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.bankName];
    
    
    self.bankNum = [Utility createLabel:[CustomerizedFont heiti:15] color:[UIColor colorWithHexString:@"#3a3a3a"]];
    self.bankNum.frame = CGRectMake(kScreenWidth - 85, 12, 70, 20);
    self.bankNum.textAlignment = NSTextAlignmentRight;
    [self.bankNum adjustsFontSizeToFitWidth];
    [self.contentView addSubview:self.bankNum];
    
    self.bankInstr = [Utility createLabel:[CustomerizedFont heiti:12] color:[UIColor colorWithHexString:@"#8a8a8a"]];
    self.bankInstr.frame = CGRectMake(kScreenWidth - 235, 36, 220, 20);
    self.bankInstr.textAlignment = NSTextAlignmentRight;
   [self.bankInstr adjustsFontSizeToFitWidth];
    [self.contentView addSubview:self.bankInstr];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 59, kScreenWidth, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [self.contentView addSubview:line];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
