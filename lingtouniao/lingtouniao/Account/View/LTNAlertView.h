//
//  LTNAlertView.h
//  lingtouniao
//
//  Created by LiuFeifei on 16/1/9.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LTNAlertView;

@protocol LTNAlertViewDelegate <NSObject>

- (void)alertView:(LTNAlertView *)alertView clickedButtonAtIndex:(NSInteger)index;

@end

@interface LTNAlertView : UIView

@property (nonatomic, weak) id<LTNAlertViewDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle;
- (void)show;

- (void)showToView:(UIView *)view;
- (void)showToController:(UIViewController *)viewController;

@end
