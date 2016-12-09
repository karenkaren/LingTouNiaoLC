//
//  LTNAlertWindow.m
//  lingtouniao
//
//  Created by zhangtongke on 16/2/24.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNAlertWindow.h"

static LTNAlertWindow *_sharedWindow = nil;
static dispatch_once_t onceToken;

@implementation LTNAlertWindow

- (instancetype)initSharedWindow
{
    self = [super init];
    if (self) {
        self.windowLevel = UIWindowLevelAlert;
        self.backgroundColor = [UIColor clearColor];
        self.frame = [UIScreen mainScreen].bounds;
        
        self->_appKeyWindow = [LTNCore mainWindow];
    }
    return self;
}

- (void)resignKeyWindow
{
    
    [super resignKeyWindow];
    [[LTNCore mainWindow] makeKeyWindow];
    self.hidden = YES;
    onceToken = 0;
    _sharedWindow = nil;
}

#pragma mark - Public

+ (instancetype)sharedWindow
{
    dispatch_once(&onceToken, ^{
        _sharedWindow = [[super alloc] initSharedWindow];
    });
    return _sharedWindow;
}

- (void)showView:(UIView *)view
{
    if ([view isKindOfClass:[UIView class]]) {
        [self addSubview:view];
        [self makeKeyAndVisible];
    }
}

- (void)dismissView:(UIView *)view
{
    if ([view isKindOfClass:[UIView class]]) {
        [view removeFromSuperview];
        [self resignKeyWindow];
    }
}

- (void)showRootViewController:(UIViewController *)rootController
{
    
    self.rootViewController=rootController;
    [self makeKeyAndVisible];
    
}

- (void)dismissRootController
{
    [self resignKeyWindow];
}


- (void)dismissAll
{
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self resignKeyWindow];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self) {
        UIView *lastView = self.subviews.lastObject;
        if (lastView) {
            return lastView;
        }
    }
    return view;
}

@end
