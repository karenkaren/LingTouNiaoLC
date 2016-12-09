//
//  CheckBox.m
//  lingtouniao
//
//  Created by 徐凯 on 15/12/17.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "CheckBox.h"

@implementation CheckBox

-(id)init
{
    self = [super init];
    if (self) {
        
        _isSelected = false;
        [self setEnlargeEdge:10];
        [self addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _isSelected = false;
        [self setEnlargeEdge:10];
        [self addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;

}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        _isSelected = false;
        [self setBackgroundImage:[UIImage imageNamed:@"checked_single"] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;

}

-(void)onClicked:(id)sender
{
    [self setIsSelected:!_isSelected];
}

-(void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    
    if (_isSelected) {
        [self setBackgroundImage:[UIImage imageNamed:@"checked_single"] forState:UIControlStateNormal];
    }
    else
    {
        [self setBackgroundImage:[UIImage imageNamed:@"unchecked_single"] forState:UIControlStateNormal];
    }
    
}

@end
