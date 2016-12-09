//
//  GoldenEggView.h
//  lingtouniao
//
//  Created by 徐凯 on 16/2/18.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface GoldenEggButton : UIView {
    BOOL _isDragging;
    BOOL _singleTapBeenCanceled;
    CGPoint _beginLocation;
}
@property (nonatomic) BOOL autoDocking;

@property (nonatomic, copy) void(^tapBlock)(GoldenEggButton *button);

- (instancetype)initInView:(UIView *)view WithFrame:(CGRect)frame;
- (instancetype)initInView:(UIView *)view;

- (void)startShake;
- (void)stopShake;

@end
