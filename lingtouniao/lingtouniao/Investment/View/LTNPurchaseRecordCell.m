 //
//  LTNPurchaseRecordCell.m
//  lingtouniao
//
//  Created by LiuFeifei on 15/12/25.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNPurchaseRecordCell.h"

@interface LTNPurchaseRecordCell ()

@property (nonatomic) NSMutableArray * valueLabels;

@end

@implementation LTNPurchaseRecordCell

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
        UILabel * valueLabel = [Utility createLabel:[CustomerizedFont systemFontOfSize:DimensionBaseIphone6(15)] color:[UIColor blackColor]];
        [self.contentView addSubview:valueLabel];
        [_valueLabels addObject:valueLabel];
        
    }
}

- (void)setData:(id)data
{
    _data = data;
    NSString * userName = [NSMutableString stringWithFormat:@"%@", data[@"userName"]];
    if (userName.length == 11) {
        userName = [userName stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    
    //zhangtongke 在小屏幕下数据显示不全 截取秒 并且 字号变小
    NSString * orderDate = data[@"orderDate"];
    if([orderDate length] > 16)
        orderDate = [orderDate substringWithRange:NSMakeRange(5, 11)];
    
    NSArray * values = @[userName, data[@"orderAmount"], orderDate];
    CGFloat margin = 10;
    CGFloat width = (kScreenWidth - 2 * 20 - margin * 2) / 3.0;
    for (int i = 0; i < values.count; i++) {
        UILabel * valueLabel = _valueLabels[i];
        valueLabel.text = values[i];
        valueLabel.frame = CGRectMake(20 + (width + margin) * i, 0, width, self.height);
        valueLabel.adjustsFontSizeToFitWidth = YES;
//        [valueLabel sizeToFit];
//        valueLabel.centerY = self.height * 0.5;
//        if (i == 0) {
//            valueLabel.left = 20;
//        } else if (i == 1) {
//            valueLabel.left = 120;
//            if (valueLabel.right >= 190) {
//                valueLabel.width = 190 - 120;
//                valueLabel.adjustsFontSizeToFitWidth = YES;
//            }
//        } else {
//            valueLabel.left = 200;
//        }
    }
}

@end
