//
//  BaseViewController.m
//  mmbang
//
//  Created by yijin on 13-5-7.
//  Copyright (c) 2013年 iyaya. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BaseViewController.h"
#import "UIBarButtonItem+ClearBackground.h"
#import "BaseDataEngine.h"

#define WAITING_ICON_SIZE 60
#define kViewControllerBgColor [UIColor whiteColor]
#import "BaseWebViewController.h"
#import "HandeUrlUtil.h"
#import "NSStringUtil.h"


@interface BaseViewController ()
{
    UITapGestureRecognizer* _tapGesture;
}


@end

@implementation BaseViewController

@synthesize isLogin = _isLogin;

- (void)dealloc
{
//    if (self.isViewLoaded) {
//        [self.view removeGestureRecognizer:_tapGesture];
//    }
    DLog(@"======dealloc %@",self);

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)commonInit{
    
}

- (id)init
{
    self = [super init];
    if (self) {
        _params = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#fafafa"] size:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
    if (self.navigationController != nil && self.navigationController.childViewControllers.count > 1) {
        UIBarButtonItem *backButton = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"nav_return"] highlightImage:nil target:self action:@selector(back)];
    
        self.navigationItem.leftBarButtonItem = backButton;
    }
    //点击空白 收起键盘
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    _tapGesture.cancelsTouchesInView =  NO;
    _tapGesture.delegate = self;
    [self.view addGestureRecognizer:_tapGesture];
    self.view.backgroundColor =  BACKGROUND_COLOR;
    [self initViewModelBinding];
    [self initUIView];
}

- (void)initUIView {

}

