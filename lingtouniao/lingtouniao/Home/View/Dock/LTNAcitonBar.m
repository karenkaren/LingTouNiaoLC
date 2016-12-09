//
//  LTNAcitonBar.m
//  lingtouniao
//
//  Created by LiuFeifei on 15/11/18.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNAcitonBar.h"
#import "LTNActionItem.h"

@implementation LTNAcitonBar

- (void)addActionItemWithIcon:(NSString *)icon selectedIcon:(NSString *)selectedIcon title:(NSString *)title
{
    LTNActionItem * item = [[LTNActionItem alloc] init];
    [item setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [item setImage:[UIImage imageNamed:selectedIcon] forState:UIControlStateSelected];
    [item setTitle:title forState:UIControlStateNormal];
    [item addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:item];
    
    NSUInteger count = self.subviews.count;
    
    // 调整frame
    for (int i = 0; i < count; i++) {
        LTNActionItem * item = self.subviews[i];
        item.tag = i;
        CGFloat width = 1.0 * self.bounds.size.width / count;
        CGFloat height = self.bounds.size.height;
        item.frame = CGRectMake(i * width, 0, width, height);
    }
}

- (void)clickItem:(LTNActionItem *)item
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(acitonBar:clickedItemIndex:)]) {
        [self.delegate acitonBar:self clickedItemIndex:item.tag];
    }
}

- (void)setShowSeparator:(BOOL)showSeparator
{
    _showSeparator = showSeparator;
    if (showSeparator) {
        NSUInteger count = self.subviews.count;
        CGFloat itemWidth = self.bounds.size.width / count;
        CGFloat separatorTop = 11;
        for (int i = 0; i < count - 1; i++) {
            UIView * separatorView = [[UIView alloc] initWithFrame:CGRectMake(itemWidth * (i + 1), separatorTop, 1.0 / [UIScreen mainScreen].scale, self.bounds.size.height - 2 * separatorTop)];
            separatorView.backgroundColor = HexRGB(0xe5e5e5);
            [self addSubview:separatorView];
        }
    }
}

@end
