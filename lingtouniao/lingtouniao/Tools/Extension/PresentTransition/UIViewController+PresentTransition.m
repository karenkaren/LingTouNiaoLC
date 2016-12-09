//
//  UIViewController+PresentTransition.m
//  lingtouniao
//
//  Created by zhangtongke on 16/3/11.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "UIViewController+PresentTransition.h"


@implementation UIViewController (PresentTransition)


-(void)setCustomPresentTransition{
    self.transitioningDelegate = self;
        self.modalPresentationStyle =  UIModalPresentationCustom;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
//-(void)loadView{
//        self.transitioningDelegate = self;
//        self.modalPresentationStyle =  UIModalPresentationCustom;
//}
#pragma clang diagnostic pop
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    
//    // 配置一下代理防呈现样式为自定义
//    self.transitioningDelegate = self;
//    self.modalPresentationStyle =  UIModalPresentationCustom;
//}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [PresentTransition transitionWithType:TransitionPresent duration:0.5];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [PresentTransition transitionWithType:TransitionDismiss duration:0.25];
}



@end
