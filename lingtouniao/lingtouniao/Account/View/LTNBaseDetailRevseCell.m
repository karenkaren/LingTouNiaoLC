//
//  LTNBaseDetailRevseCell.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/3/24.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNBaseDetailRevseCell.h"

@interface LTNBaseDetailRevseCell ()

@property (nonatomic) NSMutableArray * valueLabels;

@end

@implementation LTNBaseDetailRevseCell

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
    _valueLabels = [NSMutableArray arrayWithCapacity:3];
    for (int i = 0; i < 3; i++) {
        UILabel * valueLabel = [Utility createLabel:[CustomerizedFont systemFontOfSize:13] color:[UIColor colorWithHexString:@"#3A3A3A"]];
        [valueLabel adjustsFontSizeToFitWidth];
        [self.contentView addSubview:valueLabel];
        [_valueLabels addObject:valueLabel];
        
        if (i == 2) {
            valueLabel.textAlignment = NSTextAlignmentRight;
        }
    }
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 0.5, kScreenWidth, 0.5)];
    lineView.backgroundColor = HexRGB(0xcccccc);
    [self addSubview:lineView];
}

- (void)setData:(id)data
{
    _data = data;
    NSArray * values = @[[NSString stringWithFormat:@"%@", data[@"title"]], [NSString stringWithFormat:@"%@", data[@"time"]], [NSString stringWithFormat:@"%.2f", [data[@"money"] floatValue]]];
    for (int i = 0; i < values.count; i++) {
        UILabel * valueLabel = _valueLabels[i];
        valueLabel.text = values[i];
        [valueLabel sizeToFit];
        valueLabel.centerY = self.height * 0.5;
        if (i == 0) {
            valueLabel.left = 16;
        } else if (i == 1) {
//            valueLabel.left = 180;
            valueLabel.right = kScreenWidth - (kScreenWidth - 30)/3 - 15;
        }else{
            valueLabel.right = kScreenWidth - 16;
        }
    }
}



@end
