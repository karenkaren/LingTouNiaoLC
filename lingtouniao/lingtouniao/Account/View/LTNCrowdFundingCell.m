//
//  LTNCrowdFundingCell.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/9/21.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNCrowdFundingCell.h"

@implementation LTNCrowdFundingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = BACKGROUND_COLOR;
        
        [self configUI];
    }
    return self;
}

- (void)configUI {
    
    UIView *backView = [[UIView alloc]init];
    self.backView = backView;
    self.backView.layer.borderColor = [UIColor colorWithHexString:@"#e2e2e2"].CGColor;
    self.backView.layer.borderWidth = 0.5;
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    
    self.titleLabel = [Utility createLabel:[CustomerizedFont heiti:15] color:[UIColor colorWithHexString:@"#666666"]];
    [backView addSubview:self.titleLabel];
    
    self.imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_arrow1"]];
    [backView addSubview:self.imgView];
    
    UIView *lineup = [[UIView alloc]init];//WithFrame:CGRectMake(15, 39.5, kScreenWidth-30-24, 0.5)];
    lineup.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [backView addSubview:lineup];
    
    //年华收益率、到期收益、投资金额
    //数据
    CGFloat hWidth = (kScreenWidth-24-24) / 3;
    
    self.perLab = [Utility createLabel:[CustomerizedFont heiti:22] color:[UIColor colorWithHexString:@"#333333"]];
    self.amountLab = [Utility createLabel:[CustomerizedFont heiti:22] color:[UIColor colorWithHexString:@"#333333"]];
    self.rateLab = [Utility createLabel:[CustomerizedFont heiti:22] color:[UIColor colorWithHexString:@"#333333"]];
    
    NSArray *dataLab = @[self.perLab,self.amountLab,self.rateLab];
    for (int i =0; i<dataLab.count; i++) {
        UILabel *label = dataLab[i];
        label.textAlignment = NSTextAlignmentCenter;
        if (i == 1) {
            label.textColor = [UIColor colorWithHexString:@"#ea5504"];
        }
        label.adjustsFontSizeToFitWidth = YES;
        [self.backView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(12+hWidth*i));
            make.top.equalTo(lineup.mas_bottom).offset(10);
            make.width.equalTo(@(hWidth));
            make.height.equalTo(@31);
        }];

    }
    
    //文字
    
    self.rateTitleLab = [Utility createLabel:[CustomerizedFont heiti:11] color:[UIColor colorWithHexString:@"#666666"]];
    self.rateTitleLab.text = locationString(@"new_myinvest_list_item_annualIncomeText");
    
    self.amountTitleLab = [Utility createLabel:[CustomerizedFont heiti:11] color:[UIColor colorWithHexString:@"#666666"]];
    self.amountTitleLab.text = locationString(@"new_myinvest_list_item_orderRevenue");
    
    self.perTitleLab = [Utility createLabel:[CustomerizedFont heiti:11] color:[UIColor colorWithHexString:@"#666666"]];
    self.perTitleLab.text = locationString(@"orderAmount");

    NSArray *titleLab = @[self.perTitleLab,self.amountTitleLab,self.rateTitleLab];
    for (int i =0; i<titleLab.count; i++) {
        UILabel *title = titleLab[i];
        title.textAlignment = NSTextAlignmentCenter;
        [self.backView addSubview:title];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(12+hWidth*i));
            make.top.equalTo(self.perLab.mas_bottom);
            make.width.equalTo(@(hWidth));
            make.height.equalTo(@15);
        }];

    }
    //投资金额 可获奖励
    self.invLab = [Utility createLabel:[CustomerizedFont heiti:17] color:[UIColor colorWithHexString:@"#333333"]];
    self.rewardLab = [Utility createLabel:[CustomerizedFont heiti:15] color:[UIColor colorWithHexString:@"#333333"]];
    self.rewardLab.adjustsFontSizeToFitWidth = YES;
    self.invLab.textAlignment = NSTextAlignmentCenter;
    self.rewardLab.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:self.invLab];
    [backView addSubview:self.rewardLab];
    
    
    self.invTitleLab = [Utility createLabel:[CustomerizedFont heiti:11] color:[UIColor colorWithHexString:@"#666666"]];
    self.invTitleLab.text = locationString(@"orderAmount");
    
    self.rewardTitleLab = [Utility createLabel:[CustomerizedFont heiti:11] color:[UIColor colorWithHexString:@"#666666"]];
    self.rewardTitleLab.text = locationString(@"get_Reward");
    
    self.invTitleLab.textAlignment = NSTextAlignmentCenter;
    self.rewardTitleLab.textAlignment = NSTextAlignmentCenter;
    
    [backView addSubview:self.invTitleLab];
    [backView addSubview:self.rewardTitleLab];
    
    UIView *linedown = [[UIView alloc]init];//WithFrame:CGRectMake(15, self.invTitleLab.bottom + 5, kScreenWidth - 30 - 24, 0.5)];
    linedown.backgroundColor =[UIColor colorWithHexString:@"#e2e2e2"];
    [backView addSubview:linedown];
    
    //进度
