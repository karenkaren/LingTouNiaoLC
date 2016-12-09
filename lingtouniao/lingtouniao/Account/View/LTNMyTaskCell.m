//
//  LTNMyTaskCell.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/4/27.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNMyTaskCell.h"

@implementation LTNMyTaskCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
        [self configUI];
        
    }
    return self;
}

- (void)configUI{
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    lineView1.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [self.contentView addSubview:lineView1];
    
    self.imgV = [[UIImageView alloc]initWithFrame:CGRectMake(20, 25, 40, 40)];
    [self.contentView addSubview:self.imgV];
    
    
    self.titleLab = [Utility createLabel:[CustomerizedFont heiti:16] color:[UIColor colorWithHexString:@"#666666"]];
    self.titleLab.frame = CGRectMake(self.imgV.right + 15, 25, 65, 20);
    self.titleLab.numberOfLines = 0;
    [self.contentView addSubview:self.titleLab];
    
    self.detailLab = [Utility createLabel:[CustomerizedFont heiti:13] color:[UIColor colorWithHexString:@"#999999"]];
    self.detailLab.frame = CGRectMake(self.imgV.right + 15, self.titleLab.bottom + 5, kScreenWidth, 22);
    self.detailLab.numberOfLines = 0;
    [self.contentView addSubview:self.detailLab];
    

    self.taskProgressLab = [[UILabel alloc]init];
    self.taskProgressLab.textAlignment = NSTextAlignmentCenter;
    self.taskProgressLab.textColor = [UIColor whiteColor];
    self.taskProgressLab.backgroundColor = HexRGB(0xea5504);
    self.taskProgressLab.font = [CustomerizedFont heiti:11];
    self.taskProgressLab.layer.borderColor = HexRGB(0xea5504).CGColor;
    self.taskProgressLab.layer.borderWidth = 1;
    self.taskProgressLab.layer.cornerRadius = 8;
    self.taskProgressLab.layer.masksToBounds = YES;
    [self.contentView addSubview:self.taskProgressLab];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 89.5, kScreenWidth, 0.5)];
    lineView2.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [self.contentView addSubview:lineView2];
    
    
    
}

-(void)setMyTaskModel:(LTNMyTaskModel *)myTaskModel{
    _myTaskModel = myTaskModel;
    
    self.imgV.image = [UIImage imageNamed:myTaskModel.icon];
    self.titleLab.text = myTaskModel.title;
    self.detailLab.text = myTaskModel.detail;
   
    [self.titleLab sizeToFit];
    [self.detailLab sizeToFit];
    
    self.taskProgressLab.text = myTaskModel.taskPro;
    
    CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    CGSize labSize =[self.taskProgressLab.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [CustomerizedFont heiti:11]} context:nil].size;
    self.taskProgressLab.frame = CGRectMake(self.titleLab.right + 2, 28, labSize.width + 10, labSize.height);
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
