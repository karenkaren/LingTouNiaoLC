//
//  LJGestureLockView.m
//  gestureLock
//
//  Created by liufeifei on 15/10/26.
//  Copyright (c) 2015年 macallytech. All rights reserved.
//

#import "LJGestureLockView.h"

const static NSInteger kNumberOfNotes  = 9;
const static NSInteger kNotesPerRow = 3;
const static CGFloat kNoteDefaultWidth = 60;
const static CGFloat kNoteDefaultHeight = 60;
const static CGFloat kLineDefaultWidth = 16;

const static CGFloat kTrackedLocationInvalidInContentView = -1.0;

@interface LJGestureLockView ()

@property (nonatomic, assign) CGSize buttonSize;
@property (nonatomic, strong) NSArray * buttons;
@property (nonatomic, strong) NSMutableArray * selectedButtons;
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, assign) CGPoint trackedLocationInContentView;
@property (nonatomic, assign) BOOL isDrawEnded;

@end

@implementation LJGestureLockView

#pragma mark - 私有方法
#pragma mark 根据颜色生成image
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark 按钮是否包含某个点
- (UIButton *)buttonContainsThePoint:(CGPoint)point
{
    for (UIButton * button in self.buttons) {
        if (CGRectContainsPoint(button.frame, point)) {
            return button;
        }
    }
    return nil;
}

#pragma mark 手势锁试图初始化
- (void)gestureLockViewInitialize
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.contentView = [[UIView alloc] initWithFrame:UIEdgeInsetsInsetRect(self.bounds, self.contentInsets)];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentView];

    self.buttonSize = CGSizeMake(kNoteDefaultWidth, kNoteDefaultHeight);
    self.selectedButtons = [NSMutableArray array];
    
    self.normalGestureNodeImage = [self imageWithColor:[UIColor greenColor] size:self.buttonSize];
    self.selectedGestureNodeImage = [self imageWithColor:[UIColor redColor] size:self.buttonSize];
    
    self.numberOfGestureNotes = kNumberOfNotes;
    self.gestureNotesPerRow = kNotesPerRow;
    
    self.lineWidth = kLineDefaultWidth;
    self.lineColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    self.trackedLocationInContentView = CGPointMake(kTrackedLocationInvalidInContentView, kTrackedLocationInvalidInContentView);
}

#pragma mark - UIView重写方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self gestureLockViewInitialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self gestureLockViewInitialize];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contentView.frame = UIEdgeInsetsInsetRect(self.bounds, self.contentInsets);
    CGFloat horizontalNodeMargin = (self.contentView.bounds.size.width - self.buttonSize.width * self.gestureNotesPerRow) / (self.gestureNotesPerRow - 1);
    CGFloat numberOfColumns = ceilf(self.numberOfGestureNotes * 1.0 / self.gestureNotesPerRow);
    CGFloat verticalNodeMargin = (self.contentView.bounds.size.height - self.buttonSize.height * numberOfColumns) / (numberOfColumns - 1);
    for (int i = 0; i < self.numberOfGestureNotes; i++) {
        int row = i / self.gestureNotesPerRow;
        int column = i % self.gestureNotesPerRow;
        UIButton * button = self.buttons[i];
        button.frame = CGRectMake(column * (self.buttonSize.width + horizontalNodeMargin), row * (self.buttonSize.height + verticalNodeMargin), self.buttonSize.width, self.buttonSize.height);
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.selectedButtons.count > 0) {
        UIBezierPath * bezierPath = [UIBezierPath bezierPath];
        UIButton * firstButton = [self.selectedButtons firstObject];
        [bezierPath moveToPoint:[self convertPoint:firstButton.center fromView:self.contentView] ];
        for (int i = 1; i < self.selectedButtons.count; i++) {
            UIButton * button = self.selectedButtons[i];
            [bezierPath addLineToPoint:[self convertPoint:button.center fromView:self.contentView]];
        }
        
        
        if (!self.isDrawEnded && self.trackedLocationInContentView.x != kTrackedLocationInvalidInContentView && self.trackedLocationInContentView.y != kTrackedLocationInvalidInContentView) {
            [bezierPath addLineToPoint:[self convertPoint:self.trackedLocationInContentView fromView:self.contentView]];
        }
        
        [bezierPath setLineJoinStyle:kCGLineJoinRound];
        [bezierPath setLineWidth:kLineDefaultWidth];
        [self.lineColor setStroke];
        [bezierPath stroke];
    }
}

