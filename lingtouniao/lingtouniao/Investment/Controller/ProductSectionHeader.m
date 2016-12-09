//
//  ProductSectionHeader.m
//  lingtouniao
//
//  Created by zhangtongke on 16/3/23.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "ProductSectionHeader.h"

@implementation ProductSectionHeader
-(id)init{
    self=[super init];
    if(self){
        self.frame = CGRectMake(0,0,kScreenWidth,30);
        self.backgroundColor = [UIColor colorWithHexString:@"#f3f5f7"];
        _titleLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        
        _titleLabel.centerX=self.width/2;
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setFont:[UIFont systemFontOfSize:14.f]];
        [self addSubview:_titleLabel];
        [_titleLabel setTextColor:[UIColor blackColor]];
        
    }
    
    return self;
    
}

-(void)setTitle:(NSString *)title{
    _titleLabel.text=title;
    [_titleLabel sizeToFit];
    _titleLabel.center=CGPointMake(self.width/2, self.height/2);
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 底部bar
    [kRGBColor(236, 236, 236) set];
    CGContextSetLineWidth(context, 0.5);
    CGContextMoveToPoint(context, DimensionBaseIphone6(15), self.height * 0.5);
    CGContextAddLineToPoint(context, self.width/2-_titleLabel.width/2-DimensionBaseIphone6(15), self.height * 0.5);
    
    
    CGContextMoveToPoint(context, self.width/2+_titleLabel.width/2+DimensionBaseIphone6(15), self.height * 0.5);
    CGContextAddLineToPoint(context, self.width-DimensionBaseIphone6(15), self.height * 0.5);
    
    
    CGContextStrokePath(context);
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
