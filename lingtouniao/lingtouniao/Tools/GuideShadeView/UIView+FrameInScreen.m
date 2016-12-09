//
//  UIView+FrameInScreen.m
//  lingtouniao
//
//  Created by zhangtongke on 16/6/12.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "UIView+FrameInScreen.h"

@implementation UIView (FrameInScreen)
-(CGRect)frameInScreen{
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    UIView *subSuperView = self.superview;
    CGRect rect=[window convertRect:self.frame fromView:subSuperView];
    return rect;

}
@end