- (void)initViewModelBinding {

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.view removeGestureRecognizer:_tapGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    _pageName = self.title;
    if (![_pageName length]) {
        _pageName = NSStringFromClass(self.class);
    }

    if (![@"HomeViewController" isEqualToString:_pageName]) {
        [TrackingUtility  beginLogPageView:_pageName];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _didAppear = YES;
    if (titleViewToSetWhenAppear != nil && titleViewToSetWhenAppear != self.navigationItem.titleView) {
        self.navigationItem.titleView = titleViewToSetWhenAppear;
        titleViewToSetWhenAppear = nil;
    }
    [[PiwikTracker sharedInstance] sendViews:NSStringFromClass([self class]), self.title, nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
    if (![@"HomeViewController" isEqualToString:_pageName]) {
        [TrackingUtility  endLogPageView:_pageName];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    _didAppear = NO;
}
- (void)setLeftBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    //    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:barButtonItem.target action:barButtonItem.action];
    //    negativeSpacer.width = 15;
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:barButtonItem, nil];
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    //    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:barButtonItem.target action:barButtonItem.action];
    //    negativeSpacer.width = 15;
    
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (UIView *)addNavigationBarButtons:(NSArray *)items spaceWidth:(CGFloat)spaceWidth
{
    if (items.count == 0) {
        return nil;
    }
    //for adjust rightBarButtonItem's right position
    CGFloat var = 0;

    CGFloat width = 0;
    UIView *customView = [[UIView alloc] init];
    customView.height = NavigationBarHeight;

    for (UIView *subItem in items) {
        if (![subItem isKindOfClass:[UIView class]]) {
            continue;
        }
        [customView addSubview:subItem];
        subItem.centerY = customView.myCenterY - 1;  //adjust 1 point per UI request
        subItem.left = width;
        width += subItem.width + spaceWidth;
    }
    width -= spaceWidth;

    if (items.count > 1) {
        customView.width = width - var;
    } else {
        customView.width = width;
    }

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:customView];
    self.navigationItem.rightBarButtonItem = item;
    return customView;
}

- (BOOL)isLogin
{
    return NO;
//    return [Utility getLoginUserInfo].isGuest;
}

- (void)login
{
//    [HaowanUtil presentLoginViewControllerFrom:self];

}

- (BOOL)needLogin
{
    BOOL isLogin = self.isLogin;
    
    if (!isLogin) {
        [self login];
    }
    
    return !isLogin;
}

#pragma mark - 自定义导航栏

- (void)setCustomTitle:(NSString *)title{
    self.navigationItem.title = title;
}

- (void)setCustomTitleUntilAppear:(NSString *)title
{
    [self setCustomTitle:title untilViewAppear:YES];
}


- (void)setCustomTitle:(NSString *)title untilViewAppear:(BOOL)untilViewAppear
{
    if (_navLabel == nil) {
        _navLabel = [[UINavTitleLabel alloc] initWithFrame:CGRectZero];
        [_navLabel setClipsToBounds:YES];
        [_navLabel setBackgroundColor:[UIColor clearColor]];
    }
    
    self.navLabel.text = title;
    [self.navLabel sizeToFit];
    
    if(!untilViewAppear || _didAppear){
        self.navigationItem.titleView = nil;
        self.navigationItem.titleView = self.navLabel;
    }else{
        //_titleWillBeSetted = title;
        titleViewToSetWhenAppear = self.navLabel;
    }
}

- (UINavTitleLabel *)navLabel{
    if (_navLabel == nil) {
        _navLabel = [[UINavTitleLabel alloc] initWithFrame:CGRectZero];
        [_navLabel setClipsToBounds:YES];
        [_navLabel setBackgroundColor:[UIColor clearColor]];
    }
    return _navLabel;
}

- (void)setCustomTitle:(NSString *)title iconName:(NSString *)iconName highlightIconName:(NSString *)highlightIconName target:(id)target action:(SEL)action{
    
    [self setCustomTitle:title
                iconName:iconName
       highlightIconName:highlightIconName
                  target:target
                  action:action
         untilViewAppear:NO];
    
}


- (void)setCustomTitle:(NSString *)title iconName:(NSString *)iconName highlightIconName:(NSString *)highlightIconName target:(id)target action:(SEL)action untilViewAppear:(BOOL)untilViewAppear
{
    _navLabel = [[UINavTitleLabel alloc] initWithFrame:CGRectZero];
    [_navLabel setClipsToBounds:YES];
    [_navLabel setBackgroundColor:[UIColor clearColor]];
    
    _navLabel.text = title;
    [_navLabel sizeToFit];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    _navLabel.left = 0;
    _navLabel.top = (titleView.height-_navLabel.height)/2;
    [titleView addSubview:_navLabel];
    
    
    UIImage *image = [UIImage imageNamed:iconName];
    UIButton *titleButton = [Utility createButtonWithFrame:CGRectMake(_navLabel.right, 0, image.size.width+10, titleView.height) iconName:iconName target:target action:action];
    [titleButton setImage:[UIImage imageNamed:highlightIconName] forState:UIControlStateHighlighted];
    [titleView addSubview:titleButton];
    [titleButton setEnlargeEdge:20];
    titleView.width = titleButton.right;
    
    if (!untilViewAppear || _didAppear) {
        titleViewToSetWhenAppear = nil;
        self.navigationItem.titleView = nil;
        self.navigationItem.titleView = titleView;
    }else{
        titleViewToSetWhenAppear = titleView;
    }
    
}

// 点击区域占据整个titleView 更容易点击
// 点击区域占据整个titleView 更容易点击
- (void)setBigButtonCustomTitle:(NSString *)title iconName:(NSString *)iconName highlightIconName:(NSString *)highlightIconName target:(id)target action:(SEL)action{

    [self setBigButtonCustomTitle:title
                         iconName:iconName
                highlightIconName:highlightIconName
                           target:target
                           action:action
                  untilViewAppear:NO];

}


- (void)setBigButtonCustomTitle:(NSString *)title iconName:(NSString *)iconName highlightIconName:(NSString *)highlightIconName target:(id)target action:(SEL)action untilViewAppear:(BOOL)untilViewAppear
{
    
    CGFloat titleViewHeight = 44.0f;
    
    _navLabel = nil;
    _navLabel = [[UINavTitleLabel alloc] initWithFrame:CGRectZero];
    [_navLabel setClipsToBounds:YES];
    [_navLabel setBackgroundColor:[UIColor clearColor]];
    _navLabel.text = title;
    [_navLabel sizeToFit];
    _navLabel.left = 0;
    _navLabel.top = (titleViewHeight-_navLabel.height)/2;
    _navLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    
    UIImage *image = [UIImage imageNamed:iconName];
    UIButton *titleButton = [Utility createButtonWithFrame:CGRectMake(_navLabel.right, 0, image.size.width+10, titleViewHeight) iconName:iconName target:target action:action];
    [titleButton setImage:[UIImage imageNamed:highlightIconName] forState:UIControlStateHighlighted];
    titleButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    
    
    // 再加一个button盖在title上，以增加点击响应区域
    UIButton *leftTitleButton = [Utility createButtonWithFrame:CGRectMake(0, 0, _navLabel.right, titleViewHeight) iconName:nil target:target action:action];
    leftTitleButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _navLabel.width + titleButton.width, titleViewHeight)];
    titleView.backgroundColor =[UIColor clearColor];
    titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    
    [titleView addSubview:_navLabel];
    [titleView addSubview:leftTitleButton];
    [titleView addSubview:titleButton];
    
    titleView.width = MIN(180, titleView.width);
    
    if (!untilViewAppear || _didAppear) {
        titleViewToSetWhenAppear = nil;
        self.navigationItem.titleView = nil;
        self.navigationItem.titleView = titleView;
    }else{
        titleViewToSetWhenAppear = titleView;
    }
    // Not Work
    //    [self.navigationController.navigationBar setNeedsLayout];
    //    self.navigationController.navigationBar.hidden = YES;
    //    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - Back Action

