//
//  TentacleView.m
//  GesturePassword
//
//  Created by hb on 14-8-23.
//  Copyright (c) 2014年 黑と白の印记. All rights reserved.
//

#import "TentacleView.h"
#import "GesturePasswordButton.h"


@implementation TentacleView {
//    CGPoint lineStartPoint;
//    CGPoint lineEndPoint;
//    
//    NSMutableArray * touchesArray;
//    NSMutableArray * touchedArray;
//    BOOL success;
}
@synthesize buttonArray;
@synthesize rerificationDelegate;
@synthesize resetDelegate;
@synthesize touchBeginDelegate;
@synthesize style;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        touchesArray = [[NSMutableArray alloc]initWithCapacity:0];
//        touchedArray = [[NSMutableArray alloc]initWithCapacity:0];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        //success = 1;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint touchPoint;
    UITouch *touch = [touches anyObject];
    [self.lineView.touchesArray removeAllObjects];
    [self.lineView.touchedArray removeAllObjects];
    [touchBeginDelegate gestureTouchBegin];
    self.lineView.success=1;
    if (touch) {
        touchPoint = [touch locationInView:self];
        for (int i=0; i<buttonArray.count; i++) {
            GesturePasswordButton * buttonTemp = ((GesturePasswordButton *)[buttonArray objectAtIndex:i]);
            [buttonTemp setSuccess:YES];
            [buttonTemp setSelected:NO];
            if (CGRectContainsPoint(buttonTemp.frame,touchPoint)) {
                CGRect frameTemp = buttonTemp.frame;
                CGPoint point = CGPointMake(frameTemp.origin.x+frameTemp.size.width/2,frameTemp.origin.y+frameTemp.size.height/2);
                NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",point.x],@"x",[NSString stringWithFormat:@"%f",point.y],@"y", nil];
                [self.lineView.touchesArray addObject:dict];
                self.lineView.lineStartPoint = touchPoint;
            }
            [buttonTemp setNeedsDisplay];
        }
        
        [self.lineView setNeedsDisplay];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint touchPoint;
    UITouch *touch = [touches anyObject];
    if (touch) {
        touchPoint = [touch locationInView:self];
        for (int i=0; i<buttonArray.count; i++) {
            GesturePasswordButton * buttonTemp = ((GesturePasswordButton *)[buttonArray objectAtIndex:i]);
            if (CGRectContainsPoint(buttonTemp.frame,touchPoint)) {
                if ([self.lineView.touchedArray containsObject:[NSString stringWithFormat:@"num%d",i]]) {
                    self.lineView.lineEndPoint = touchPoint;
                    [self.lineView setNeedsDisplay];
                    return;
                }
                [self.lineView.touchedArray addObject:[NSString stringWithFormat:@"num%d",i]];
                [buttonTemp setSelected:YES];
                [buttonTemp setNeedsDisplay];
                CGRect frameTemp = buttonTemp.frame;
                CGPoint point = CGPointMake(frameTemp.origin.x+frameTemp.size.width/2,frameTemp.origin.y+frameTemp.size.height/2);
                NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",point.x],@"x",[NSString stringWithFormat:@"%f",point.y],@"y",[NSString stringWithFormat:@"%d",i],@"num", nil];
                [self.lineView.touchesArray addObject:dict];
                break;
            }
        }
        self.lineView.lineEndPoint = touchPoint;
        [self.lineView setNeedsDisplay];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSMutableString * resultString=[NSMutableString string];
    for ( NSDictionary * num in self.lineView.touchesArray ){
        if(![num objectForKey:@"num"])break;
        [resultString appendString:[num objectForKey:@"num"]];
    }
    if(style==1){
        self.lineView.success = [rerificationDelegate verification:resultString];
    }
    else {
        self.lineView.success = [resetDelegate resetPassword:resultString];
    }
    
    for (int i=0; i<self.lineView.touchesArray.count; i++) {
        NSInteger selection = [[[self.lineView.touchesArray objectAtIndex:i] objectForKey:@"num"]intValue];
        GesturePasswordButton * buttonTemp = ((GesturePasswordButton *)[buttonArray objectAtIndex:selection]);
        [buttonTemp setSuccess:self.lineView.success];
        [buttonTemp setNeedsDisplay];
    }
    [self.lineView setNeedsDisplay];
}

//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    // Drawing code
////    if (touchesArray.count<2)return;
//    for (int i=0; i<touchesArray.count; i++) {
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        if (![[touchesArray objectAtIndex:i] objectForKey:@"num"]) { //防止过快滑动产生垃圾数据
//            [touchesArray removeObjectAtIndex:i];
//            continue;
//        }
////        if (success) {
////            CGContextSetRGBStrokeColor(context, 2/255.f, 174/255.f, 240/255.f, 0.7);//线条颜色
////        }
////        else {
////            CGContextSetRGBStrokeColor(context, 208/255.f, 36/255.f, 36/255.f, 0.7);//红色
////        }
//        
//        if (success) {
//            //CGContextSetRGBStrokeColor(context, 234/255.f, 85/255.f, 4/255.f, 1.0);//线条颜色
//            CGContextSetRGBStrokeColor(context, 160/255.f, 42/255.f, 21/255.f, 1.0);//线条颜色
//        }
//        else {
//            CGContextSetRGBStrokeColor(context, 160/255.f, 42/255.f, 21/255.f, 1.0);//红色
//        }
//
//        
//        CGContextSetLineWidth(context,3);
//        CGContextMoveToPoint(context, [[[touchesArray objectAtIndex:i] objectForKey:@"x"] floatValue], [[[touchesArray objectAtIndex:i] objectForKey:@"y"] floatValue]);
//        if (i<touchesArray.count-1) {
//            CGContextAddLineToPoint(context, [[[touchesArray objectAtIndex:i+1] objectForKey:@"x"] floatValue],[[[touchesArray objectAtIndex:i+1] objectForKey:@"y"] floatValue]);
//        }
//        else{
//            if (success) {
//                CGContextAddLineToPoint(context, lineEndPoint.x,lineEndPoint.y);
//            }
//        }
//        CGContextStrokePath(context);
//    }
//}

- (void)enterArgin {
    [self.lineView.touchesArray removeAllObjects];
    [self.lineView.touchedArray removeAllObjects];
    for (int i=0; i<buttonArray.count; i++) {
        GesturePasswordButton * buttonTemp = ((GesturePasswordButton *)[buttonArray objectAtIndex:i]);
        [buttonTemp setSelected:NO];
        [buttonTemp setSuccess:YES];
        [buttonTemp setNeedsDisplay];
    }
    
    [self.lineView setNeedsDisplay];
}

@end
