//
//  LTNPromptView.h
//  lingtouniao
//
//  Created by LiuFeifei on 15/12/3.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTNPromptView : UIView

@property (nonatomic, assign) BOOL allowUserInteraction;

+ (instancetype)promptWithIcon:(NSString *)iconName iconSpace:(CGFloat)space Text:(NSString *)text font:(UIFont *)font textWidth:(CGFloat)textMaxWidth;

@end
