//
//  ReplaceHeaderView.m
//  lingtouniao
//
//  Created by 徐凯 on 16/4/5.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "ReplaceHeaderView.h"

@implementation ReplaceHeaderView

- (void) awakeFromNib
{
    [super awakeFromNib];
    _change_bank_card_1_Label.text =  locationString(@"change_bank_card_1");
    _change_bank_card_2_Label.text =  locationString(@"change_bank_card_2");
    _change_bank_card_3_Label.text =  locationString(@"change_bank_card_3");


}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
