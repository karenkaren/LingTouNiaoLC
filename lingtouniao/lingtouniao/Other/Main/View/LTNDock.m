//
//  LTNDock.m
//  lingtouniao
//
//  Created by LiuFeifei on 15/11/11.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNDock.h"

@interface LTNDock ()

@property (nonatomic, strong) LTNDockItem * selectedItem;
@property (nonatomic, assign) NSUInteger selectedItemIndex;

@end

@implementation LTNDock

- (void)addDockItemWithIcon:(NSString *)icon selectedIcon:(NSString *)selectedIcon title:(NSString *)title
{
    LTNDockItem * item = [[LTNDockItem alloc] init];
    [item setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [item setImage:[UIImage imageNamed:selectedIcon] forState:UIControlStateSelected];
    [item setTitle:title forState:UIControlStateNormal];
    [item addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:item];
    
    NSUInteger count = self.subviews.count;
    
    // 默认选中第一个
    if (count == 1) {
        [self clickItem:item];
    }
    
    // 调整frame
    for (int i = 0; i < count; i++) {
        LTNDockItem * item = self.subviews[i];
        item.tag = i;
        CGFloat width = 1.0 * self.bounds.size.width / count;
        CGFloat height = self.bounds.size.height;
        item.frame = CGRectMake(i * width, 0, width, height);
    }
}

- (void)clickItem:(LTNDockItem *)item
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dock:itemSelectedFrom:to:)]) {
        [self.delegate dock:self itemSelectedFrom:self.selectedItemIndex to:item.tag];
    }
    
    self.selectedItem.selected = !self.selectedItem.selected;
    item.selected = !item.selected;
    self.selectedItem = item;
    
    self.selectedItemIndex = item.tag;
}

@end
