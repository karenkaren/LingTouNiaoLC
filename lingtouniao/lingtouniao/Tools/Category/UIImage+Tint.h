//
//  UIImage+Tint.h
//  DasIos
//
//  Created by ztkztk on 15-1-5.
//  Copyright (c) 2015年 Benjamin Gordon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tint)
- (UIImage *) imageWithTintColor:(UIColor *)tintColor;
- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor;
@end
