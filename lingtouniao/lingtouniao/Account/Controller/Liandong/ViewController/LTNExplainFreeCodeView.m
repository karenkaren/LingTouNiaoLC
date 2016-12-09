//
//  LTNExplainFreeCodeView.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/5/4.
//  Copyright © 2016年 lingtouniao. All rights reserved.
// 

#import "LTNExplainFreeCodeView.h"

#define kSide 50
#define kMargin 15

@interface LTNExplainFreeCodeView ()
@property (nonatomic, strong) UIView * explainView;
@end

@implementation LTNExplainFreeCodeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:[UIApplication sharedApplication].windows.firstObject.bounds];
    if (self) {
        
        self.backgroundColor = kRGBAColor(0, 0, 0, 0.4);
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    CGFloat titleHeight = kGeneralHeight;
    CGFloat labelX = 20;
    CGFloat labelY = 20;
    
    
    NSDictionary *dic =   [[NSUserDefaults standardUserDefaults]objectForKey:kBankListAndBankIntroduction];
    DLog(@"------%@",dic);
//    NSString *title = dic[@"title"];
//    NSString *content = dic[@"content"];
   
    
//    if([title length]==0)
//        title=locationString(@"deposit_nopwd");
    
//    if([content length]==0)
//        content=locationString(@"mianmi_help_con");
    
    NSString *title = locationString(@"deposit_nopwd");
    NSString *content = locationString(@"mianmi_help_con");
    
    
    CGSize explainTextSize = [content boundingRectWithSize:CGSizeMake(self.bounds.size.width - 2 * kSide - 2 * labelX, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : kFont(15)} context:nil].size;
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
    
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = kFont(17);
    [explainView addSubview:titleLabel];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), explainView.bounds.size.width, 0.5)];
    lineView.backgroundColor = HexRGB(0x6a6a6a);
    [explainView addSubview:lineView];
    
    UILabel * explainLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY + CGRectGetMaxY(lineView.frame), labelWidth, labelHeight)];
    explainLabel.numberOfLines = 0;
    
    explainLabel.text = content;
    explainLabel.font = kFont(15);
    [explainView addSubview:explainLabel];
    
    // 关闭按钮
    UIButton * closeButton = [Utility createButtonWithFrame:CGRectMake(explainView.width - 16 - 24, 0, 24, 24) iconName:@"nav_close" target:self action:@selector(close:)];
    closeButton.centerY = titleLabel.centerY;
    [explainView addSubview:closeButton];
    
}

- (void)show{
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    [window addSubview:self];
}

- (void)close:(UIButton *)sender
{
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch =[touches anyObject];
    CGPoint location = [touch locationInView:self];
    if (!CGRectContainsPoint(self.explainView.frame, location)) {
        [self removeFromSuperview];
        
    }
}
@end
