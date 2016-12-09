//
//  LoginPaddingUITextField.m
//  lingtouniao
//
//  Created by 徐凯 on 15/12/23.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LoginPaddingUITextField.h"

@implementation LoginPaddingUITextField

-(CGRect) leftViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 10;// 右偏10
    return iconRect;
}

@end