- (void)back
{
    if (self.navigationController.visibleViewController == self) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - 提示信息，无数据


- (void)touchNetFailView:(UIView *)view
{
    
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [self showLoadingView];
    [self touchReload];
}

- (void)touchReload{
    //NSAssert(0, @"<%@> need override method: %s",NSStringFromClass([self class]), __PRETTY_FUNCTION__);
}

- (CGRect)boundsForErrorOrEmptyView{
    return self.view.bounds;
}

- (UIImage *)iconImageWhenError:(NSError *)error{
    return [UIImage imageNamed:@"net_error"];
}

- (NSString *)tipsMessageWhenError:(NSError *)error{
    return locationString(@"net_empty_title");
}

- (NSString *)tipsSubMessageWhenError:(NSError *)error{
    return locationString(@"click_screen_reload");
}


- (UIImage *)iconImageWhenDataEmpty{
    return [UIImage imageNamed:@"viewcontroller_data_empty"];
}



- (NSString *)tipsMessageWhenDataEmpty{
    return locationString(@"empty_data");
}

- (UIImage *)iconImageWhenLoading{
    return [UIImage imageNamed:@"viewcontroller_loading"];
}

- (NSString *)tipsMessageWhenLoading{
    return locationString(@"pull_to_refresh_refreshing_label");
}

- (UIColor *)tipsViewBackgroundColor{
    return self.view.backgroundColor;
}

// custom empty view, will be added to self.netFailView ,and centered Horizontal Vertical
- (UIView *)emptyView{
    return nil;
}

- (UIView *)errorViewWhenError:(NSError *)error{
    return nil;
}

- (UIView *)loadingView{
    return nil;
}

- (void)showErrorView{
    [self showErrorViewWithError:nil];
}

- (void)showErrorViewWithError:(NSError *)error{
    UIView *errorView = [self errorViewWhenError:error];
    if (errorView) {
        
        [self showNetFailViewWithCustomView:errorView animated:NO];
        
    }else{
        
        UIImage *iconImage = [self iconImageWhenError:error];
        NSString *tipsMessage = [self tipsMessageWhenError:error];
        NSString *tipsSubMessage = [self tipsSubMessageWhenError:error];
        [self showNetFailView:tipsMessage subMessage:tipsSubMessage iconImage:iconImage];
    }
//    self.netFailView.tapGesture.enabled = YES;
}

- (void)showErrorView:(NSString *)message {
    [self showErrorView:message iconImage:[self iconImageWhenError:nil]];
}

- (void)showErrorView:(NSString *)message andImageName:(NSString *)imName{
    [self showErrorView:message iconImage:[UIImage imageNamed:imName]];
}

- (void)showErrorView:(NSString*)message iconImage:(UIImage*)image{
    [self showNetFailView:message iconImage:image withFrame:[self boundsForErrorOrEmptyView] animated:NO];
//    self.netFailView.tapGesture.enabled = YES;
}

- (void)showErrorView:(NSString *)message andImageName:(NSString *)imName withFrame:(CGRect)frame{
    [self showNetFailView:message iconImage:[UIImage imageNamed:imName] withFrame:frame animated:NO];
//    self.netFailView.tapGesture.enabled = YES;
}

- (void)showErrorViewWithCustomView:(UIView *)customView withFrame:(CGRect)frame{
    [self showNetFailViewWithCustomView:customView withFrame:frame animated:NO];
//    self.netFailView.tapGesture.enabled = YES;
}

#pragma mark - Loading View

- (void)showLoadingView{
    UIView *emptyView = [self loadingView];
    if (emptyView) {
        
        [self showNetFailViewWithCustomView:emptyView animated:NO];
        
    }else{
        
        UIImage *iconImage = [self iconImageWhenLoading];
        NSString *tipsMessage = [self tipsMessageWhenLoading];
        [self showNetFailView:tipsMessage subMessage:nil iconImage:iconImage];
        
    }
    self.netFailView.tapGesture.enabled = NO;
}

#pragma mark - Data Empty View

- (void)showDataEmptyView{
    UIView *emptyView = [self emptyView];
    if (emptyView) {
        
        [self showNetFailViewWithCustomView:emptyView animated:NO];
        
    }else{
        
        UIImage *iconImage = [self iconImageWhenDataEmpty];
        NSString *tipsMessage = [self tipsMessageWhenDataEmpty];
        [self showNetFailView:tipsMessage subMessage:nil iconImage:iconImage];
    }
//    self.netFailView.tapGesture.enabled = NO;
}

- (void)showDataEmptyView:(NSString *)message andImageName:(NSString *)imName{
    [self showDataEmptyView:message iconImage:[UIImage imageNamed:imName]];
}

- (void)showDataEmptyView:(NSString*)message {
    [self showDataEmptyView:message iconImage:[self iconImageWhenDataEmpty]];
}

- (void)showDataEmptyView:(NSString*)message iconImage:(UIImage*)image{
    [self showNetFailView:message iconImage:image withFrame:[self boundsForErrorOrEmptyView] animated:NO];
//    self.netFailView.tapGesture.enabled = NO;
}

- (void)showDataEmptyView:(NSString *)message andImageName:(NSString *)imName withFrame:(CGRect)frame{
    [self showNetFailView:message iconImage:[UIImage imageNamed:imName] withFrame:frame animated:NO];
//    self.netFailView.tapGesture.enabled = NO;
}

#pragma mark -

- (void)showNetFailView:(NSString *)message subMessage:(NSString *)subMessage andFailIm:(NSString *)imName{
    [self showNetFailView:message subMessage:subMessage andFailIm:imName withFrame:[self boundsForErrorOrEmptyView]];
}

- (void)showNetFailView:(NSString *)message subMessage:(NSString *)subMessage andFailIm:(NSString *)imName withFrame:(CGRect)frame{
    [self showNetFailView:message subMessage:subMessage iconImage:[UIImage imageNamed:imName] withFrame:frame animated:NO];
}

-(void)showNetFailView:(NSString*)message subMessage:(NSString *)subMessage iconImage:(UIImage*)image{
    [self showNetFailView:message subMessage:subMessage iconImage:image withFrame:[self boundsForErrorOrEmptyView] animated:NO];
}

-(void)showNetFailView:(NSString*)message subMessage:(NSString *)subMessage iconImage:(UIImage*)image withFrame:(CGRect)frame animated:(BOOL)animated
{
    if (!_netFailView)
    {
        _netFailView = [[NetFailView alloc] initWithFrame:frame];
        kWeakSelf
        _netFailView.touchNetFailView = ^(UIView *view){
            [weakSelf touchNetFailView:view];
        };
        
        //[self.view addSubview:_netFailView];
    }
    
    _netFailView.frame = frame;
    [_netFailView setMessage:message];
    [_netFailView setSubMessage:subMessage];
    [_netFailView setIconImage:image];
    
    [self showNetFailViewAnimated:animated];
    
}

- (void)showNetFailViewWithCustomView:(UIView *)customView animated:(BOOL)animated{
    [self showNetFailViewWithCustomView:customView withFrame:[self boundsForErrorOrEmptyView] animated:animated];
}

- (void)showNetFailViewWithCustomView:(UIView *)customView withFrame:(CGRect)frame animated:(BOOL)animated{
    
    if (!_netFailView)
    {
        _netFailView = [[NetFailView alloc] initWithFrame:frame];
        kWeakSelf
        _netFailView.touchNetFailView = ^(UIView *view){
            [weakSelf touchNetFailView:view];
        };
        
    }
    
    [_netFailView setCustomView:customView];
    
    [self showNetFailViewAnimated:animated];
    
}

- (void)showNetFailViewAnimated:(BOOL)animated{
    
    if (self.netFailView.superview != self.view) {
        [self.view addSubview:self.netFailView];
    }
    
//    self.netFailView.tapGesture.enabled = YES;

    // set backgroundColor
    UIColor *backgroundColor = [self tipsViewBackgroundColor];
    if (backgroundColor == nil) {
        backgroundColor = [UIColor clearColor];
    }
    self.netFailView.backgroundColor = backgroundColor;
    
    // bring to front
    //self.netFailView.hidden = YES;
    [self.view bringSubviewToFront:self.netFailView];
    
    [self willShowErrorEmptyDataTipsView:self.netFailView animated:animated];
    
    if (animated) {
        
        self.netFailView.hidden = NO;
        //self.netFailView.alpha = 0.0f;
        
        kWeakSelf
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^(){
            
            weakSelf.netFailView.alpha = 1.0f;
            
        } completion:^(BOOL finished){
            
            [weakSelf didShowErrorEmptyDataTipsView:weakSelf.netFailView animated:animated];
        
        }];
        
    }else{
        
        self.netFailView.hidden = NO;
        self.netFailView.alpha = 1.0f;
        [self didShowErrorEmptyDataTipsView:self.netFailView animated:animated];
        
    }
    
}

