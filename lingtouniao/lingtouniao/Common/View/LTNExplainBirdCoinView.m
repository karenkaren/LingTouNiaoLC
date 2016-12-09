//
//  LTNExplainBirdCoinView.m
//  lingtouniao
//
//  Created by LiuFeifei on 15/12/19.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNExplainBirdCoinView.h"

#define kSide 50
#define kMargin 15

@interface LTNExplainBirdCoinView ()

@property (nonatomic, strong) UIView * explainView;

@end

@implementation LTNExplainBirdCoinView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[UIApplication sharedApplication].windows.firstObject.bounds];
    if (self) {
        self.backgroundColor = kRGBAColor(0, 0, 0, 0.4);
        [self setupUI];
    }
    return self;
}

- (void)show
{
    UIWindow * window = [UIApplication sharedApplication].windows.firstObject;
    [window addSubview:self];
}

- (void)setupUI
{
    CGFloat titleHeight = kGeneralHeight;
    CGFloat labelX = 20;
    CGFloat labelY = 20;
    
    NSString *explainString= esString([KeyValueStoreManager tipWithKey:@"BIRD_TIP"]);
    if([explainString length]==0)
        explainString=locationString(@"bird_coin_help");
    
    
    
    CGSize explainTextSize = [explainString boundingRectWithSize:CGSizeMake(self.bounds.size.width - 2 * kSide - 2 * labelX, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : kFont(15)} context:nil].size;
    CGFloat labelWidth = explainTextSize.width;
    CGFloat labelHeight = explainTextSize.height;
    UIView * explainView = [[UIView alloc] initWithFrame:CGRectMake(kSide, 0, labelX * 2 + labelWidth, titleHeight + labelY * 2 + labelHeight)];
    explainView.center = CGPointMake(explainView.center.x, self.center.y);
    explainView.backgroundColor = [UIColor whiteColor];
    explainView.layer.cornerRadius = 5;
    explainView.layer.masksToBounds = YES;
    [self addSubview:explainView];
    self.explainView = explainView;
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, explainView.bounds.size.width, titleHeight)];
    titleLabel.text = locationString(@"bird_coin");
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = kFont(17);
    [explainView addSubview:titleLabel];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), explainView.bounds.size.width, 0.5)];
    lineView.backgroundColor = HexRGB(0x6a6a6a);
    [explainView addSubview:lineView];
    
    UILabel * explainLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY + CGRectGetMaxY(lineView.frame), labelWidth, labelHeight)];
    explainLabel.numberOfLines = 0;
    
    
    
    explainLabel.text = explainString;
    explainLabel.font = kFont(15);
    [explainView addSubview:explainLabel];
    
    // 关闭按钮
    UIButton * closeButton = [Utility createButtonWithFrame:CGRectMake(explainView.width - 16 - 24, 0, 24, 24) iconName:@"nav_close" target:self action:@selector(close:)];
    closeButton.centerY = titleLabel.centerY;
    [explainView addSubview:closeButton];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    if (!CGRectContainsPoint(self.explainView.frame, location)) {
        [self removeFromSuperview];
    }
}

- (void)close:(UIButton *)sender
{
    [self removeFromSuperview];
}

@end
