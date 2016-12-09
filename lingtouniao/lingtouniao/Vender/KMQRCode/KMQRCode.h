//
//  KMQRCode.h
//  lingtouniao
//
//  Created by 徐凯 on 16/1/21.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMQRCode : NSObject

 + (CIImage *)createQRCodeImage:(NSString *)source;
 + (UIImage *)resizeQRCodeImage:(CIImage *)image withSize:(CGFloat)size;
 + (UIImage *)specialColorImage:(UIImage*)image withRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
 + (UIImage *)addIconToQRCodeImage:(UIImage *)image withIcon:(UIImage *)icon withIconSize:(CGSize)iconSize;
 + (UIImage *)addIconToQRCodeImage:(UIImage *)image withIcon:(UIImage *)icon withScale:(CGFloat)scale;

@end