-(void)dismissNetFailView
{
    [self dismissNetFailViewAnimated:NO];
}

- (void)dismissNetFailViewAnimated:(BOOL)animated{
    self.netFailView.tapGesture.enabled = YES;

    [self willDismissErrorEmptyDataTipsView:self.netFailView animated:animated];
    
    if (animated) {
        
        kWeakSelf
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^(){
            
            weakSelf.netFailView.alpha = 0.0f;
            
        } completion:^(BOOL finished){
            
            [weakSelf didDismissErrorEmptyDataTipsView:weakSelf.netFailView animated:animated];
            
        }];
        
    }else{
        self.netFailView.hidden = YES;
        self.netFailView.alpha = 0.0f;
        [self didDismissErrorEmptyDataTipsView:self.netFailView animated:animated];
        
    }
    
}

- (void)willShowErrorEmptyDataTipsView:(UIView *)view animated:(BOOL)animated{
    
}

- (void)didShowErrorEmptyDataTipsView:(UIView *)view animated:(BOOL)animated{
    
}

- (void)willDismissErrorEmptyDataTipsView:(UIView *)view animated:(BOOL)animated{

}

- (void)didDismissErrorEmptyDataTipsView:(UIView *)view animated:(BOOL)animated{
    
}

#pragma mark - 等待动画
- (void)showWaitingIcon:(CGFloat)verticalOffset
{
    if (_waitingIcon == nil) {
        _waitingIcon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WAITING_ICON_SIZE, WAITING_ICON_SIZE)];
        [_waitingIcon setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2 - WAITING_ICON_SIZE / 2 + verticalOffset)];
        [_waitingIcon setBackgroundColor:[UIColor blackColor]];
        [_waitingIcon setAlpha:0.6];
        [_waitingIcon.layer setCornerRadius:5];
        _waitingIcon.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.view addSubview:_waitingIcon];
        
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [indicatorView startAnimating];
        [indicatorView setFrame:CGRectMake(WAITING_ICON_SIZE / 4, WAITING_ICON_SIZE / 4, WAITING_ICON_SIZE / 2, WAITING_ICON_SIZE / 2)];
        [_waitingIcon addSubview:indicatorView];
    }
    
    [_waitingIcon setHidden:NO];
    [self.view bringSubviewToFront:_waitingIcon];
}

