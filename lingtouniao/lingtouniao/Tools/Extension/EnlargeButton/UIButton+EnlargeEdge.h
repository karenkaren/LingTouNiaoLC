//
//  UIButton+EnlargeEdge.h
//  IMHere
//
//  Created by ztkztk on 15/9/1.
//  Copyright (c) 2015年 liaozi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <objc/runtime.h>

@interface UIButton (EnlargeEdge)
- (void)setEnlargeEdge:(CGFloat) size;
- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;
@end

