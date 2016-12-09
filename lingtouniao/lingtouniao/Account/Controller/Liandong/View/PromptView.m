//
//  PromptView.m
//  lingtouniao
//
//  Created by 徐凯 on 15/12/28.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "PromptView.h"

@implementation PromptView

- (void)awakeFromNib
{
    [super awakeFromNib];
    _tipsLabel.text = locationString(@"tips_message");

}

-(id)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"PromptView" owner:self options:nil]lastObject];
        self.frame = CGRectMake(0, 0,kScreenWidth, kScreenWidth * 40 / 320);
    }
    return self;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
