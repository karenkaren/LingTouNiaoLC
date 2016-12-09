//
//  RechargeTextField.m
//  lingtouniao
//
//  Created by 徐凯 on 15/12/28.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "RechargeTextField.h"

@implementation RechargeTextField


//控制placeHolder的位置
//-(CGRect)placeholderRectForBounds:(CGRect)bounds
//{
//    return CGRectMake( bounds.size.width - bounds.origin.x-125*kScreenWidth/375, bounds.origin.y, bounds.size.width , bounds.size.height);
//   
//}

-(void)addLeftViewWithTitle:(NSString *)title leftMargin:(CGFloat)leftMargin leftWidth:(CGFloat)leftWidth leftViewMode:(UITextFieldViewMode)leftViewMode
{
    // 左边View
    UIView * leftView = [[UIImageView alloc] init];
    
    // 设置尺寸
    CGRect leftViewBounds = self.bounds;
    // 宽度高度一样
    leftViewBounds.size.width = leftWidth;
    leftView.bounds = leftViewBounds;
    
    // 左图label
    UILabel * leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, 0, leftWidth - leftMargin, leftViewBounds.size.height)];
    leftLabel.textColor = [UIColor colorWithHexString:@"#3a3a3a"];
    leftLabel.font = [CustomerizedFont heiti:14];
    leftLabel.text = title;
    [leftView addSubview:leftLabel];
    
    // 添加TextFiled的左边视图
    self.leftView = leftView;
    
    // 设置TextField左边的总是显示
    self.leftViewMode = leftViewMode;
}


@end
