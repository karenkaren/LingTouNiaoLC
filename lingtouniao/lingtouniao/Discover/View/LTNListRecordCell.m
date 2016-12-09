//
//  LTNListRecordCell.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/9/27.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNListRecordCell.h"

@interface LTNListRecordCell ()

@property (nonatomic) NSMutableArray * valueLabels;

@end

@implementation LTNListRecordCell

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
    
    NSString * userName = [NSMutableString stringWithFormat:@"%@", data[@"mobileNo"]];
    if (userName.length == 11) {
        userName = [userName stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    
    NSString * orderDate = nil;
    if (self.isDateFormat) {
        orderDate = esString(data[@"orderTime"]);//众筹 投资时间的字段
    }else{
        orderDate = esString(data[@"orderDate"]);//互助 投资时间的字段
    }
    if([orderDate length] > 16)
        orderDate = [orderDate substringWithRange:NSMakeRange(5, 11)];

    
//    NSString * orderDate = esString(data[@"orderDate"]);
//    if([orderDate length] > 16)
//        orderDate = [orderDate substringWithRange:NSMakeRange(5, 11)];
    
    NSArray * values = @[userName, esString(data[@"orderAmount"]), orderDate];
    CGFloat margin = 10;
    CGFloat width = (kScreenWidth - 2 * 20 - margin * 2) / 3.0;
    for (int i = 0; i < values.count; i++) {
        UILabel * valueLabel = _valueLabels[i];
        valueLabel.text = values[i];
        valueLabel.frame = CGRectMake(20 + (width + margin) * i, 0, width, self.height);
        valueLabel.adjustsFontSizeToFitWidth = YES;
        
    }
    
}


@end