//    self.barProgress = [[LTNBarProgressView alloc]init];//WithFrame:CGRectMake(15, self.perTitleLab.bottom + 5, kScreenWidth - 30 - 24, 4)];
//    self.barProgress.lineColorString = @"#ff6600";
//    [backView addSubview:self.barProgress];
    
    //日期
    CGFloat width = (kScreenWidth - 30 -24)/2;
    _dateLables = [NSMutableArray arrayWithCapacity:2];
    
    for (int i = 0; i<2; i++) {
        UILabel *dateLab = [Utility createLabel:[CustomerizedFont heiti:11] color:[UIColor colorWithHexString:@"#666666"]];
        self.dateLab = dateLab;
        
        if (i==0) {
            self.dateLab.textAlignment = NSTextAlignmentLeft;
        }else{
            self.dateLab.textAlignment = NSTextAlignmentRight;
        }
        
        [self.backView addSubview:dateLab];
        
        [_dateLables addObject:self.dateLab];
        
        [dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(15+width*i));
            make.top.equalTo(linedown.mas_bottom);
            make.width.equalTo(@(width));
            make.height.equalTo(@40);
        }];
    }
    
    UIView *views = [[UIView alloc]init];
    views.backgroundColor = BACKGROUND_COLOR;
    [self.contentView addSubview:views];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(@0);
        make.width.equalTo(@(kScreenWidth - 24));
        make.height.equalTo(@140);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@0);
        make.width.equalTo(@(kScreenWidth - 24 - kGeneralHeight));
        make.height.equalTo(@40);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kScreenWidth -47));
        make.top.equalTo(@12.5);
        make.width.equalTo(@8);
        make.height.equalTo(@15);
    }];
    
    [lineup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@39.5);
        make.width.equalTo(@(kScreenWidth - 54));
        make.height.equalTo(@0.5);
    }];
    
    [self.invLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(lineup.mas_bottom).offset(10);
        make.width.equalTo(@(kScreenWidth/2 - 24));
        make.height.equalTo(@31);
    }];
    
    [self.rewardLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kScreenWidth/2 - 12));
        make.top.equalTo(lineup.mas_bottom).offset(10);
        make.width.equalTo(@(kScreenWidth/2 - 24));
        make.height.equalTo(@31);
    }];
    
    [self.invTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(self.invLab.mas_bottom);
        make.width.equalTo(@(kScreenWidth/2 - 24));
        make.height.equalTo(@15);
    }];
    
    [self.rewardTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kScreenWidth/2 - 12));
        make.top.equalTo(self.invLab.mas_bottom);
        make.width.equalTo(@(kScreenWidth/2 - 24));
        make.height.equalTo(@15);
    }];
    
    [linedown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(self.perTitleLab.mas_bottom).offset(5);
        make.width.equalTo(@(kScreenWidth - 54));
        make.height.equalTo(@0.5);
    }];

//    [self.barProgress mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@15);
//        make.top.equalTo(self.perTitleLab.mas_bottom).offset(5);
//        make.width.equalTo(@(kScreenWidth - 54));
//        make.height.equalTo(@4);
//    }];

    [views mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(self.backView.mas_bottom);
        make.width.equalTo(@(kScreenWidth - 24));
        make.height.equalTo(@15);
    }];
    
    
}