- (void)showWaitingIcon
{
    _loading = YES;
    [self showWaitingIcon:0];
}

- (void)dismissWaitingIcon
{
    _loading = NO;
    [_waitingIcon setHidden:YES];
}

- (void)formatTableView:(UITableView *)tableView cell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    [cell setBackgroundView:nil];
    [cell setSelectedBackgroundView:nil];
    
    NSInteger rowCount = [tableView.dataSource tableView:tableView numberOfRowsInSection:indexPath.section];
    if (rowCount == 1) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"rect_tableview_cell_full_bg"] stretchableImageWithLeftCapWidth:3.0f topCapHeight:3.0f]];
        
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"rect_tableview_cell_full_bg_highlight"] stretchableImageWithLeftCapWidth:3.0f topCapHeight:3.0f]];
    } else if (indexPath.row == 0) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"rect_tableview_cell_top_bg"] stretchableImageWithLeftCapWidth:3.0f topCapHeight:3.0f]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"rect_tableview_cell_top_bg_highlight"] stretchableImageWithLeftCapWidth:3.0f topCapHeight:3.0f]];
    } else if (indexPath.row == rowCount - 1) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"rect_tableview_cell_bottom_bg"] stretchableImageWithLeftCapWidth:3.0f topCapHeight:3.0f]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"rect_tableview_cell_bottom_bg_highlight"] stretchableImageWithLeftCapWidth:3.0f topCapHeight:3.0f]];
    } else {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"rect_tableview_cell_mid_bg"] stretchableImageWithLeftCapWidth:3.0f topCapHeight:3.0f]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"rect_tableview_cell_mid_bg_highlight"] stretchableImageWithLeftCapWidth:3.0f topCapHeight:3.0f]];
    }
}

