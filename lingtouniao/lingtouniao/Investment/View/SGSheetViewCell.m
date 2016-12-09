//
//  SGSheetViewCell.m
//  lingtouniao
//
//  Created by 徐凯 on 16/1/9.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "SGSheetViewCell.h"

@implementation SGSheetViewCell


-(void)setTitleLabel:(NSString *)title withDescLabel:(NSString *)desc withDateLabel:(NSString *)date
{
    _titleLabel.text = title;
    _descLabel.text= desc;
    _dateLabel.text = date;

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
