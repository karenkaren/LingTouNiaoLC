//
//  BankBoundTextField.m
//  lingtouniao
//
//  Created by 徐凯 on 16/1/7.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "BankBoundTextField.h"

@implementation BankBoundTextField

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    return CGRectMake(20, bounds.origin.y, 80,bounds.size.height);

}

@end