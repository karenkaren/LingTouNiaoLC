//
//  LTNCircleProgressView.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/1/18.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNCircleProgressView.h"

@interface LTNCircleProgressView ()

@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, assign) CGFloat raisepProgress;
@property (nonatomic) UIView *lineV;

@end


@implementation LTNCircleProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1)];
        self.lineV.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.lineV];
    }
    return self;
}

-(void)setProgress:(float)progress{
    _progress=progress;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)updateProgress
{
    if (self.raisepProgress + 0.1 >= self.progress) {
        self.raisepProgress = self.progress;
        [self setNeedsDisplay];
        [self.timer invalidate];
        return;
    }
    self.raisepProgress += 0.1;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    self.lineV.backgroundColor = self.backgroundColor;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height - 2.5;
    CGFloat radius = yCenter - 2.5;
    
    // 画底部半圆
    [HexRGB(0xe2e2e2) set];
    CGContextSetLineWidth(context, 2);
    CGContextAddArc(context, xCenter, yCenter, radius, -M_PI, 0, NO);
    CGContextStrokePath(context);
    
    // 画进度
    CGFloat to = M_PI * self.raisepProgress - M_PI;
    [HexRGB(0xffc000) set];
    CGContextAddArc(context, xCenter, yCenter, radius, -M_PI, to, NO);
    CGPoint endPoint = CGContextGetPathCurrentPoint(context);
    CGContextStrokePath(context);
    
    // 画进度头部的圆点
    CGFloat width = 5;
    CGContextFillEllipseInRect(context, CGRectMake(endPoint.x - width * 0.5, endPoint.y - width * 0.5, width, width));
    CGContextStrokePath(context);
}

@end
