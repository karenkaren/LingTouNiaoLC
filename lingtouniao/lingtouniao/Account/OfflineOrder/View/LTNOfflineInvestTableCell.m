//
//  LTNOfflineInvestTableCell.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/2/22.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNOfflineInvestTableCell.h"
#import "NSStringUtil.h"

@interface LTNOfflineInvestTableCell ()

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) NSMutableArray *keyLabels;
@property (nonatomic) NSMutableArray *valueLabels;
@property (nonatomic) NSInteger num;
@property (nonatomic) NSArray *keyTitles;
@property (nonatomic) CGFloat xMargin;

@end

@implementation LTNOfflineInvestTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _xMargin = 20;
        
        _keyTitles = @[locationString(@"anxintou_rate"), locationString(@"anxintou_month"), locationString(@"anxintou_wan"), locationString(@"anxintou_total_wan"), locationString(@"anxintou_time"), locationString(@"anxintou_date")];
        _num = [self.keyTitles count];
        [self createNormalLabel];
    }
    return self;
}

- (void)createNormalLabel {
    _keyLabels = [NSMutableArray arrayWithCapacity:self.num];
    _valueLabels = [NSMutableArray arrayWithCapacity:self.num];
    CGFloat x = self.xMargin;
    CGFloat hWidth = kScreenWidth / 2;
    CGFloat height = 136.0 / 3;
    CGFloat keyWidth = 0;
    for (int i = 0; i < self.num; i++) {
        UILabel *keyLabel = [Utility createLabel:[CustomerizedFont heiti:14] color:[UIColor colorWithHex:0x8a8a8a alpha:1]];
        keyLabel.text = _keyTitles[i];
        
        if (i == 0 || i == 1) {
            [keyLabel sizeToFit];
            keyWidth = keyLabel.width;
        }
        keyLabel.left = i % 2 * (hWidth - 10) + x;
        keyLabel.top = i / 2 * height +10;
        keyLabel.width = keyWidth;
        keyLabel.height = height;
        [keyLabel sizeToFit];
        [self.contentView addSubview:keyLabel];
        
        UILabel *valueLabel = [Utility createLabel:[CustomerizedFont heiti:14] color:[UIColor colorWithHex:0x6a6a6a alpha:1]];
        [self.contentView addSubview:valueLabel];
        
        [_keyLabels addObject:keyLabel];
        [_valueLabels addObject:valueLabel];
    }
}

- (void)setData:(id)data {
    
    _data = data;

    NSArray *labelsData = @[
                            [NSString stringWithFormat:@"%.2f%@", [self.data[@"annual_income"] doubleValue] * 100, @"%"],
                            [NSString stringWithFormat:@"%@", safeEmpty(self.data[@"investment_term"])],
                            [NSString stringWithFormat:@"%.2f", [self.data[@"order_amount"] floatValue]/10000.0],
                            [NSString stringWithFormat:@"%.2f", [self.data[@"profit"] floatValue]/10000.0],
                            [NSString stringWithFormat:@"%@", safeEmpty(self.data[@"order_date"])],
                            [NSString stringWithFormat:@"%@", safeEmpty(self.data[@"over_date"])],
                            ];

    [self updateLabelvalue:labelsData];
}

- (void)updateLabelvalue:(id)data {
    int i = 0;
    for (UILabel *label in self.valueLabels) {
        UILabel *keyLabel = self.keyLabels[i];
        NSString *str = data[i];
        if (![str length]) {
            str = @"---";
        }
        
        label.text = str;
        [label sizeToFit];
        label.left = keyLabel.right + 5;
        label.centerY = keyLabel.centerY;
        i++;
    }
}

@end
