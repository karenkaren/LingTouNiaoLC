//
//  UINavTitleLabel.m
//  5coins
//
//  Created by Zhu Yuzhou on 10/1/12.
//  Copyright (c) 2012 zhuyuzhou. All rights reserved.
//

#import "UINavTitleLabel.h"
#import <QuartzCore/QuartzCore.h>

@implementation UINavTitleLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.font = [UIFont systemFontOfSize:18.0f];
        self.adjustsFontSizeToFitWidth = YES;
        self.minimumScaleFactor = 15.0;
        self.textAlignment = NSTextAlignmentCenter;
        self.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.textColor = [UIColor blackColor]; // change this color
    }
    return self;
}


@end
