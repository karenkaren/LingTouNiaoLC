//
//  LJBarProgressView.m
//  进度条
//
//  Created by LiuFeifei on 15/11/18.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LJBarProgressView.h"

@implementation LJBarProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5.0] addClip];
    CGContextSetLineCap(context, kCGLineCapRound);
    
    // 底部bar
    [kRGBColor(236, 236, 236) set];
    CGContextSetLineWidth(context, height);
    CGContextMoveToPoint(context, 0, height * 0.5);
    CGContextAddLineToPoint(context, width, height * 0.5);
    CGContextStrokePath(context);
    
    // 进度bar
    [kRGBColor(253, 182, 10) set];
    CGFloat to = self.progress * width;
    CGContextMoveToPoint(context, 0, height * 0.5);
    CGContextAddLineToPoint(context, to, height * 0.5);
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    [self setNeedsDisplay];
}

@end
