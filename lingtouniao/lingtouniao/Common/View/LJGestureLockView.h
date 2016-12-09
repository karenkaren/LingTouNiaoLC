//
//  LJGestureLockView.h
//  gestureLock
//
//  Created by liufeifei on 15/10/26.
//  Copyright (c) 2015年 macallytech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LJGestureLockView;

@protocol LJGestureLockViewDelegate <NSObject>

@optional

/**
 *  手势开始代理方法
 *
 *  @param gestureLockView 手势锁视图
 *  @param passcode        手势开始节点对应的数字
 */
- (void)gestureLockView:(LJGestureLockView *)gestureLockView didBeginWithPasscode:(NSString *)passcode;
/**
 *  手势结束代理方法
 *
 *  @param gestureLockView 手势锁视图
 *  @param passcode        手势锁对应的数字密码，以逗号分隔（为了通用于更多节点）
 */
- (void)gestureLockView:(LJGestureLockView *)gestureLockView didEndWithPasscode:(NSString *)passcode;

@end

@interface LJGestureLockView : UIView

@property (nonatomic, weak) id<LJGestureLockViewDelegate> delegate;

// 总共几个节点，默认为9个
@property (nonatomic, assign) NSInteger numberOfGestureNotes;
// 每行几个节点，默认为3个
@property (nonatomic, assign) NSInteger gestureNotesPerRow;

// 线的颜色
@property (nonatomic, strong) UIColor * lineColor;
// 线宽
@property (nonatomic, assign) CGFloat lineWidth;

// 手势区域的边界
@property (nonatomic, assign) UIEdgeInsets contentInsets;

// 正常时的节点图片
@property (nonatomic, strong) UIImage * normalGestureNodeImage;
// 选中时的节点图片
@property (nonatomic, strong) UIImage * selectedGestureNodeImage;

// 是否删除绘制的手势图
@property (nonatomic, assign) BOOL needToMoveGestureDraw;

@end
