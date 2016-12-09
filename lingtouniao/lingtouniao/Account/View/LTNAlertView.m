//
//  LTNAlertView.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/1/9.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNAlertView.h"

#define kSpace DimensionBaseIphone6(12)
#define kSide DimensionBaseIphone6(18)

@implementation LTNAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle
{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self buildWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitle:otherButtonTitle];
    }
    return self;
}

- (void)buildWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle
{
    self.delegate = delegate;
    UIView * alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DimensionBaseIphone6(268), DimensionBaseIphone6(180))];
    alertView.center = self.center;
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.layer.cornerRadius = 10;
    alertView.layer.masksToBounds = YES;
    [self addSubview:alertView];
    
    UILabel * titleLabel = [Utility createLabel:[CustomerizedFont systemFontOfSize:16] color:HexRGB(0x494949)];
    titleLabel.text = title;
    [titleLabel sizeToFit];
    titleLabel.top = DimensionBaseIphone6(20);
    titleLabel.centerX = alertView.width * 0.5;
    [alertView addSubview:titleLabel];
    
    UILabel * contentLabel = [Utility createLabel:[CustomerizedFont systemFontOfSize:12] color:HexRGB(0x8a8a8a)];
    contentLabel.numberOfLines = 0;
    contentLabel.text = message;
    [contentLabel sizeToFit];
    contentLabel.centerX = alertView.width * 0.5;;
    contentLabel.top = titleLabel.bottom + 12;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [alertView addSubview:contentLabel];
    
    NSArray * titles = @[cancelButtonTitle, otherButtonTitle];
    UIColor * color = kRGBColor(248, 136, 0);
    CGFloat buttonWidth = (alertView.width - kSide * 2 - kSpace) * 0.5;
    for (int i = 0; i < 2; i++) {
        UIColor * textColor = i ? [UIColor whiteColor] : color;
        UIButton * button = [Utility createButtonWithTitle:titles[i] color:textColor font:[CustomerizedFont systemFontOfSize:16] block:^(UIButton *btn) {
            [self clickButton:btn];
        }];
        button.tag = i;
        button.backgroundColor = i ? color : [UIColor whiteColor];
        button.width = buttonWidth;
        button.bottom = alertView.height - DimensionBaseIphone6(26);
        button.height = DimensionBaseIphone6(kGeneralHeight);
        button.left = kSide + (buttonWidth + kSpace) * i;
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        button.layer.borderWidth = 1;
        button.layer.borderColor = color.CGColor;
        [alertView addSubview:button];
    }
}

- (void)clickButton:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [self.delegate alertView:self clickedButtonAtIndex:sender.tag];
    }
    [self removeFromSuperview];
}

- (void)show
{
   // UIWindow * window = [UIApplication sharedApplication].windows.lastObject;
    UIWindow * window = [LTNCore mainWindow];
    [window addSubview:self];
}


- (void)showToView:(UIView *)view
{
    [view addSubview:self];
    [view bringSubviewToFront:self];
}

- (void)showToController:(UIViewController *)viewController{
    
    if(viewController.tabBarController){
        [self showToView:viewController.tabBarController.view];
    }else if(viewController.navigationController){
        [self showToView:viewController.navigationController.view];
    }else{
        [self showToView:viewController.view];
    }
}


@end
