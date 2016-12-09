//
//  QCSlideSwitchView.h
//  QCSliderTableView
//
//  Created by “ 邵鹏 on 14-4-16.
//  Copyright (c) 2014年 Scasy. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QCSlideSwitchViewStyle){
    TopScrollView = 0,
    TopAndContenScrollView
};



@protocol QCSlideSwitchViewDelegate;
@interface QCSlideSwitchView : UIView<UIScrollViewDelegate>
{
    UIScrollView *_rootScrollView;                  //主视图
    UIScrollView *_topScrollView;                   //顶部页签视图
    
    CGFloat _userContentOffsetX;
    BOOL _isLeftScroll;                             //是否左滑动
    BOOL _isRootScroll;                             //是否主视图滑动
    BOOL _isBuildUI;                                //是否建立了ui
    
    NSInteger _userSelectedChannelID;               //点击按钮选择名字ID
    
    UIImageView *_shadowImageView;
    UIImage *_shadowImage;
    
    UIColor *_tabItemNormalColor;                   //正常时tab文字颜色
    UIColor *_tabItemSelectedColor;                 //选中时tab文字颜色
    UIImage *_tabItemNormalBackgroundImage;         //正常时tab的背景
    UIImage *_tabItemSelectedBackgroundImage;       //选中时tab的背景
    NSMutableArray *_viewArray;                     //主视图的子视图数组
    
    UIButton *_rigthSideButton;                     //右侧按钮
    
    __weak id<QCSlideSwitchViewDelegate> _slideSwitchViewDelegate;
}

@property (nonatomic, strong) IBOutlet UIScrollView *rootScrollView;
@property (nonatomic, strong) IBOutlet UIScrollView *topScrollView;

@property (nonatomic, assign) QCSlideSwitchViewStyle style;

@property (nonatomic)NSNumber *stretchWidth;

@property (nonatomic, assign) CGFloat userContentOffsetX;
@property (nonatomic, assign) NSInteger userSelectedChannelID;
@property (nonatomic, assign) NSInteger scrollViewSelectedChannelID;
@property (nonatomic, weak) IBOutlet id<QCSlideSwitchViewDelegate> slideSwitchViewDelegate;
@property (nonatomic, strong) UIColor *tabItemNormalColor;
@property (nonatomic, strong) UIColor *tabItemSelectedColor;
@property (nonatomic, strong) UIImage *tabItemNormalBackgroundImage;
@property (nonatomic, strong) UIImage *tabItemSelectedBackgroundImage;
@property (nonatomic, strong) UIImage *shadowImage;
@property (nonatomic, strong) NSMutableArray *viewArray;
@property (nonatomic, strong) IBOutlet UIButton *rigthSideButton;

// 自己添加
@property (nonatomic, readonly) NSInteger selectIndex;

@property (nonatomic, assign) BOOL isShowSpot;

- (id)initWithFrame:(CGRect)frame andStyle:(QCSlideSwitchViewStyle)style;
- (void)setSelectIndex:(NSInteger)selectIndex animated:(BOOL)animated;
- (UIView *)topScrollViewItemWithIndex:(NSInteger)index;

/**
 *  默认nil，如果设置了 shadowView，则 忽略 shadowImage;如果只设置了shadowImage，则返回 _shadowImageView
 *  自定义 shadowView，x和width 会根据情况自动修改。保持 y和height不变
 */
@property (nonatomic, strong) UIView *shadowView;

/**
 *  shadowView 的 width 的偏移量，默认nil，不对shadowView width做修正，默认为 button的width
 *  如果赋值，则为shadowView的width 为 button title 的宽度 再加上 shadowWidthInset*2。
 */
@property (nonatomic, strong) NSNumber *shadowWidthInset;

// 背景移动的时候，是否隐藏。默认NO
@property (nonatomic, assign) BOOL isShadowHiddenWhenAniamting;


// default 44
@property (nonatomic, assign) CGFloat topScrollViewHeight;
// button 边距 default 0
@property (nonatomic, assign) CGFloat buttonMarginX;
// button 间隔 default 0
@property (nonatomic, assign) CGFloat buttonSpaceWidth;
// default [MMBang_font systemFontOfSize:17];
@property (nonatomic, strong) UIFont *buttonLabelFont;
// 对button计算出来的 width，在加一个 offset,默认 0
@property (nonatomic, assign) CGFloat buttonWidthOffset;

@property (nonatomic) NSNumber* buttonHeight;

@property (nonatomic) CGFloat buttonWidth;
/*!
 * @method 创建子视图UI
 * @abstract
 * @discussion
 * @param
 * @result
 */
- (void)buildUI;

/**
 *  调整 适应屏幕宽度，应该在 buildUI之后调用
 */
- (void)adjustScreenWidth;

/*!
 * @method 通过16进制计算颜色
 * @abstract
 * @discussion
 * @param 16机制
 * @result 颜色对象
 */
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;

@end

@protocol QCSlideSwitchViewDelegate <NSObject>

@required

/*!
 * @method 顶部tab个数
 * @abstract
 * @discussion
 * @param 本控件
 * @result tab个数
 */
- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view;

/*!
 * @method 每个tab所属的viewController
 * @abstract
 * @discussion
 * @param tab索引
 * @result viewController
 */
- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number;

@optional

/*!
 * @method 滑动左边界时传递手势
 * @abstract
 * @discussion
 * @param   手势
 * @result
 */
- (void)slideSwitchView:(QCSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer*) panParam;

/*!
 * @method 滑动右边界时传递手势
 * @abstract
 * @discussion
 * @param   手势
 * @result
 */
- (void)slideSwitchView:(QCSlideSwitchView *)view panRightEdge:(UIPanGestureRecognizer*) panParam;

/*!
 * @method 点击tab
 * @abstract
 * @discussion
 * @param tab索引
 * @result
 */
- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number;

- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number withRowAnimation:(UITableViewRowAnimation)animation;

//  临时加的
- (void)slideScrollViewWithScrolling;

@end

