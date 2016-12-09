//
//  UIButton+LJ.m
//  lingtouniao
//
//  Created by LiuFeifei on 15/12/2.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "UIButton+LJ.h"

@implementation UIButton (LJ)

- (void)setDisenableBackgroundColor:(UIColor *)disenableColor enableBackgroundColor:(UIColor *)enableColor
{
    CGSize size = CGSizeMake(1, 1);
    [self setBackgroundImage:[UIImage imageWithColor:enableColor size:size] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:disenableColor size:size] forState:UIControlStateDisabled];
}

@end
