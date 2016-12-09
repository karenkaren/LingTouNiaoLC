//
//  LineDrawView.m
//  lingtouniao
//
//  Created by zhangtongke on 16/5/6.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LineDrawView.h"

@implementation LineDrawView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.touchesArray = [[NSMutableArray alloc]initWithCapacity:0];
        self.touchedArray = [[NSMutableArray alloc]initWithCapacity:0];
        [self setBackgroundColor:[UIColor clearColor]];
        //[self setUserInteractionEnabled:YES];
        self.success = 1;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //    if (touchesArray.count<2)return;
    for (int i=0; i<self.touchesArray.count; i++) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (![[self.touchesArray objectAtIndex:i] objectForKey:@"num"]) { //防止过快滑动产生垃圾数据
            [self.touchesArray removeObjectAtIndex:i];
            continue;
        }
        //        if (success) {
        //            CGContextSetRGBStrokeColor(context, 2/255.f, 174/255.f, 240/255.f, 0.7);//线条颜色
        //        }
        //        else {
        //            CGContextSetRGBStrokeColor(context, 208/255.f, 36/255.f, 36/255.f, 0.7);//红色
        //        }
        
        if (self.success) {
            //CGContextSetRGBStrokeColor(context, 234/255.f, 85/255.f, 4/255.f, 1.0);//线条颜色
            CGContextSetRGBStrokeColor(context, 248/255.f, 61/255.f, 27/255.f, 1.0);//线条颜色
        }
        else {
            CGContextSetRGBStrokeColor(context, 248/255.f, 61/255.f, 27/255.f, 1.0);//红色
        }
        
        
        CGContextSetLineWidth(context,1.5);
        CGContextMoveToPoint(context, [[[self.touchesArray objectAtIndex:i] objectForKey:@"x"] floatValue], [[[self.touchesArray objectAtIndex:i] objectForKey:@"y"] floatValue]);
        if (i<self.touchesArray.count-1) {
            CGContextAddLineToPoint(context, [[[self.touchesArray objectAtIndex:i+1] objectForKey:@"x"] floatValue],[[[self.touchesArray objectAtIndex:i+1] objectForKey:@"y"] floatValue]);
        }
        else{
            if (self.success) {
                CGContextAddLineToPoint(context, self.lineEndPoint.x,self.lineEndPoint.y);
            }
        }
        CGContextStrokePath(context);
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
