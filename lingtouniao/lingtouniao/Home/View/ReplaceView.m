//
//  ReplaceView.m
//  lingtouniao
//
//  Created by 徐凯 on 16/4/1.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "ReplaceView.h"

@implementation ReplaceView

- (void)awakeFromNib
{
    [super awakeFromNib];
    _phone_des_Label.text = locationString(@"phone_des_Label");
    [_replaceButton setTitle:locationString(@"btn_confirm")forState:UIControlStateNormal];

}

-(id)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"ReplaceView" owner:self options:nil] objectAtIndex:0];
    self.frame = CGRectMake(0, 0, kScreenWidth,110.0);
    return self;
}


@end
