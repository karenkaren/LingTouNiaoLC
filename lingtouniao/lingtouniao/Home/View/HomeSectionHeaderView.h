//
//  HomeSectionHeaderView.h
//  lingtouniao
//
//  Created by LiuFeifei on 16/5/20.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoldenEggButton.h"

#define kSectionHeight DimensionBaseIphone6(50)
#define kDefaultSectionHeight DimensionBaseIphone6(10)

@protocol HomeSectionHeaderViewDelegate <NSObject>

- (void)startShowGoldenEggs;

@end

@interface HomeSectionHeaderView : UIView

+ (HomeSectionHeaderView *)getHomeSectionHeaderViewWithTitle:(NSString *)title;

@property (nonatomic, weak) id<HomeSectionHeaderViewDelegate> delegate;
@property (nonatomic, strong) GoldenEggButton * avatar;
@property (nonatomic, assign) BOOL showAction;
@property (nonatomic, strong) UIButton *goldenButton;//砸金蛋按钮
- (void)start:(UIButton *)btn;
- (void)stop:(UIButton *)btn;

@end
