//
//  LTNListTabBar.h
//  lingtouniao
//
//  Created by 郑程锋 on 16/3/18.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LTNListTabBar;
@protocol LTNListTabBarDelegate <NSObject>

@optional
/**
 *  tabBar选中当前item的代理方法
 */
- (void)listTabBar:(LTNListTabBar *)listTabBar didSelectedItemIndex:(NSInteger)index;

@end


@interface LTNListTabBar : UIView

@property (nonatomic, weak) id <LTNListTabBarDelegate>delegate;

/**
 *  tabBar当前选中的item的索引
 */
@property (nonatomic, assign) NSInteger currentItemIndex;

/**
 *  tabBar上所有要显示的item标题
 */
@property (nonatomic, strong) NSArray *itemsTitle;




@end
