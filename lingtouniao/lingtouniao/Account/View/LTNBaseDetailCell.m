//
//  LTNBaseDetailCell.m
//  lingtouniao
//
//  Created by LiuFeifei on 15/12/24.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNBaseDetailCell.h"

@interface LTNBaseDetailCell ()

@property (nonatomic) NSMutableArray * valueLabels;

@end

@implementation LTNBaseDetailCell

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
    
       _valueLabels = [NSMutableArray arrayWithCapacity:4];
        for (int i = 0; i < 4; i++) {
            UILabel * valueLabel = [Utility createLabel:[CustomerizedFont systemFontOfSize:13] color:[UIColor colorWithHexString:@"#3A3A3A"]];
            [valueLabel adjustsFontSizeToFitWidth];
            [self.contentView addSubview:valueLabel];
            [_valueLabels addObject:valueLabel];
            if (i == 1){
                valueLabel.textColor = [UIColor colorWithHexString:@"#6A6A6A"];
                valueLabel.font = [CustomerizedFont heiti:12];
            }
            if (i == 3) {
                valueLabel.textAlignment = NSTextAlignmentRight;
            }
        }

    
//    self.titleLab = [Utility createLabel:[CustomerizedFont systemFontOfSize:13] color:[UIColor colorWithHexString:@"#3A3A3A"]];
//    self.titleLab.textAlignment = NSTextAlignmentLeft;
//    self.titleLab.numberOfLines = 0;
//    [self.contentView addSubview:self.titleLab];
//    
//    self.timeLab = [Utility createLabel:[CustomerizedFont heiti:12] color:[UIColor colorWithHexString:@"#6A6A6A"]];
//    self.timeLab.textAlignment = NSTextAlignmentLeft;
//    [self.contentView addSubview:self.timeLab];
//    
//    self.moneyLab = [Utility createLabel:[CustomerizedFont systemFontOfSize:13] color:[UIColor colorWithHexString:@"#3A3A3A"]];
//    self.moneyLab.textAlignment = NSTextAlignmentCenter;
//    [self.contentView addSubview:self.moneyLab];
//    
//    self.totalLab = [Utility createLabel:[CustomerizedFont systemFontOfSize:13] color:[UIColor colorWithHexString:@"#3A3A3A"]];
//    self.totalLab.textAlignment = NSTextAlignmentRight;
//    [self.contentView addSubview:self.totalLab];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 0.5, kScreenWidth, 0.5)];
    lineView.backgroundColor = HexRGB(0xcccccc);
//    self.lineView = lineView;
    [self addSubview:lineView];
}

- (void)setData:(id)data
{
    _data = data;
    
//    self.titleLab.text = [NSString stringWithFormat:@"%@", data[@"title"]];
//    [self.titleLab sizeToFit];
//    self.timeLab.text = [NSString stringWithFormat:@"%@", data[@"time"]];
//    self.moneyLab.text = [NSString stringWithFormat:@"%.2f", [data[@"money"] doubleValue]];
//    self.totalLab.text = [NSString stringWithFormat:@"%.2f",[data[@"total"] doubleValue]];
//    
//    CGSize maxSize = CGSizeMake((kScreenWidth - 32)/3, MAXFLOAT);
//    CGSize fitSize = [self.titleLab sizeThatFits:maxSize];
//    self.titleLab.frame = CGRectMake(16, 5, (kScreenWidth - 32)/3, fitSize.height);
//    
//    self.timeLab.frame = CGRectMake(16, self.titleLab.bottom + 3, (kScreenWidth - 32)/3, 15);
//    self.moneyLab.frame = CGRectMake(self.titleLab.right, (5+fitSize.height)/2, (kScreenWidth - 32)/3, 20);
//    self.totalLab.frame = CGRectMake(self.moneyLab.right,(5+fitSize.height)/2, (kScreenWidth - 32)/3, 20);
//    self.lineView.frame = CGRectMake(0, 28+fitSize.height - 0.5, kScreenWidth, 0.5);
//    
    
    
    
    NSArray * values = @[[NSString stringWithFormat:@"%@", data[@"title"]], [NSString stringWithFormat:@"%@", data[@"time"]], [NSString stringWithFormat:@"%.2f", [data[@"money"] doubleValue]],[NSString stringWithFormat:@"%.2f",[data[@"total"] doubleValue]]];
    for (int i = 0; i < values.count; i++) {
        UILabel * valueLabel = _valueLabels[i];
        valueLabel.text = values[i];
        [valueLabel sizeToFit];
        valueLabel.centerY = self.height * 0.5;
        if (i == 0) {
            valueLabel.top = 5;
            valueLabel.left = 16;
        } else if (i == 1) {
            valueLabel.top = 25;
            valueLabel.left = 16;
        }else if (i == 2 ){
//            valueLabel.left = 172;
            valueLabel.right = kScreenWidth - (kScreenWidth - 30)/3 - 15;
        }else{
            valueLabel.right = kScreenWidth - 16;
        }
    }
}

+ (CGFloat)heightForData:(id)data{
    CGFloat height = 28;
    
    static UILabel *label;
    if (!label) {
        label = [Utility createLabel:[CustomerizedFont heiti:13] color:nil];
        label.numberOfLines = 0;
    }
    label.text = [NSString stringWithFormat:@"%@", data[@"title"]];
    CGSize maxSize = CGSizeMake((kScreenWidth - 32)/3, MAXFLOAT);
    CGSize fitSize = [label sizeThatFits:maxSize];
    
    return ceilf(height + fitSize.height);
}

@end
