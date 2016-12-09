//
//  MBProgressHUD+ShowController.m
//  lingtouniao
//
//  Created by zhangtongke on 16/4/27.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "MBProgressHUD+ShowController.h"

@implementation MBProgressHUD (ShowController)

/**
 *  @brief  添加一个带菊花的HUD
 *
 *  @param view  目标view
 *  @param title 标题
 *
 *  @return MBProgressHUD
 */
+ (MBProgressHUD *)bwm_showHUDAddedToController:(UIViewController *)viewController title:(NSString *)title{
    MBProgressHUD *HUD;
    if(viewController.tabBarController){
        HUD = [MBProgressHUD bwm_showHUDAddedTo:viewController.tabBarController.view title:title];
    }else if(viewController.navigationController){
        HUD = [MBProgressHUD bwm_showHUDAddedTo:viewController.navigationController.view title:title];
    }else{
        HUD = [MBProgressHUD bwm_showHUDAddedTo:viewController.view title:title];
    }
    
    return HUD;
    
}
/** 添加一个带菊花的HUD */
+ (MBProgressHUD *)bwm_showHUDAddedToController:(UIViewController *)viewController
                                          title:(NSString *)title
                                       animated:(BOOL)animated{
    MBProgressHUD *HUD;
    if(viewController.tabBarController){
        HUD = [MBProgressHUD bwm_showHUDAddedTo:viewController.tabBarController.view title:title animated:animated];
    }else if(viewController.navigationController){
        HUD = [MBProgressHUD bwm_showHUDAddedTo:viewController.navigationController.view title:title animated:animated];
    }else{
        HUD = [MBProgressHUD bwm_showHUDAddedTo:viewController.view title:title animated:animated];
    }
    
    return HUD;

    
}

@end
