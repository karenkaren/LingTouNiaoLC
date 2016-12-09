//
//  MBProgressHUD+ShowController.h
//  lingtouniao
//
//  Created by zhangtongke on 16/4/27.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (ShowController)

/**
 *  @brief  添加一个带菊花的HUD
 *
 *  @param view  目标view
 *  @param title 标题
 *
 *  @return MBProgressHUD
 */
+ (MBProgressHUD *)bwm_showHUDAddedToController:(UIViewController *)viewController title:(NSString *)title;
/** 添加一个带菊花的HUD */
+ (MBProgressHUD *)bwm_showHUDAddedToController:(UIViewController *)viewController
                                title:(NSString *)title
                             animated:(BOOL)animated;

@end
