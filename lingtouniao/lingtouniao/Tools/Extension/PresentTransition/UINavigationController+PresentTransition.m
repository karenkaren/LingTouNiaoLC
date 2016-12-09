//
//  UINavigationController+PresentTransition.m
//  lingtouniao
//
//  Created by zhangtongke on 16/3/11.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "UINavigationController+PresentTransition.h"

@implementation UINavigationController (PresentTransition)

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0){
        self.transitioningDelegate = self;
        self.modalPresentationStyle =  UIModalPresentationCustom;
    }
    
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [PresentTransition transitionWithType:TransitionPresent duration:0.5];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [PresentTransition transitionWithType:TransitionDismiss duration:0.25];
}

@end
