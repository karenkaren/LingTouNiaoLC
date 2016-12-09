//
//  GoldenEggButton.m
//  lingtouniao
//
//  Created by 徐凯 on 16/2/18.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//


#import "GoldenEggButton.h"
#define RC_AUTODOCKING_ANIMATE_DURATION 0.2f

@interface GoldenEggButton ()

@property (nonatomic, strong) UIImageView * egg;

@end

@implementation GoldenEggButton

- (instancetype)initInView:(UIView *)view WithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [view addSubview:self];
        [self defaultSetting];
    }
    return self;
}

- (instancetype)initInView:(UIView *)view {
    self = [super init];
    if (self) {
        [self setupUI];
        [view addSubview:self];
        [self defaultSetting];
    }
    return self;
}

- (void)setupUI
{
    UILabel * eggLabel = [Utility createLabel:kFont(10) color:COLOR_MAIN];
    eggLabel.text = locationString(@"tab_home_bird_coin");
    eggLabel.textAlignment = NSTextAlignmentCenter;
    [eggLabel sizeToFit];
    eggLabel.width += 20;
    eggLabel.height += 5;
    eggLabel.layer.cornerRadius = eggLabel.height * 0.5;
    eggLabel.layer.masksToBounds = YES;
    UIColor * borderColor = COLOR_MAIN;
    eggLabel.layer.borderColor = borderColor.CGColor;
    eggLabel.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
    [self addSubview:eggLabel];
    
    UIImage * eggImage = [UIImage imageNamed:@"btn_homepage"];
    UIImageView * eggImageView = [[UIImageView alloc] initWithImage:eggImage];
    [self addSubview:eggImageView];
    self.egg = eggImageView;
    
    CGFloat height = MAX(eggLabel.height, eggImageView.height);
    eggImageView.centerY = eggLabel.centerY = height * 0.5;
    eggLabel.left = eggImageView.right - 10;
    self.bounds = CGRectMake(0, 0, eggLabel.width + eggImageView.width - 10, height);
}

- (void)defaultSetting {    
    _autoDocking = YES;
    _singleTapBeenCanceled = NO;
}

#pragma mark - Blocks
#pragma mark Touch Blocks
- (void)setTapBlock:(void (^)(GoldenEggButton *))tapBlock {
    _tapBlock = tapBlock;
    if (_tapBlock) {
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(executeButtonTouchedBlock)];
        [self addGestureRecognizer:tap];
    }
}

- (void)executeButtonTouchedBlock {
    if (!_singleTapBeenCanceled && _tapBlock && !_isDragging) {
        _tapBlock(self);
    }
}

#pragma mark -- 蛋可以随意拖动
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    _isDragging = NO;
    [super touchesBegan:touches withEvent:event];
    _singleTapBeenCanceled = NO;
    _beginLocation = [[touches anyObject] locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
        _isDragging = YES;

        UITouch *touch = [touches anyObject];
        CGPoint currentLocation = [touch locationInView:self];
        NSLog(@"%@",NSStringFromCGPoint(currentLocation));
        
        float offsetX = currentLocation.x - _beginLocation.x;
        float offsetY = currentLocation.y - _beginLocation.y;
        
        self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
        NSLog(@"center%@",NSStringFromCGPoint(self.center));
        CGRect superviewFrame = self.superview.frame;
        CGRect frame = self.frame;
        CGFloat leftLimitX = frame.size.width / 2;
        CGFloat rightLimitX = superviewFrame.size.width - leftLimitX;
        CGFloat topLimitY = frame.size.height / 2;
        CGFloat bottomLimitY = superviewFrame.size.height - topLimitY;
        
        if (self.center.x > rightLimitX) {
            self.center = CGPointMake(rightLimitX, self.center.y);
        }else if (self.center.x <= leftLimitX) {
            self.center = CGPointMake(leftLimitX, self.center.y);
        }
        
        if (self.center.y > bottomLimitY) {
            self.center = CGPointMake(self.center.x, bottomLimitY);
        }else if (self.center.y <= topLimitY){
            self.center = CGPointMake(self.center.x, topLimitY);
        }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded: touches withEvent: event];
    
    if (_isDragging ) {
        _singleTapBeenCanceled = YES;
    }
    
    if (_isDragging && _autoDocking) {
        CGRect superviewFrame = self.superview.frame;
        CGRect frame = self.frame;
        CGFloat middleX = superviewFrame.size.width / 2;

        if (self.center.x >= middleX) {
            [UIView animateWithDuration:RC_AUTODOCKING_ANIMATE_DURATION animations:^{
                self.center = CGPointMake(superviewFrame.size.width - frame.size.width / 2 - 16, self.center.y);

            } completion:^(BOOL finished) {

            }];
        } else {
            [UIView animateWithDuration:RC_AUTODOCKING_ANIMATE_DURATION animations:^{
                self.center = CGPointMake(frame.size.width / 2 + 16, self.center.y);
              
            } completion:^(BOOL finished) {
               
            }];
        }
    }
    
    _isDragging = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    _isDragging = NO;
    [super touchesCancelled:touches withEvent:event];
}

/**
 *
 *  @param btn 砸金蛋按钮抖动
 */
- (void)startShake {
    double angle1 = -5.0 / 180.0 * M_PI;
    double angle2 = 5.0 / 180.0 * M_PI;
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    
    anim.values = @[@(angle1), @(angle2), @(angle1)];
    anim.duration = 0.25;
    // 动画的重复执行次数
    anim.repeatCount = MAXFLOAT;
    
    // 保持动画执行完毕后的状态
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    
    [self.egg.layer addAnimation:anim forKey:@"shake"];
}

// 停止抖动
- (void)stopShake {
    [self.egg.layer removeAnimationForKey:@"shake"];
}

@end