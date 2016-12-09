//
//  RechargeTextField.h
//  lingtouniao
//
//  Created by 徐凯 on 15/12/28.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RechargeTextField : UITextField

-(void)addLeftViewWithTitle:(NSString *)title leftMargin:(CGFloat)leftMargin leftWidth:(CGFloat)leftWidth leftViewMode:(UITextFieldViewMode)leftViewMode;

@end
