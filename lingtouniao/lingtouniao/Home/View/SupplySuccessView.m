//
//  SupplySuccessView.m
//  lingtouniao
//
//  Created by 徐凯 on 16/4/1.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "SupplySuccessView.h"

@implementation SupplySuccessView

- (void)awakeFromNib
{
    [super awakeFromNib];
    _supply_Des_Label.text = locationString(@"submit_success");

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
