//
//  PresentTransition.h
//  lingtouniao
//
//  Created by zhangtongke on 16/3/11.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PresentTransitionType) {
    TransitionPresent = 1 << 1,
    TransitionDismiss = 1 << 2
};


@interface PresentTransition : NSObject<UIViewControllerAnimatedTransitioning>

+ (PresentTransition *)transitionWithType:(PresentTransitionType)type
                                  duration:(NSTimeInterval)duration;

@end
