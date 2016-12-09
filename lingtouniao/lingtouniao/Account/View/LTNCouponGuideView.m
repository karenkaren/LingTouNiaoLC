//
//  LTNCouponGuideView.m
//  lingtouniao
//
//  Created by zhangtongke on 16/11/24.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNCouponGuideView.h"

@implementation LTNCouponGuideView

- (instancetype)init
{
    self = [super init];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenGuideView)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)hiddenGuideView{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
