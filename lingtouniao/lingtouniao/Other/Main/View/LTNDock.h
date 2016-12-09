//
//  LTNDock.h
//  lingtouniao
//
//  Created by LiuFeifei on 15/11/11.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTNDockItem.h"

@class LTNDock;

@protocol LTNDockDelegate <NSObject>

@optional
- (void)dock:(LTNDock *)dock itemSelectedFrom:(NSUInteger)fromIndex to:(NSUInteger)toIndex;

@end

@interface LTNDock : UIView

@property (nonatomic, weak) id<LTNDockDelegate> delegate;

- (void)addDockItemWithIcon:(NSString *)icon selectedIcon:(NSString *)selectedIcon title:(NSString *)title;
- (void)clickItem:(LTNDockItem *)item;

@end