#pragma mark - keyboard
/* 键盘自动滚动时留的上边 */
#define kMMBScrollTopPadding 15
- (void)scrollScrollView:(UIScrollView *)scrollView toVisible:(CGRect)rect animated:(BOOL)animated
{
    DLog(@" \n toVisibleRect:%@ \n  ",NSStringFromCGRect(rect));
    CGPoint pt = CGPointZero;
    //scroll view 可视高度
    int visibleHeight = CGRectGetHeight(scrollView.bounds);
    //scroll view 内容的总高度
    int totalHeight = scrollView.contentSize.height;
    //控件的上边 + padding
    int topY = CGRectGetMinY(rect) - kMMBScrollTopPadding;
    
    if (topY > (totalHeight - visibleHeight)) {
        //屏幕滚动到最底部可以显示下这个rect
        pt.y = totalHeight - visibleHeight;
    }
    else{
        //显示不下, 调整
        pt.y = topY;
    }
    if (pt.y < 0) {
        pt.y = 0;
    }
    
    DLog(@" \n setContentOffset:%@ \n  ",NSStringFromCGPoint(pt));
    [scrollView setContentOffset:pt animated:YES];
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    
}

//- (void)handleRemoteNotification:(PushNotification *)notification
//{
//
//}


- (void)viewDidPopped
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark Gesture 手势处理的回调和代理方法

