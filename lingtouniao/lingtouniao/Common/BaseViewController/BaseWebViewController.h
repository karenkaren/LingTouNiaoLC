//
//  BaseWebViewController.h
//  mmbang
//
//  Created by CuiPanJun on 14-8-19.
//  Copyright (c) 2014年 iyaya. All rights reserved.
//

#import "BaseViewController.h"
#import "UMSocial.h"

// 此视图控制器用一个webview 加载指定urlString，urlString中可以带额外参数：
// 支持的参数有：
// is_local : 支持缓存urlString页面（使用request下载urlString指定的html页面，缓存在客户端，再使用webview加载htmlString）

@interface BaseWebViewController : BaseViewController<UIWebViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate, UMSocialUIDelegate>
{
    UIWebView *_webView;
    BOOL _hasNav;
}

@property (nonatomic, assign) BOOL navigationBarHidden;
@property (nonatomic, assign) BOOL returnRootViewController;
//@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSURLRequest *request;
@property (nonatomic, readonly) UIWebView *webView;
@property (nonatomic, assign) BOOL hasNav;  // 是否显示native UINavigationBar
@property (nonatomic, assign) BOOL hasRightNavItem;
@property (nonatomic) BOOL handleHostError;
@property (nonatomic) BOOL showRightCloseBtn;
@property (nonatomic, retain) NSDictionary *shareInfo;

@property (nonatomic, assign) BOOL isHaveRightBtn;//right button

@property (nonatomic, copy)NSString *shareName;//分享主题
@property (nonatomic, copy)NSString *shareIcon;//分享图片
@property (nonatomic, copy)NSString *shareUrl;//分享链接
@property (nonatomic, copy)NSString *shareContent;//分享内容
@property (nonatomic, copy)NSString *shareMobile;//手机号

- (id)initWithURL:(NSString *)urlString;
- (id)initWithRequest:(NSURLRequest *)request;

- (void)alertError:(NSError *)error;

@end

extern NSString * const ShareURLKey;
extern NSString * const ShareImageURLKey;
extern NSString * const ShareTitleKey;
extern NSString * const ShareDescKey;