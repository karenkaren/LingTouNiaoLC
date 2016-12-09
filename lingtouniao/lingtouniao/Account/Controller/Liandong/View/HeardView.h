//
//  HeardView.h
//  lingtouniao
//
//  Created by 郑程锋 on 16/6/12.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeardView : UIView
@property (nonatomic,strong)UILabel *titleLabel;

-(void)setTitle:(NSString *)title;

@property (nonatomic) UIView *circleView1;
@property (nonatomic) UIView *circleView2;
@property (nonatomic) UIView *line1;
@property (nonatomic) UIView *line2;

@end
