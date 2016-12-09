//
//  LTNBaseSlideViewController.h
//  lingtouniao
//
//  Created by LiuFeifei on 16/2/22.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "BaseViewController.h"

@interface LTNBaseSlideViewController : BaseViewController

@property (nonatomic, strong) NSArray * viewControllers;
- (void)slideSwitchViewWithSelectTab:(NSUInteger)number;

@end
