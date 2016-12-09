//
//  DetailButton.h
//  lingtouniao
//
//  Created by LiuFeifei on 16/5/27.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailButton : UIView

@property (nonatomic, strong) UILabel * titleLabel;

+ (DetailButton *)creatDetailButtonWithTitle:(NSString *)title rightImage:(UIImage *)rightImage handle:(ESHandlerBlock)handleBlock;

@end
