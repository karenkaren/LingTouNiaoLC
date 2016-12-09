//
//  LTNAcitonBar.h
//  lingtouniao
//
//  Created by LiuFeifei on 15/11/18.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LTNAcitonBar;

@protocol LTNAcitonBarDelegate <NSObject>

@optional
- (void)acitonBar:(LTNAcitonBar *)acitonBar clickedItemIndex:(NSInteger)index;

@end

@interface LTNAcitonBar : UIView

@property (nonatomic, weak) id<LTNAcitonBarDelegate> delegate;
- (void)addActionItemWithIcon:(NSString *)icon selectedIcon:(NSString *)selectedIcon title:(NSString *)title;
@property (nonatomic, assign) BOOL showSeparator;

@end