#pragma mark - 手势相关方法
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.contentView];
    UIButton * touchedButton = [self buttonContainsThePoint:location];
    if (touchedButton != nil) {
        touchedButton.selected = YES;
        [self.selectedButtons addObject:touchedButton];
        self.trackedLocationInContentView = location;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(gestureLockView:didBeginWithPasscode:)]) {
            [self.delegate gestureLockView:self didBeginWithPasscode:[NSString stringWithFormat:@"%ld",(long)touchedButton.tag]];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.contentView];
    UIButton * touchedButton = [self buttonContainsThePoint:location];
    if (touchedButton != nil && [self.selectedButtons indexOfObject:touchedButton] == NSNotFound) {
        touchedButton.selected = YES;
        [self.selectedButtons addObject:touchedButton];
    }
    self.trackedLocationInContentView = location;
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.isDrawEnded = YES;
    
    if (self.selectedButtons.count > 0) {
        NSMutableArray * passArray = [NSMutableArray array];
        for (UIButton * button in self.selectedButtons) {
            [passArray addObject:[NSString stringWithFormat:@"%ld",(long)button.tag]];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(gestureLockView:didEndWithPasscode:)]) {
            [self.delegate gestureLockView:self didEndWithPasscode:[NSString stringWithFormat:@"%@",[passArray componentsJoinedByString:@","]]];
        }
    }
    
//    for (UIButton * selectedButton in self.selectedButtons) {
//        selectedButton.selected = NO;
//    }
//    [self.selectedButtons removeAllObjects];
//    self.trackedLocationInContentView = CGPointMake(kTrackedLocationInvalidInContentView, kTrackedLocationInvalidInContentView);
    [self setNeedsDisplay];
}

#pragma mark - setter方法
- (void)setNumberOfGestureNotes:(NSInteger)numberOfGestureNotes
{
    if (_numberOfGestureNotes != numberOfGestureNotes) {
        _numberOfGestureNotes = numberOfGestureNotes;
        
        // 必须要先移除原来掉buttons，否则在界面上会叠加
        if (self.buttons != nil && self.buttons.count > 0) {
            for (UIButton * button in self.buttons) {
                [button removeFromSuperview];
            }
        }
        NSMutableArray * buttons = [NSMutableArray arrayWithCapacity:numberOfGestureNotes];
        for (int i = 0; i < numberOfGestureNotes; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            // 需要把用户交互去掉，否则无法响应touch事件
            button.userInteractionEnabled = NO;
            button.tag = i;
            button.frame = CGRectMake(0, 0, self.buttonSize.width, self.buttonSize.height);
            if (self.normalGestureNodeImage) {
                [button setImage:self.normalGestureNodeImage forState:UIControlStateNormal];
            }
            
            if (self.selectedGestureNodeImage) {
                [button setImage:self.selectedGestureNodeImage forState:UIControlStateSelected];
            }
            
            [buttons addObject:button];
            [self.contentView addSubview:button];
        }
        self.buttons = buttons;
    }
}

- (void)setNormalGestureNodeImage:(UIImage *)normalGestureNodeImage
{
    if (_normalGestureNodeImage != normalGestureNodeImage) {
        _normalGestureNodeImage = normalGestureNodeImage;
        
        CGSize buttonSize = self.buttonSize;
        buttonSize.width = self.buttonSize.width > normalGestureNodeImage.size.width ? self.buttonSize.width : normalGestureNodeImage.size.width;
        buttonSize.height = self.buttonSize.height > normalGestureNodeImage.size.height ? self.buttonSize.height : normalGestureNodeImage.size.height;
        self.buttonSize = buttonSize;
        
        if (self.buttons != nil && self.buttons.count > 0) {
            for (UIButton * button in self.buttons) {
                [button setImage:normalGestureNodeImage forState:UIControlStateNormal];
            }
        }
    }
}

- (void)setSelectedGestureNodeImage:(UIImage *)selectedGestureNodeImage
{
    if (_selectedGestureNodeImage != selectedGestureNodeImage) {
        _selectedGestureNodeImage = selectedGestureNodeImage;
        
        CGSize buttonSize = self.buttonSize;
        buttonSize.width = self.buttonSize.width > selectedGestureNodeImage.size.width ? self.buttonSize.width : selectedGestureNodeImage.size.width;
        buttonSize.height = self.buttonSize.height > selectedGestureNodeImage.size.height ? self.buttonSize.height : selectedGestureNodeImage.size.height;
        self.buttonSize = buttonSize;
        
        if (self.buttons != nil && self.buttons.count > 0) {
            for (UIButton * button in self.buttons) {
                [button setImage:selectedGestureNodeImage forState:UIControlStateSelected];
            }
        }
    }
}

- (void)setNeedToMoveGestureDraw:(BOOL)needToMoveGestureDraw
{
    _needToMoveGestureDraw = needToMoveGestureDraw;
    if (needToMoveGestureDraw) {
        for (UIButton * selectedButton in self.selectedButtons) {
            selectedButton.selected = NO;
        }
        [self.selectedButtons removeAllObjects];
        self.trackedLocationInContentView = CGPointMake(kTrackedLocationInvalidInContentView, kTrackedLocationInvalidInContentView);
        [self setNeedsDisplay];
    }
}

@end
