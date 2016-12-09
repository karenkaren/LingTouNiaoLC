//
//  AddressViewCell.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/11/3.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "AddressViewCell.h"

@implementation AddressViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUpUI];
        
    }
    return self;
}

-(void)setUpUI{
    
    UIView *upLine = [[UIView alloc]init];
    upLine.backgroundColor =[UIColor colorWithHexString:@"#e2e2e2"];
    [self.contentView addSubview:upLine];
    
    //姓名
    self.nameLabel = [Utility createLabel:kFont(16) color:[UIColor colorWithHexString:@"#666666"]];
    [self.contentView addSubview:self.nameLabel];
    
    //电话
    self.phoneLabel = [Utility createLabel:kFont(16) color:[UIColor colorWithHexString:@"#666666"]];
    self.phoneLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.phoneLabel];
    
    //地址
    self.addressLabel = [Utility createLabel:kFont(16) color:[UIColor colorWithHexString:@"#666666"]];
    self.addressLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.addressLabel];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [self.contentView addSubview:line];
    
    //编辑
    self.editButton = [[UIButton alloc]init];
    [self.editButton setTitle:locationString(@"edit") forState:UIControlStateNormal];
    self.editButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.editButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    self.editButton.titleLabel.font = [CustomerizedFont heiti:14];
    [self.editButton addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
    self.editButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;;
    self.editIconView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.editIconView.image = [UIImage imageNamed:@"editor_icon"];
    [self.editButton addSubview:self.editIconView];
    [self.contentView addSubview:self.editButton];
    
    //删除
    self.deleteButton = [[UIButton alloc]init];
    [self.deleteButton setTitle:locationString(@"delete") forState:UIControlStateNormal];
    [self.deleteButton setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    self.deleteButton.titleLabel.font = [CustomerizedFont heiti:14];
    [self.deleteButton addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    self.deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;;
    self.deleteIconView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.deleteIconView.image = [UIImage imageNamed:@"delete_box"];
    [self.deleteButton addSubview:self.deleteIconView];
    [self.contentView addSubview:self.deleteButton];
    
    UIView *downLine = [[UIView alloc]init];
    downLine.backgroundColor =[UIColor colorWithHexString:@"#e2e2e2"];
    [self.contentView addSubview:downLine];
    
    
    
    [upLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@0.5);
    }];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@10);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kScreenWidth - 135));
        make.top.equalTo(@10);
        make.width.equalTo(@120);
        make.height.equalTo(@20);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15);
        make.width.equalTo(@(kScreenWidth - 30));
        make.height.equalTo(@20);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(self.addressLabel.mas_bottom).offset(15);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@0.5);
    }];
    
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kScreenWidth - 125));
        make.top.equalTo(line.mas_bottom).offset(15);
        make.width.equalTo(@(50));
        make.height.equalTo(@20);
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kScreenWidth - 65));
        make.top.equalTo(line.mas_bottom).offset(15);
        make.width.equalTo(@50);
        make.height.equalTo(@20);
    }];
    
    [downLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@129.5);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@0.5);
    }];
    

}

-(void)editClick:(UIButton *)btn{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(AddressInfoCell:editButtonClickedButton:)]) {
        [self.delegate AddressInfoCell:self editButtonClickedButton:btn];
    }
}

-(void)deleteClick:(UIButton *)btn{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(AddressInfoCell:deleteButtonClickedButton:)]) {
        [self.delegate AddressInfoCell:self deleteButtonClickedButton:btn];
    }
}


-(void)setModel:(LTNAddressModel *)model{
    
    _model = model;
    
    _nameLabel.text = _model.consigneeName;
    
    _phoneLabel.text = _model.mobileNo;
    
    _addressLabel.text = [NSString stringWithFormat:@"%@%@",_model.location,_model.detailAddress];
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
