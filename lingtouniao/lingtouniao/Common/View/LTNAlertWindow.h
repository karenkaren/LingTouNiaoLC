//
//  LTNAlertWindow.h
//  lingtouniao
//
//  Created by zhangtongke on 16/2/24.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTNAlertWindow : UIWindow
/// app原来的keyWindow
@property (nonatomic, retain, readonly) UIWindow *appKeyWindow;

+ (instancetype)sharedWindow;

/**
 * 将view addSubView到alertWindow上面，然后显示。
 *
 * @param view 要显示的view
 */
- (void)showView:(UIView *)view;
/**
 * 移除view并隐藏自己，如果alertView上面还有其他试图，不会影响其他试图的显示.
 *
 * @param view 要影藏的view
 */
- (void)dismissView:(UIView *)view;
/**
 * Dismiss所有由此alertWindow显示的View
 */
- (void)dismissAll;

/**
 * rootViewController
 */
- (void)showRootViewController:(UIViewController *)rootController;
- (void)dismissRootController;


/**
 * Sigleton
 */
+ (id)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
- (id)init __attribute__((unavailable("init not available, call sharedInstance instead")));
+ (id)new __attribute__((unavailable("new not available, call sharedInstance instead")));


@end
