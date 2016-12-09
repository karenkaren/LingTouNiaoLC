//
//  BaseViewController.h
//  mmbang
//
//  Created by yijin on 13-5-7.
//  Copyright (c) 2013年 iyaya. All rights reserved.
//

#import "UINavigationItem+LJ.h"
#import "UINavTitleLabel.h"
#import "LoadingView.h"
#import "NetFailView.h"
#import "Masonry.h"
#import "UIColor+LJ.h"
#import "ShareSnsUtils.h"

// user login status changed
#define kLoginSuccessNotification @"LoginSuccessNotification"
#define kLoginCancelNotification @"LoginCancelNotification"
#define kLogoutSuccessNotification @"LogoutSuccessNotification"

// order
#define kOrderCancelNotification @"kOrderCancelNotification"
#define kOrderPayNotification @"kOrderPayNotification"
#define kOrderCreateNotification @"kOrderCreateNotification"
#define kOrderCommentNotification @"kOrderCommentNotification"
#define kOrderConfirmDeliveryNotification @"kOrderConfirmDeliveryNotification"

#define kOrderPayWechatResponseNotification @"kOrderPayWechatResponseNotification"

#define kOrderPaySuccessReturnHomeNotification @"kOrderPaySuccessReturnHomeNotification"

@class NetFailView;

@interface BaseViewController : UIViewController<UIGestureRecognizerDelegate, UMSocialUIDelegate>
{
    UIView *_waitingIcon;
    NSString *_titleWillBeSetted;
    BOOL _loading;
    
    
    // 导航栏 titleView
    BOOL _didAppear;
    UINavTitleLabel *_navLabel;
    UIView *titleViewToSetWhenAppear; // 等viewDidAppear后再设置
    
    
    NSString *_pageName;
    
    NSDictionary *_fromLinkParam;
}

@property (nonatomic, readonly) BOOL isLogin;
@property (nonatomic, readonly) UINavTitleLabel *navLabel;

@property (nonatomic, strong) NSMutableDictionary *params;

@property (nonatomic, strong)  NetFailView *netFailView;

@property (nonatomic, strong) NSDictionary *fromLinkParam;

//#pragma mark - shareSns
//- (void)shareSns;
//- (void)shareSnsWithShareTitle:(NSString *)shareTitle shareText:(NSString *)shareText shareImage:(UIImage *)shareImage shareDelegate:(id<UMSocialUIDelegate>)shareDelegate;

- (void)commonInit;
- (BOOL)needLogin;
- (void)login;
- (void)setCustomTitle:(NSString *)title;
- (void)setCustomTitle:(NSString *)title iconName:(NSString *)iconName highlightIconName:(NSString *)highlightIconName target:(id)target action:(SEL)action;
// 点击区域占据整个titleView 更容易点击
- (void)setBigButtonCustomTitle:(NSString *)title iconName:(NSString *)iconName highlightIconName:(NSString *)highlightIconName target:(id)target action:(SEL)action;
- (void)setCustomTitleUntilAppear:(NSString *)title;
- (void)showWaitingIcon:(CGFloat)verticalOffset;
- (void)showWaitingIcon;
- (void)dismissWaitingIcon;
- (void)back;

- (void)setLeftBarButtonItem:(UIBarButtonItem *)barButtonItem;
- (void)setRightBarButtonItem:(UIBarButtonItem *)barButtonItem;
- (UIView *)addNavigationBarButtons:(NSArray *)items spaceWidth:(CGFloat)spaceWidth;
- (void)formatTableView:(UITableView *)tableView cell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

// 键盘事件，移动scrollView 使键盘不当到输入框，子类可重写 keyboardDidSow方法，调用
- (void)scrollScrollView:(UIScrollView *)scrollView toVisible:(CGRect)rect animated:(BOOL)animated;
// 键盘事件通知
- (void)keyboardDidShow:(NSNotification *)notification;
- (void)keyboardDidHide:(NSNotification *)notification;
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;

- (void)viewDidPopped;

//提示信息，无数据

// 错误或无数据提示信息展示的区域，默认为self.view.bounds
- (CGRect)boundsForErrorOrEmptyView;

