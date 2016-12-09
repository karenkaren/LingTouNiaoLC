//
//  PresentTransition.m
//  lingtouniao
//
//  Created by zhangtongke on 16/3/11.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "PresentTransition.h"

@interface PresentTransition ()

@property (nonatomic, assign) PresentTransitionType type;
@property (nonatomic, assign) NSTimeInterval duration;

@end

@implementation PresentTransition

+ (PresentTransition *)transitionWithType:(PresentTransitionType)type
                                  duration:(NSTimeInterval)duration{
    PresentTransition *transition = [[PresentTransition alloc] init];
    
    transition.type = type;
    transition.duration = duration;
    
    return transition;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (void)animationEnded:(BOOL)transitionCompleted {
    NSLog(@"%s", __FUNCTION__);
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    switch (self.type) {
        case TransitionPresent: {
            [self present:transitionContext];
            break;
        }
        case TransitionDismiss: {
            [self dismiss:transitionContext];
            break;
        }
        default: {
            break;
        }
    }
}

#pragma mark - Private
- (void)present:(id<UIViewControllerContextTransitioning>)transitonContext {
    UIViewController *fromVC = [transitonContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitonContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect finalFrame = [transitonContext finalFrameForViewController:toVC];
    UIView *containerView = [transitonContext containerView];
   // fromVC.view.hidden = YES;
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    [containerView addSubview:toVC.view];
    toVC.view.frame = CGRectOffset(finalFrame,screenBounds.size.width , 0);
    
    NSTimeInterval duration = [self transitionDuration:transitonContext];
    [UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:0 animations:^{
        
        toVC.view.frame = finalFrame;
        } completion:^(BOOL finished) {
        [transitonContext completeTransition:YES];
    }];
}

- (void)dismiss:(id<UIViewControllerContextTransitioning>)transitonContext {
    // 1. Get controllers from transition context
    UIViewController *fromVC = [transitonContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitonContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // 2. Set init frame for fromVC
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect initFrame = [transitonContext initialFrameForViewController:fromVC];
    CGRect finalFrame = CGRectOffset(initFrame,screenBounds.size.width, 0);
    
    // 3. Add target view to the container, and move it to back.
    UIView *containerView = [transitonContext containerView];
   // [containerView addSubview:toVC.view];
   // [containerView sendSubviewToBack:toVC.view];
    
    // 4. Do animate now
    NSTimeInterval duration = [self transitionDuration:transitonContext];
    [UIView animateWithDuration:duration animations:^{
        fromVC.view.frame = finalFrame;
    } completion:^(BOOL finished) {
        [transitonContext completeTransition:![transitonContext transitionWasCancelled]];
    }];
}


@end
