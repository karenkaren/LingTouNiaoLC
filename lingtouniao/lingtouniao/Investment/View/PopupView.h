//
//  PopupView.h
//  lingtouniao
//
//  Created by LiuFeifei on 16/2/19.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupView : UIView

- (instancetype)initWithPrompt:(NSString *)prompt attributes:(NSDictionary *)attributes inView:(UIView *)view fromRect:(CGRect)fromRect;

@end
