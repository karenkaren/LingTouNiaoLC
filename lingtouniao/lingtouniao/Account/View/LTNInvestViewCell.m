//
//  LTNInvestViewCell.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/11/1.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNInvestViewCell.h"

@implementation LTNInvestViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = BACKGROUND_COLOR;
        
        [self createNormalLabel];
    }
    return self;
}


- (void)createNormalLabel {
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(12, 0, kScreenWidth - 24, 140)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    self.backView = backView;
    
    self.backView.layer.borderColor = [UIColor colorWithHexString:@"#e2e2e2"].CGColor;
    self.backView.layer.borderWidth = 0.5;
    
    self.titleLabel = [Utility createLabel:[CustomerizedFont heiti:15] color:[UIColor colorWithHexString:@"#666666"]];
    self.titleLabel.frame = CGRectMake(15, 0, kScreenWidth - 24 - kGeneralHeight, 40);
    [backView addSubview:self.titleLabel];
    
    self.imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_arrow1"]];
    self.imgView.frame = CGRectMake(kScreenWidth - 15-24 - 8, 12.5, 8, 15);
    [backView addSubview:self.imgView];
    
    UIView *lineup = [[UIView alloc]initWithFrame:CGRectMake(15, 39.5, kScreenWidth-30-24, 0.5)];
    lineup.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [backView addSubview:lineup];
    
    //投资金额、到期收益、年化收益
    
    //数据
    CGFloat hWidth = (kScreenWidth-24-24) / 3;
    
    self.invLab = [Utility createLabel:[CustomerizedFont heiti:22] color:[UIColor colorWithHexString:@"#333333"]];
    self.reveLab = [Utility createLabel:[CustomerizedFont heiti:22] color:[UIColor colorWithHexString:@"#333333"]];
    self.rateLab = [Utility createLabel:[CustomerizedFont heiti:22] color:[UIColor colorWithHexString:@"#333333"]];
    
    NSArray *dataLab = @[self.invLab,self.reveLab,self.rateLab];
    for (int i =0; i<dataLab.count; i++) {
        UILabel *label = dataLab[i];
        label.frame = CGRectMake(12+hWidth*i, lineup.bottom+10, hWidth, 31);
        label.textAlignment = NSTextAlignmentCenter;
        if (i == 1) {
            label.textColor = [UIColor colorWithHexString:@"#ea5504"];
        }
        label.adjustsFontSizeToFitWidth = YES;
        [self.backView addSubview:label];
    }
    
    //文字
    self.invTitleLab = [Utility createLabel:[CustomerizedFont heiti:11] color:[UIColor colorWithHexString:@"#999999"]];
    self.reveTitleLab = [Utility createLabel:[CustomerizedFont heiti:11] color:[UIColor colorWithHexString:@"#999999"]];
    self.rateTitleLab = [Utility createLabel:[CustomerizedFont heiti:11] color:[UIColor colorWithHexString:@"#999999"]];
    
    NSArray *titleLab = @[self.invTitleLab,self.reveTitleLab,self.rateTitleLab];
    for (int i =0; i<titleLab.count; i++) {
        UILabel *title = titleLab[i];
        title.frame = CGRectMake(12+hWidth*i, self.invLab.bottom, hWidth, 15);
        title.textAlignment = NSTextAlignmentCenter;
        [self.backView addSubview:title];
    }
    
    UIView *linedown = [[UIView alloc]initWithFrame:CGRectMake(15, self.invTitleLab.bottom + 5, kScreenWidth - 30 - 24, 0.5)];
    self.linedown = linedown;
    linedown.backgroundColor =[UIColor colorWithHexString:@"#e2e2e2"];
    [backView addSubview:linedown];
    
    //日期
    CGFloat width = (kScreenWidth - 30 -24)/2;
    _dateLables = [NSMutableArray arrayWithCapacity:2];
    
    for (int i = 0; i<2; i++) {
        UILabel *dateLab = [Utility createLabel:[CustomerizedFont heiti:12] color:[UIColor colorWithHexString:@"#999999"]];
        self.dateLab = dateLab;
        
        dateLab.frame = CGRectMake(15 + width*i, self.linedown.bottom + 31.5, width, 80 - self.linedown.top);
        
        if (i==0) {
            self.dateLab.textAlignment = NSTextAlignmentLeft;
        }else{
            self.dateLab.textAlignment = NSTextAlignmentRight;
        }
        
        [self.backView addSubview:dateLab];
        
        [_dateLables addObject:self.dateLab];
    }
}

