//
//  LTNTextField.m
//  lingtouniao
//
//  Created by LiuFeifei on 15/11/27.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNTextField.h"

@interface LTNTextField ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton * clearButton;

@end

@implementation LTNTextField
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lineWidth = 1.0 / [UIScreen mainScreen].scale;
        self.lineColor = kHexColor(@"#e2e2e2");
        self.textColor = kHexColor(@"#3a3a3a");
        self.font = kFont(16);
    }
    return self;
}

#pragma mark - 添加内部图片
#pragma mark 添加左边label，距离textfield最左边有指定距离
-(void)addLeftViewWithTitle:(NSString *)title leftMargin:(CGFloat)leftMargin leftWidth:(CGFloat)leftWidth leftViewMode:(UITextFieldViewMode)leftViewMode
{
    // 左边View
    UIView * leftView = [[UIImageView alloc] init];
    
    // 设置尺寸
    CGRect leftViewBounds = self.bounds;
    // 宽度高度一样
    leftViewBounds.size.width = leftWidth;
    leftView.bounds = leftViewBounds;
    
    // 左图label
    UILabel * leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, 0, leftWidth - leftMargin, leftViewBounds.size.height)];
    leftLabel.textColor = kRGBColor(136, 136, 136);
    leftLabel.font = kFont(16);
    leftLabel.text = title;
    [leftView addSubview:leftLabel];
    
    // 添加TextFiled的左边视图
    self.leftView = leftView;
    
    // 设置TextField左边的总是显示
    self.leftViewMode = leftViewMode;
}
#pragma mark 添加左边图片，距离textfield最左边有指定距离
-(void)addLeftViewWithImageName:(NSString *)imageName leftMargin:(CGFloat)leftMargin leftViewMode:(UITextFieldViewMode)leftViewMode
{
    // 左边View
    UIView * leftView = [[UIView alloc] init];
    
    // 设置尺寸
    CGRect leftViewBounds = self.bounds;
    // 宽度高度一样
    leftViewBounds.size.width = leftViewBounds.size.height;
    leftView.bounds = leftViewBounds;
    
    // 左图image
    UIImage * leftImage = [UIImage imageNamed:imageName];
    UIImageView * leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin, 0, leftImage.size.width, leftView.bounds.size.height)];
    leftImageView.image = leftImage;
    leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [leftView addSubview:leftImageView];
    
    // 添加TextFiled的左边视图
    self.leftView = leftView;
    
    // 设置TextField左边的总是显示
    self.leftViewMode = leftViewMode;
}

#pragma mark 添加右边图片，距离textfield最右边有指定距离
-(void)addRightViewWithImageName:(NSString *)imageName selectImageName:(NSString *)selectImageName rightViewMode:(UITextFieldViewMode)rightViewMode target:(id)target action:(SEL)action
{
    // 左边View
    UIView * rightView = [[UIView alloc] init];
    // 设置尺寸
    CGRect rightViewBounds = self.bounds;
    // 宽度高度一样
    rightViewBounds.size.width = rightViewBounds.size.height;
    rightView.bounds = rightViewBounds;
    // 右图image
    UIImage * rightImage = [UIImage imageNamed:imageName];
    UIImage * rightSelectImage = [UIImage imageNamed:selectImageName];
    UIButton * rightButton = [[UIButton alloc] initWithFrame:rightViewBounds];
    [rightButton setImage:rightImage forState:UIControlStateNormal];
    [rightButton setImage:rightSelectImage forState:UIControlStateSelected];
    [rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:rightButton];
    
    // 添加TextFiled的右边视图
    self.rightView = rightView;
    // 设置TextField右边的总是显示
    self.rightViewMode = rightViewMode;
}

