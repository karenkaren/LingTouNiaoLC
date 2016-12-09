//
//  HeardView.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/6/12.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "HeardView.h"

@implementation HeardView


-(id)init{
    self=[super init];
    if(self){
        self.frame = CGRectMake(0,0,kScreenWidth,30);


        _titleLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        
        _titleLabel.centerX=self.width/2;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font =  [CustomerizedFont heiti:14];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#3C3C3C"];
        [self addSubview:_titleLabel];
       
        [self setUI];
       
       
        
    }
    
    return self;
    
}

-(void)setTitle:(NSString *)title{
    _titleLabel.text=title;
    [_titleLabel sizeToFit];
    _titleLabel.center=CGPointMake(self.width/2, self.height/2);
    [self setNeedsDisplay];
    DLog(@"..................................%@",NSStringFromCGRect( _titleLabel.frame));
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(_titleLabel.left - 15, (self.height - 12)/2, 12, 12)];
    imageView.image = [UIImage imageNamed:@"icon_help"];
    [self addSubview:imageView];
}
- (void)setUI{
    
        UIView *circleView1 = [[UIView alloc]initWithFrame:CGRectMake(31, self.height/2 - 3, 6, 6)];
        circleView1.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
        circleView1.layer.cornerRadius = 3;
        circleView1.layer.masksToBounds = YES;
        [self addSubview:circleView1];
        self.circleView1 = circleView1;
        
        UIView *circleView2 = [[UIView alloc]initWithFrame:CGRectMake(self.width - 31 - 9, self.height/2 - 3, 6, 6)];
        circleView2.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
        circleView2.layer.cornerRadius = 3;
        circleView2.layer.masksToBounds = YES;
        [self addSubview:circleView2];
        self.circleView2 = circleView2;
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(circleView1.right, self.height/2, self.width/2 - 42 - 40 - 20, 0.5)];
        line1.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
        [self addSubview:line1];
        self.line1 = line1;
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(circleView2.left, self.height/2, -(self.width/2 - 41 - 40 - 20), 0.5)];
        line2.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];   
        [self addSubview:line2];
        self.line2 = line2;
    
}
//- (void)drawRect:(CGRect)rect{
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    // 底部bar
//    [[UIColor redColor] set];
//    CGContextSetLineWidth(context, 0.5);
//    CGContextMoveToPoint(context, DimensionBaseIphone6(15), self.height * 0.5);
//    CGContextAddLineToPoint(context, self.width/2-_titleLabel.width/2-DimensionBaseIphone6(15), self.height * 0.5);
//    
//    
//    CGContextMoveToPoint(context, self.width/2+_titleLabel.width/2+DimensionBaseIphone6(15), self.height * 0.5);
//    CGContextAddLineToPoint(context, self.width-DimensionBaseIphone6(15), self.height * 0.5);
//    
//    
//    CGContextStrokePath(context);
//    
//    
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
