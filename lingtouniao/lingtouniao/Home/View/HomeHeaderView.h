//
//  HomeHeaderView.h
//  lingtouniao
//
//  Created by LiuFeifei on 16/5/20.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTNAcitonBar.h"

#define kPlatformRegisterNum @"platformRegisterNum"
#define kPlatformAllAmount @"platformAllAmount"
#define kSumRevenue @"sumRevenue"

@protocol HomeHeaderViewDelegate <NSObject>

- (void)clickAcitonBar:(LTNAcitonBar *)acitonBar clickedItemIndex:(NSInteger)index;
- (void)clickCheckDetail:(UIButton *)button;

@end

@interface HomeHeaderView : UIView

@property (nonatomic, weak) id<HomeHeaderViewDelegate> delegate;
+ (HomeHeaderView *)getHomeHeaderViewWithTarget:(id<HomeHeaderViewDelegate>)target;

@end
