//
//  HomeSectionHeaderView.h
//  lingtouniao
//
//  Created by LiuFeifei on 16/5/20.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoldenEggButton.h"

#define kSectionHeight DimensionBaseIphone6(44)
#define kDefaultSectionHeight DimensionBaseIphone6(15)

@class HomeSectionHeaderView;
@protocol HomeSectionHeaderViewDelegate <NSObject>

- (void)showMore:(HomeSectionHeaderView *)sectionHeaderView;

@end

@interface HomeSectionHeaderView : UIView

+ (HomeSectionHeaderView *)getHomeSectionHeaderViewWithTitle:(NSString *)title titleDetail:(NSString *)titleDetail;

@property (nonatomic, weak) id<HomeSectionHeaderViewDelegate> delegate;
//@property (nonatomic, strong) GoldenEggButton * avatar;
//@property (nonatomic, assign) BOOL showAction;
//@property (nonatomic, strong) UIButton *goldenButton;//砸金蛋按钮
//- (void)start:(UIButton *)btn;
//- (void)stop:(UIButton *)btn;
@property (nonatomic, copy) NSString * classString;

@end