- (void)setData:(id)data {
    _data = data;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@",self.data[@"productName"]];//标题
    
    NSString *rateString = [NSString stringWithFormat:@"%@", self.data[@"annualIncomeText"]];//年化收益
    self.rateLab.text = rateString;
    
    if([rateString rangeOfString:@"%"].location !=NSNotFound){
        NSRange rangeAdd = [rateString rangeOfString:@"%"];
        NSRange range = {rangeAdd.location,rateString.length-rangeAdd.location};
        NSString *newS = [rateString substringWithRange:range];
        [self.rateLab addAttributesWithFontSize:14 forString:newS];
        
    }
    self.denominationStr = [NSString stringWithFormat:@"%@",self.data[@"denomination"]];//返现收益
    NSString *totalStr = [NSString stringWithFormat:@"%@", self.data[@"interest"]];//到期收益
    self.amountLab.text = totalStr;
    
//    self.perLab.text = [NSString stringWithFormat:@"%@%@", self.data[@"orderAmount"],locationString(@"num_Person")];//参与人数
    self.perLab.text = [NSString stringWithFormat:@"%@", self.data[@"orderAmount"]];//投资金额
    
    if([self.perLab.text rangeOfString:locationString(@"num_Person")].location !=NSNotFound){
        NSRange rangeAdd = [self.perLab.text rangeOfString:locationString(@"num_Person")];
        NSRange range = {rangeAdd.location,self.perLab.text.length-rangeAdd.location};
        NSString *newS = [self.perLab.text substringWithRange:range];
        [self.perLab addAttributesWithFontSize:14 forString:newS];
        
    }
    
    double denomination = [self.denominationStr doubleValue];
    if (denomination > 0) {
        self.amountLab.text = [NSString stringWithFormat:@"%@+%@",totalStr,self.denominationStr];
        NSRange rangeAdd = [self.amountLab.text rangeOfString:@"+"];
        NSRange range = {rangeAdd.location,self.amountLab.text.length-rangeAdd.location};
        NSString *newS = [self.amountLab.text substringWithRange:range];
        [self.amountLab addAttributesWithFontSize:14 forString:newS];
    }

    
    double progress = 0;
    if ([self.data[@"productType"] isEqualToString:@"B"]) {//理财类
        progress = [self.data[@"productSoldedAmount"] doubleValue] / [self.data[@"productTotalAmount"] doubleValue];
    }
    //self.barProgress.progress = progress;
    
    self.invLab.text = [NSString stringWithFormat:@"%@",self.data[@"orderAmount"]];
    NSString *rewardStr = self.data[@"stepAward"];
    if (!rewardStr.length) {
        rewardStr = @"---";
    }
    self.rewardLab.text = rewardStr;
    if ([self.data[@"productType"] isEqualToString:@"A"]) {//实物类
        self.amountLab.hidden = YES;
        self.amountTitleLab.hidden = YES;
        self.perLab.hidden = YES;
        self.perTitleLab.hidden = YES;
        self.rateLab.hidden = YES;
        self.rateTitleLab.hidden = YES;
       // self.barProgress.hidden = YES;
        self.invLab.hidden = NO;
        self.invTitleLab.hidden = NO;
        self.rewardLab.hidden = NO;
        self.rewardTitleLab.hidden = NO;
    }else{
        self.invLab.hidden = YES;
        self.invTitleLab.hidden = YES;
        self.rewardLab.hidden = YES;
        self.rewardTitleLab.hidden = YES;
        self.amountLab.hidden = NO;
        self.amountTitleLab.hidden = NO;
        self.perLab.hidden = NO;
        self.perTitleLab.hidden = NO;
        self.rateLab.hidden = NO;
        self.rateTitleLab.hidden = NO;
       // self.barProgress.hidden = NO;
    }
    
    
    NSArray *dateData = @[
                          [NSString stringWithFormat:locationString(@"new_myinvest_list_item_payDate"), [esString(self.data[@"orderDate"]) length]>0  ? esString(self.data[@"orderDate"]) : @"------"],
                          
                          [NSString stringWithFormat:locationString(@"new_myinvest_list_item_endDate"), [esString(self.data[@"endTime"]) length]>0  ? esString(self.data[@"endTime"]) : @"------"],
                          
                          ];
    
    
    
    [self updateDateValue:dateData];
}

-(void)updateDateValue:(id)data{
    int i = 0;
    for (UILabel *lab in self.dateLables) {
        lab.text = data[i];
        i++;
    }
    
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