- (UIImage *)iconImageWhenError:(NSError *)error;
- (NSString *)tipsMessageWhenError:(NSError *)error;
- (NSString *)tipsSubMessageWhenError:(NSError *)error;

- (UIImage *)iconImageWhenDataEmpty;
// default is @"暂无数据"
- (NSString *)tipsMessageWhenDataEmpty;

- (UIImage *)iconImageWhenLoading;
- (NSString *)tipsMessageWhenLoading;

// default is self.view.backgroundColor
- (UIColor *)tipsViewBackgroundColor;
// custom empty view, will be added to self.netFailView ,and centered Horizontal Vertical
- (UIView *)emptyView;
- (UIView *)errorViewWhenError:(NSError *)error;
- (UIView *)loadingView;

// if - (UIView *)emptyView; return something not nil, use it as customView and showNetFailViewWithCustomView, else use icon and tipsMessage.
- (void)showErrorView;
- (void)showErrorView:(NSString *)message;
- (void)showErrorViewWithError:(NSError *)error;
- (void)showErrorView:(NSString *)message andImageName:(NSString *)imName;
- (void)showErrorView:(NSString*)message iconImage:(UIImage*)image;
- (void)showErrorView:(NSString *)message andImageName:(NSString *)imName withFrame:(CGRect)frame;
- (void)showErrorViewWithCustomView:(UIView *)customView withFrame:(CGRect)frame;

- (void)showLoadingView;

- (void)showDataEmptyView;
- (void)showDataEmptyView:(NSString*)message;
- (void)showDataEmptyView:(NSString *)message andImageName:(NSString *)imName;
- (void)showDataEmptyView:(NSString*)message iconImage:(UIImage*)image;
- (void)showDataEmptyView:(NSString *)message andImageName:(NSString *)imName withFrame:(CGRect)frame;

//- (void)showNetFailView:(NSString *)message andFailIm:(NSString *)imName;
//- (void)showNetFailView:(NSString*)message iconImage:(UIImage*)image;
//- (void)showNetFailView:(NSString *)message andFailIm:(NSString *)imName withFrame:(CGRect)frame;

- (void)dismissNetFailView;

// override point. default do nothing.
- (void)willShowErrorEmptyDataTipsView:(UIView *)view animated:(BOOL)animated;
- (void)didShowErrorEmptyDataTipsView:(UIView *)view animated:(BOOL)animated;
- (void)willDismissErrorEmptyDataTipsView:(UIView *)view animated:(BOOL)animated;
- (void)didDismissErrorEmptyDataTipsView:(UIView *)view animated:(BOOL)animated;

// tapped
- (void)touchNetFailView:(UIView *)view;
// (deprecated) for back capability
//- (void)touchNetFailView;

- (void)touchReload; // 点击出错页面，重新加载数据

// advanced methods
- (void)showNetFailView:(NSString*)message iconImage:(UIImage*)image withFrame:(CGRect)frame animated:(BOOL)animated;
- (void)showNetFailViewWithCustomView:(UIView *)customView animated:(BOOL)animated;
- (void)showNetFailViewWithCustomView:(UIView *)customView withFrame:(CGRect)frame animated:(BOOL)animated;

- (void)showNetFailViewAnimated:(BOOL)animated;
- (void)dismissNetFailViewAnimated:(BOOL)animated;


#pragma mark --

- (void)handleOpenUrlWithParameter:(NSDictionary *)parameter;

- (void)markApiCallFromNotificationIfNeeded:(NSMutableDictionary *)filter;

- (void)markFromLinkFromHome:(NSMutableDictionary *)filter;

- (void)beforeApiInvocation:(NSString *)path;
- (void)afterApiInvocation:(NSString *)path;
- (void)apiForPath:(NSString *)path method:(NSString *)httpMethod parameter:(NSDictionary *)parameters responseModelClass:(Class)class onComplete:(APIComletionBlock)block;




#pragma -mark 需要子类覆写的虚函数

/**
 *  绑定viewModel
 */
- (void)initViewModelBinding;

/**
 *  创建UI
 */
- (void)initUIView;

//show the bottom separator line of navBar
- (void)showNavigationBarSeparator:(BOOL)show;

@end
