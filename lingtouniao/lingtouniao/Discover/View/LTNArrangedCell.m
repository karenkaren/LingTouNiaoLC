//
//  LTNArrangedCell.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/9/21.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNArrangedCell.h"
#import "UIImageView+WebCache.h"

@implementation LTNArrangedCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self configUi];
    }
    return self;
}

-(void)configUi{
    
    self.titleLab = [Utility createLabel:[CustomerizedFont heiti:14] color:[UIColor colorWithHexString:@"#333333"]];
    self.titleLab.frame = CGRectMake(10, 5, 120, 30);
    self.titleLab.numberOfLines = 2;
    [self.contentView addSubview:self.titleLab];
    
    self.incomeLab = [Utility createLabel:[CustomerizedFont heiti:12] color:[UIColor colorWithHexString:@"#999999"]];
    self.incomeLab.frame = CGRectMake(10, self.titleLab.bottom +5, 100, 40);
    [self.contentView addSubview:self.incomeLab];
    
    self.startSalaryLab = [Utility createLabel:[CustomerizedFont heiti:10] color:[UIColor colorWithHexString:@"#999999"]];
    self.startSalaryLab.frame = CGRectMake(10, self.incomeLab.bottom, 100, 20);
    [self.contentView addSubview:self.startSalaryLab];
    
    self.barProgress = [[LTNBarProgressView alloc]initWithFrame:CGRectMake(15, self.startSalaryLab.bottom, 110, 4)];
    self.barProgress.lineColorString = @"#EC5400";
    [self.contentView addSubview:self.barProgress];
    
    self.iconView = [[UIImageView alloc]initWithFrame:CGRectMake(self.titleLab.right, 5, kScreenWidth - self.titleLab.right - 5, 100)];
    [self.contentView addSubview:self.iconView];
    
}

-(void)setArrangeModel:(LTNArrangeModel *)arrangeModel{
    _arrangeModel = arrangeModel;
    
    self.titleLab.text = self.arrangeModel.taskDesc;
    self.incomeLab.text = @"￥100 收益";
    self.startSalaryLab.text = @"100起";
    
    double progress = 0;
    if ([self.arrangeModel.arrangeIncome doubleValue] > 0) {
        progress = 0.3;
    }
    self.barProgress.progress = progress;
    
    NSURL *imgUrl = [NSURL URLWithString:arrangeModel.arrangeIcon];
    [self.iconView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"header_homepage"] options:SDWebImageRetryFailed];
    
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
