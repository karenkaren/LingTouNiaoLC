//
//  UIViewController+PresentTransition.h
//  lingtouniao
//
//  Created by zhangtongke on 16/3/11.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PresentTransition.h"


@interface UIViewController (PresentTransition)<UIViewControllerTransitioningDelegate>
-(void)setCustomPresentTransition;

@end
