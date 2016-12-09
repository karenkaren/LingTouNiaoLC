//
//  LTNDockItem.m
//  lingtouniao
//
//  Created by LiuFeifei on 15/11/11.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNDockItem.h"

// 文字的高度比例
#define kTitleRatio 0.3

@implementation LTNDockItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 2.文字大小
        self.titleLabel.font = kFont(12);
        // 3.图片的内容模式
        self.imageView.contentMode = UIViewContentModeCenter;
        [self setTitleColor:kRGBColor(116, 116, 116) forState:UIControlStateNormal];
        [self setTitleColor:kHexColor(@"#ea5504") forState:UIControlStateSelected];
        // 4.设置选中时的背景
//        [self setBackgroundImage:[UIImage imageNamed:@"tabbar_slider"] forState:UIControlStateSelected];
    }
    return self;
}

#pragma mark 调整内部ImageView的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageWidth = contentRect.size.width;
    CGFloat imageHeight = contentRect.size.height * (1 - kTitleRatio);
    
    return CGRectMake(imageX, imageY, imageWidth, imageHeight);
}

#pragma mark 调整内部UILabel的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleY = contentRect.size.height * (1 - kTitleRatio);
    CGFloat titleWidth = contentRect.size.width;
    CGFloat titleHeight = contentRect.size.height * kTitleRatio;
    
    return CGRectMake(titleX, titleY, titleWidth, titleHeight);
}

@end
