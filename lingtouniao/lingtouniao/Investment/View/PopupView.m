//
//  PopupView.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/2/19.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "PopupView.h"

@interface PopupView()
{
    NSString * _prompt;
    NSDictionary * _attributes;
    UIView * _containerView;
    CGRect _fromRect;
    UIView * _contentView;
    UIView * _myContainerView;
}

@end

@implementation PopupView

- (instancetype)initWithPrompt:(NSString *)prompt attributes:(NSDictionary *)attributes inView:(UIView *)view fromRect:(CGRect)fromRect
{
    self = [super initWithFrame:view.frame];
    if (self) {
        _prompt = prompt;
        _attributes = attributes;
        _containerView = view;
        _fromRect = fromRect;
        [self buildUI];
    }
    return self;
}

- (void)buildUI
{
    UIFont * font = [_attributes objectForKey:NSFontAttributeName];
    if (!font) {
        font = [CustomerizedFont heiti:12];
    }
    
    UIColor * color = [_attributes objectForKey:NSForegroundColorAttributeName];
    if (!color) {
        color = [UIColor blackColor];
    }
    
    CGFloat margin = 10;
    UIView * myContainerView = [[UIView alloc] initWithFrame:_containerView.frame];
    [self addSubview:myContainerView];
    
    UIView * contentView = [[UIView alloc] init];
    contentView.backgroundColor = HexRGB(0xFFE28A);
    contentView.layer.cornerRadius = 5;
    contentView.layer.masksToBounds = YES;
    [myContainerView addSubview:contentView];
    
    UILabel * promptLabel = [Utility createLabel:font color:color];
    promptLabel.text = _prompt;
    [promptLabel sizeToFit];
    if (promptLabel.width > _containerView.width - 4 * margin) {
        CGSize promptSize = [_prompt boundingRectWithSize:CGSizeMake(_containerView.width - 4 * margin, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:_attributes context:nil].size;
        promptLabel.size = promptSize;
        promptLabel.numberOfLines = 0;
    }
    [contentView addSubview:promptLabel];
    
    contentView.width = promptLabel.width + 2 * margin;
    contentView.height = promptLabel.height + 2 * margin;
    
    promptLabel.left = margin;
    promptLabel.top = margin;
    
    UIImage * arrowImage = [UIImage imageNamed:@"tragle"];
    UIImageView * arrowImageView = [[UIImageView alloc] initWithImage:arrowImage];
    [myContainerView addSubview:arrowImageView];
    
    myContainerView.width = contentView.width;
    myContainerView.height = contentView.height + arrowImageView.height;
    
    arrowImageView.top = contentView.bottom;
    arrowImageView.left = 10;
    
    myContainerView.bottom = _fromRect.origin.y - _containerView.top;
    myContainerView.left = margin;
    
    _contentView = contentView;
    _myContainerView = myContainerView;
    
    [_containerView addSubview:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInView:_myContainerView];
    if (!CGRectContainsPoint(_contentView.frame, location)) {
        [self removeFromSuperview];
    }
}

@end