- (void)setData:(id)data {
    _data = data;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@",self.data[@"productName"]?:locationString(@"productt_ty_detail_name")];
    
    if ([self.data[@"productType"] isEqualToString:@"TYB"] || [self.data[@"productType"] isEqualToString:@"XSB"]) {
        self.imgView.hidden = YES;
    }else{
        self.imgView.hidden = NO;
    }
    
    self.couponRevenue = [NSString stringWithFormat:@"%@",self.data[@"couponRevenue"]];//返现收益
    
    self.invLab.text = [NSString stringWithFormat:@"%@", self.data[@"orderAmount"]];//投资金额
    
    NSString *reveString = [NSString stringWithFormat:@"%@", self.data[@"orderRevenueTwo"]];//到期收益
    self.reveLab.text = reveString;
    
    
    NSString *rateString = [NSString stringWithFormat:@"%@", self.data[@"annualIncomeText"]];//年化收益
    self.rateLab.text = rateString;
    
    self.invTitleLab.text = locationString(@"orderAmount");
    self.reveTitleLab.text = locationString(@"new_myinvest_list_item_orderRevenue");
    self.rateTitleLab.text = locationString(@"new_myinvest_list_item_annualIncomeText");
    
    if ([self.data[@"productType"] isEqualToString:@"TYB"]) {
        self.reveLab.text =  [NSString stringWithFormat:@"%@", self.data[@"orderRevenue"]];
        self.reveTitleLab.text = [locationString(@"new_myinvest_list_item_orderRevenue") substringToIndex:4];
    }
    
    if ([self.invLab.text integerValue] >= 100000) {
        self.invLab.font = [CustomerizedFont heiti:18];
    }else{
        self.invLab.font = [CustomerizedFont heiti:22];
    }
    
    double couponRev = [self.couponRevenue doubleValue];
    if (couponRev > 0) {
        self.reveLab.text = [NSString stringWithFormat:@"%@+%@",reveString,self.couponRevenue];
        NSRange rangeAdd = [self.reveLab.text rangeOfString:@"+"];
        NSRange range = {rangeAdd.location,self.reveLab.text.length-rangeAdd.location};
        NSString *newS = [self.reveLab.text substringWithRange:range];
        [self.reveLab addAttributesWithFontSize:14 forString:newS];
    }
    
    if([rateString rangeOfString:@"%"].location !=NSNotFound){
        NSRange rangeAdd = [rateString rangeOfString:@"%"];
        NSRange range = {rangeAdd.location,rateString.length-rangeAdd.location};
        NSString *newS = [rateString substringWithRange:range];
        [self.rateLab addAttributesWithFontSize:14 forString:newS];
        
    }
    
    
    NSArray *dateData = @[
                          [NSString stringWithFormat:locationString(@"new_myinvest_list_item_payDate"), self.data[@"orderDate"] ?: @""],
                          [NSString stringWithFormat:locationString(@"new_myinvest_list_item_endDate"), self.data[@"expireDate"] ?: @""]
                          ];
    
    [self updateDateValue:dateData];
}

-(void)updateDateValue:(id)data{
    
    int i = 0;
    for (UILabel *lab in self.dateLables) {
        NSString *str = data[i];
        if (![str length]) {
            str = @"---";
        }
        lab.text = str;
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
