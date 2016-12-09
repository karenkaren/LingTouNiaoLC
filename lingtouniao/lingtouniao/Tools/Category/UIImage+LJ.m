//
//  UIImage+LJ.m
//  lingtouniao
//
//  Created by LiuFeifei on 15/11/30.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "UIImage+LJ.h"

@implementation UIImage (LJ)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
