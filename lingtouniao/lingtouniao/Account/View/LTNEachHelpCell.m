//
//  LTNEachHelpCell.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/9/21.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNEachHelpCell.h"

@interface LTNEachHelpCell ()


@end

@implementation LTNEachHelpCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = BACKGROUND_COLOR;
        
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UIView *backView = [[UIView alloc]init];//WithFrame:CGRectMake(12, 0, kScreenWidth - 24, 80)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.borderColor = [UIColor colorWithHexString:@"#e2e2e2"].CGColor;
    backView.layer.borderWidth = 0.5;
    [self.contentView addSubview:backView];
    
    self.titleLab = [Utility createLabel:[CustomerizedFont heiti:15] color:[UIColor colorWithHexString:@"#666666"]];
    [backView addSubview:self.titleLab];
    
    self.imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_arrow1"]];
    [backView addSubview:self.imgView];
    
    self.detailLab = [Utility createLabel:[CustomerizedFont heiti:12] color:[UIColor colorWithHexString:@"#ff6600"]];
    [backView addSubview:self.detailLab];
    
    UIView *lineup = [[UIView alloc]init];
    lineup.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [backView addSubview:lineup];
    
    CGFloat width = (kScreenWidth - 30 -24)/2;
    self.joinTimeLab = [Utility createLabel:[CustomerizedFont heiti:15] color:[UIColor colorWithHexString:@"#666666"]];
    self.joinTimeLab.textAlignment = NSTextAlignmentLeft;
    self.joinTimeLab.adjustsFontSizeToFitWidth = YES;
    [backView addSubview:self.joinTimeLab];

    self.remainMoneyLab = [Utility createLabel:[CustomerizedFont heiti:15] color:[UIColor colorWithHexString:@"#666666"]];
    self.remainMoneyLab.textAlignment = NSTextAlignmentRight;
    [backView addSubview:self.remainMoneyLab];
    

    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(@0);
        make.width.equalTo(@(kScreenWidth - 24));
        make.height.equalTo(@80);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@0);
        make.width.equalTo(@(kScreenWidth - 24 - kGeneralHeight*2));
        make.height.equalTo(@40);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kScreenWidth -47));
        make.top.equalTo(@12.5);
        make.width.equalTo(@8);
        make.height.equalTo(@15);
    }];
    
    [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.imgView.mas_left).offset(-5);
        make.height.equalTo(@15);
        make.top.equalTo(@12.5);
    }];
    
    [lineup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@39.5);
        make.width.equalTo(@(kScreenWidth -54));
        make.height.equalTo(@0.5);
    }];
    
    [self.joinTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(lineup.mas_bottom);
        make.width.equalTo(@(width));
        make.height.equalTo(@40);
    }];
    
    [self.remainMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.joinTimeLab.mas_right);
        make.top.equalTo(lineup.mas_bottom);
        make.width.equalTo(@(width));
        make.height.equalTo(@40);
    }];


}

-(void)setData:(id)data{
    _data = data;
    
    self.titleLab.text = [NSString stringWithFormat:@"%@",self.data[@"productName"]];//标题
    
    self.joinTimeLab.text = [NSString stringWithFormat:locationString(@"joined_Time"), self.data[@"orderDate"] ?: @""];//参与时间
    
    self.remainMoneyLab.text = [NSString stringWithFormat:locationString(@"remain_Money"), self.data[@"orderAmount"]];//剩余金额
    
    self.detailLab.text =[NSString stringWithFormat:@"%@",self.data[@"status"]];
    
    
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
