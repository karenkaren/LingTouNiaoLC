//
//  LoanListCell.m
//  lingtouniao
//
//  Created by zhangtongke on 16/3/29.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LoanListCell.h"


@interface LoanListCell()
{
    UIImageView *_contentImageView;
    UIButton *_loanBtn;
}

@end

@implementation LoanListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
   
        _contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenWidth*125/360)];
        
        [self.contentView addSubview:_contentImageView];
        
        _loanBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, DimensionBaseIphone6(88), DimensionBaseIphone6(29.0))];
        _loanBtn.right=_contentImageView.width-DimensionBaseIphone6(25);
        _loanBtn.bottom=_contentImageView.height-DimensionBaseIphone6(10);
        
        _loanBtn.titleLabel.font = kFont(15);
        [_loanBtn setTitle:locationString(@"loan_btn") forState:UIControlStateNormal];
        
        [_loanBtn  addTarget:self action:@selector(loanAction) forControlEvents:UIControlEventTouchUpInside];
        _loanBtn.layer.cornerRadius = 3;
        _loanBtn.layer.masksToBounds = YES;
        _loanBtn.backgroundColor = HexRGB(0xea5504);
        [self.contentView addSubview:_loanBtn];
        
       
  
        
    }
    return self;
}


-(void)setLoanDic:(NSDictionary *)loanDic{
    _loanDic=loanDic;
    _contentImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@loan",loanDic[@"type"]]];
    
}

-(void)loanAction{
    if(_loanBlock)
        _loanBlock(_loanDic);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