- (void)tapGestureAction:(id)sender
{
    [self hideKeyboard];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //子类可以重写
    if ([touch.view isKindOfClass:[UIControl class]]) {
        return NO;
    }
    else{
        return YES;
    }
}
- (void)hideKeyboard
{
    [self.view endEditing:YES];
}


#pragma mark - 收到 url 链接
- (void)handleOpenUrlWithParameter:(NSDictionary *)parameter
{
    [HandeUrlUtil handleOpenUrlWithParameter:parameter fromNavViewController:self.navigationController];
}


- (void)markApiCallFromNotificationIfNeeded:(NSMutableDictionary *)filter {

}

- (void)markFromLinkFromHome:(NSMutableDictionary *)filter
{
    if (_fromLinkParam)
    {
        [filter addEntriesFromDictionary:_fromLinkParam];
        _fromLinkParam = nil;
    }
}

- (void)beforeApiInvocation:(NSString *)path {
    if (![BaseDataEngine isSilentApi:path]) {
        [self showWaitingIcon];
    }
}

- (void)afterApiInvocation:(NSString *)path {
    self.netFailView.tapGesture.enabled = YES;
    if (![BaseDataEngine isSilentApi:path]) {
        [self dismissWaitingIcon];
    }
}

- (void)apiForPath:(NSString *)path method:(NSString *)httpMethod parameter:(NSDictionary *)parameters responseModelClass:(Class)class onComplete:(APIComletionBlock)block {
    [self beforeApiInvocation:path];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [dict addEntriesFromDictionary:self.params];

    kWeakSelf
    kWeakObj(path)
    [BaseDataEngine apiForPath:path method:httpMethod parameter:dict responseModelClass:class onComplete:^(id response, id data, NSError *error) {
        //cleanup
        [weakSelf afterApiInvocation:path];
        
        //if it's not caused by a OnComplete, which means a network error
        if (!response && error) {
            if (![BaseDataEngine isSilentApi:weakObj]) {
                [Utility showNetworkErrorMsg:error];
            }
        }
        
        block(response, data, error);
    }];
}

//TODO:code review peijing
- (void)showNavigationBarSeparator:(BOOL)show {
    UINavigationBar *navBar = self.navigationController.navigationBar;
    UIImage *separatorImg;
    if (!show) {
        separatorImg = [[UIImage alloc] init];
    }
    navBar.shadowImage = separatorImg;
}

#pragma mark - 分享
//- (void)shareSns
//{
//    NSString * shareTitle = @"送你88元，来领投鸟安心理财";
//    NSString * shareText = @"年化收益8.8%-18%，安全可靠，透明可查，真正的第三方资金托管！";//分享内嵌文字
//    UIImage * shareImage = [UIImage imageNamed:@"defaultIcon"];//分享内嵌图片
//    
//    [self shareSnsWithShareTitle:shareTitle shareText:shareText shareImage:shareImage shareUrl:[CurrentUser urlForShare]];
//}
//
//- (void)shareSnsWithShareTitle:(NSString *)shareTitle shareText:(NSString *)shareText shareImage:(UIImage *)shareImage shareUrl:(NSString *)urlString
//{
//    shareImage = shareImage ? : [UIImage imageNamed:@"defaultIcon"];
//    
//    [UMSocialData defaultData].extConfig.title = safeEmpty(shareTitle);
//    NSString * extConfigShareText = [NSString stringWithFormat:@"%@ %@", shareText, urlString ? :[CurrentUser urlForShare]];
//    [UMSocialData defaultData].extConfig.sinaData.shareText = extConfigShareText;
//    [UMSocialData defaultData].extConfig.smsData.shareText = extConfigShareText;
//    [UMSocialData defaultData].urlResource.url = safeEmpty(urlString ? :[CurrentUser urlForShare]);
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                           appKey:UMENG_APP_KEY
//                                        shareText:safeEmpty(shareText)
//                                       shareImage:shareImage
//                                  shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToSms]
//                                         delegate:self];
//}

//下面得到分享完成的回调
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

@end