#pragma mark 添加清除按钮
- (void)addClearButtonWithRightMargin:(CGFloat)rightMargin imageName:(NSString *)imageName
{
    UIImage * image = [UIImage imageNamed:imageName];
    UIView * rightView = [[UIView alloc] init];
    // 设置尺寸
    CGRect rightViewBounds = self.bounds;
    CGFloat width = 0;
    CGSize clearButtonSize = CGSizeZero;
    if (self.rightView.subviews.count) {
        width += image.size.width + rightMargin;
        for (UIView * view in self.rightView.subviews) {
            width += view.bounds.size.width;
            view.left = image.size.width;
            [rightView addSubview:view];
        }
        clearButtonSize = CGSizeMake(image.size.width, rightViewBounds.size.height);
    } else {
        width = self.rightView ? width + image.size.width : self.bounds.size.height + rightMargin;
        clearButtonSize = CGSizeMake(rightViewBounds.size.height, rightViewBounds.size.height);
    }
    rightViewBounds.size.width =  width;
    rightView.bounds = rightViewBounds;
    rightView.height = self.bounds.size.height;
    UIButton * clearButton = [[UIButton alloc] init];
    clearButton.left = 0;
    clearButton.size = clearButtonSize;
    [clearButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    clearButton.hidden = YES;
    [rightView addSubview:clearButton];
    self.rightView = rightView;
    
    self.rightViewMode = UITextFieldViewModeAlways;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didChange:) name:UITextFieldTextDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didEndEditing:) name:UITextFieldTextDidEndEditingNotification object:self];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:self];
    [clearButton addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:clearButton];
    
    self.clearButton = clearButton;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)clear:(UIButton *)button
{
    self.text = @"";
    self.clearButton.hidden = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        [self.delegate textFieldShouldClear:self];
    }
}

#pragma mark - 通知方法
- (void)didBeginEditing:(NSNotification *)notification
{
    self.clearButton.hidden = self.text.length > 0 ? NO : YES;
}

- (void)didEndEditing:(NSNotification *)notification
{
    self.clearButton.hidden = YES;
}

- (void)didChange:(NSNotification *)notification
{
    self.clearButton.hidden = self.text.length > 0 ? NO : YES;
    if (self.limitedCount && self.text.length > self.limitedCount) {
        NSString * text = [self.text substringWithRange:NSMakeRange(0, self.limitedCount)];
        self.text = text;
    }
}

#pragma mark - 重新drawRect
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.lineColor.CGColor);
    if (self.drawBottomLine) {
        CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - self.lineWidth, CGRectGetWidth(self.frame), self.lineWidth));
    }
    if (self.drawTopLine) {
        CGContextFillRect(context, CGRectMake(0, self.lineWidth * 0.5, CGRectGetWidth(self.frame), self.lineWidth));
    }
    if (self.drawLeftLine) {
        CGContextFillRect(context, CGRectMake(0, 0, self.lineWidth, CGRectGetHeight(self.frame)));
    }
    if (self.drawRightLine) {
        CGContextFillRect(context, CGRectMake(0, CGRectGetWidth(self.frame) - self.lineWidth, self.lineWidth, CGRectGetHeight(self.frame)));
    }
}

#pragma mark - setter方法
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    [self setNeedsDisplay];
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    [self setNeedsDisplay];
}

- (void)setDrawTopLine:(BOOL)drawTopLine
{
    _drawTopLine = drawTopLine;
    [self setNeedsDisplay];
}

- (void)setDrawLeftLine:(BOOL)drawLeftLine
{
    _drawLeftLine = drawLeftLine;
    [self setNeedsDisplay];
}

- (void)setDrawBottomLine:(BOOL)drawBottomLine
{
    _drawBottomLine = drawBottomLine;
    [self setNeedsDisplay];
}

- (void)setDrawRightLine:(BOOL)drawRightLine
{
    _drawRightLine = drawRightLine;
    [self setNeedsDisplay];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    [super setPlaceholder:placeholder];
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName : kHexColor(@"#cccccc"), NSFontAttributeName : kFont(16)}];
}

@end
