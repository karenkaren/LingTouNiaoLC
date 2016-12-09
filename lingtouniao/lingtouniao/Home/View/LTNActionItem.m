//
//  LTNActionItem.m
//  lingtouniao
//
//  Created by LiuFeifei on 15/12/16.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNActionItem.h"

#define kImageRatio 0.5
#define kTitleRatio 0.06

@implementation LTNActionItem


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 1.文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 2.文字大小
        self.titleLabel.font = [CustomerizedFont heiti:12];
        // 3.图片的内容模式
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self setTitleColor:HexRGB(0x666666) forState:UIControlStateNormal];
    }
    return self;
}

#pragma mark 调整内部ImageView的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageY = DimensionBaseIphone6(11);
    CGFloat imageWidth = DimensionBaseIphone6(33.0);
    CGFloat imageHeight = DimensionBaseIphone6(33.0);
    
    return CGRectMake(self.width/2-imageWidth/2, imageY, imageWidth, imageHeight);
}

#pragma mark 调整内部UILabel的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleHeight = contentRect.size.height * 0.2;
    CGFloat titleY = contentRect.size.height - DimensionBaseIphone6(10) - titleHeight;
    CGFloat titleWidth = contentRect.size.width;
    
    return CGRectMake(titleX, titleY, titleWidth, titleHeight);
}

@end
