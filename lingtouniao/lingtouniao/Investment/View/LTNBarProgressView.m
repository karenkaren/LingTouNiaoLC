//
//  LTNBarProgressView.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/3/23.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNBarProgressView.h"

@interface LTNBarProgressView ()

@property (nonatomic) CGFloat raisepProgress;
@property (nonatomic) NSTimer *timer;

@end


@implementation LTNBarProgressView

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
    //self.backgroundColor=[UIColor blueColor];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGFloat width = rect.size.width;
    CGFloat height = 1;
    
    
    // 底部bar
    [kRGBColor(236, 236, 236) set];
    CGContextSetLineWidth(context, height);
    CGContextMoveToPoint(context, 0, self.height * 0.5-1);
    CGContextAddLineToPoint(context, width, self.height * 0.5-1);
    CGContextStrokePath(context);
    
    NSString * colorString = self.lineColorString ? self.lineColorString : @"#EC5400";
    if(_finished)
        colorString=@"#E2E2E2";
    
    // 进度bar
    [[UIColor colorWithHexString:colorString] set];
    CGFloat to =self.raisepProgress * width ;
   
    if (_finished) {
        to = self.progress * width;
    }
    
    CGContextMoveToPoint(context, 0, self.height * 0.5-1 );
    CGContextAddLineToPoint(context, to, self.height * 0.5-1);
    CGContextStrokePath(context);
    
    if (to >= rect.size.width - 2) {
        to = rect.size.width - 2;
    }
    
    // 画进度头部的圆点
    CGContextFillEllipseInRect(context, CGRectMake(to, self.height *0.5 - 2, 2, 2));
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.001f target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    [self.timer fire];
}

-(void)updateProgress{
    if (self.raisepProgress + 0.01 >= self.progress) {
        self.raisepProgress = self.progress;
        [self setNeedsDisplay];
        [self.timer invalidate];
        return;
    }
    self.raisepProgress += 0.01 ;
    [self setNeedsDisplay];
    
}
@end
