//
//  BaseWebViewController.m
//  mmbang
//
//  Created by CuiPanJun on 14-8-19.
//  Copyright (c) 2014年 iyaya. All rights reserved.
//

#import "BaseWebViewController.h"
#import "UrlParamUtil.h"
//#import "ShareSnsUtil.h"
#import "UIBarButtonItem+ClearBackground.h"
#import "ChargeViewController.h"
#import "RechargeViewController.h"
#import "VerifyRealNameViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "LTNServerConstant.h"
#import "BaseJSAction.h"
#import "JSActionFactory.h"

#define TOOLBAR_ANIMATION_DURATION 0.3

NSString * const ShareURLKey = @"share_url";
NSString * const ShareImageURLKey = @"share_image";
NSString * const ShareTitleKey = @"share_title";
NSString * const ShareDescKey = @"share_desc";

@interface BaseWebViewController ()
{
    
    NSMutableData *_receivedData;
    UIAlertView *_alertView;
    
    // Actions
    NSMutableArray *_actionsDictArr;
    
    BOOL _lastNavBarHiddenStatus;
}

@property (nonatomic) BOOL showCloseBtn;
@property (nonatomic) BOOL didShowCloseBtn;

@end


@implementation BaseWebViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = self.navigationBarHidden;
    if (self.showRightCloseBtn) {
       [self createCloseButton];
    }
    
    
    if (self.isHaveRightBtn) {//show right button
        [self createShareButton];
    }
    
    if(_request){
        [_webView loadRequest:_request];
    }
    
}

-(void)createShareButton{
    
    UIButton *btn = [Utility createButtonWithTitle:@"•••" color:[UIColor blackColor] font:kFont(12) block:^(UIButton *btn) {
        [ShareSnsUtils shareSnsOnViewController:self shareTitle:self.shareName shareText:self.shareContent shareImage:self.shareIcon shareUrl:[NSString stringWithFormat:@"%@?mobile=%@",self.shareUrl,self.shareMobile] delegate:self];
//        kWeakSelf
//        
//        [ShareSheet showWithBlock:^(ShareSnsType type) {
//            ShareData * shareData= [[ShareData alloc] initWithData:@{
//                                                                     @"title" : self.shareName,
//                                                                     @"desc" : self.shareContent,
//                                                                     @"thumb" : self.shareIcon,
//                                                                     @"url" : [NSString stringWithFormat:@"%@?mobile=%@",self.shareUrl,self.shareMobile],
//                                                                     } type:type];
//            [[ShareSnsUtil mainSnsUtil] shareSnsWithData:shareData onVC:weakSelf];
//        }];
    }];
   
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    item.width = -5;
    
    self.navigationItem.rightBarButtonItems = @[item,rightBtn];
    
}


-(NSString *)shareName{
    
    if([esString(_shareName) length]==0)
        _shareName=[_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    return _shareName;
}

-(NSString *)shareContent{
    if([esString(_shareContent) length]==0)
        _shareContent=[_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByName('description')[0].content"];
    return _shareContent;
    
}

-(NSString *)shareUrl{
    if([esString(_shareUrl) length]==0)
        _shareUrl=_webView.request.URL.absoluteString;
    return _shareUrl;
}

-(NSString *)shareMobile{
    
    if (!_shareMobile) {
        _shareMobile = [CurrentUser mine].userInfo.mobile;
    }
    if (_shareMobile == NULL) {
        _shareMobile = @"*";
    }
    return _shareMobile;
}

-(void)createCloseButton{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 35, 20, 20, 20)];
    [btn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [btn setEnlargeEdge:20];
    [self.view addSubview:btn];
    
   
}

-(void)close{
    [self.navigationController popViewControllerAnimated:NO];
}
-(BOOL)prefersStatusBarHidden{
    if (self.showRightCloseBtn) {
        [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
  
        return YES;
    }
       return NO;
}
- (id)initWithURL:(NSString *)urlString{
    
    //urlString =@"/h5/market/index.html";
    //1.15 test
//    urlString = @"http://192.168.0.112:8080/h5/mer_recharge_person.vm";
    NSURL *url = [NSURL URLWithString:urlString];
    if (![url host]) {
        urlString = [NSString stringWithFormat:@"%@%@", API_BASE_URL, urlString];
        url = [NSURL URLWithString:urlString];
    }
    self = [self initWithRequest:[NSURLRequest requestWithURL:url]];
    if (self) {
        
    }
    return self;
}

- (id)initWithRequest:(NSURLRequest *)request{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        _request = request;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _hasRightNavItem = YES;
        _handleHostError = YES;
        _actionsDictArr = [[NSMutableArray alloc] init];
        [self setupActionDicts];
    }
    return self;
}

- (void)setupActionDicts{
    [_actionsDictArr removeAllObjects];
    
    [_actionsDictArr addObject:@{@"title":locationString(@"open_use_safar"),@"action":NSStringFromSelector(@selector(openWithSafari))}];
    [_actionsDictArr addObject:@{@"title":locationString(@"copy_link"),@"action":NSStringFromSelector(@selector(copyLink))}];
    [_actionsDictArr addObject:@{@"title":locationString(@"share"),@"action":NSStringFromSelector(@selector(share))}];
}

- (void)setupRightNavItem {
    //don't show right button
//    if (self.hasRightNavItem) {
//        [self setRightBarButtonItem:[UIBarButtonItem barItemWithImage:[[UIImage imageNamed:@"nav_more"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
//                                                       highlightImage:[[UIImage imageNamed:@"nav_more_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] target:self
//                                                               action:@selector(actionButtonClicked)]];
//        [self.navigationItem.rightBarButtonItem setEnabled:NO];
//    } else {
//        self.navigationItem.rightBarButtonItem = nil;
//    }
}

- (void)setShareInfo:(NSDictionary *)shareInfo{
    _shareInfo = shareInfo;
    [self setupActionDicts];
}

- (void)setHasRightNavItem:(BOOL)hasRightNavItem{
    _hasRightNavItem = hasRightNavItem;
    [self setupRightNavItem];
}

- (void)processUrl:(NSURL *)url
{
    NSDictionary *params = [UrlParamUtil getParamsFromUrl:url];

    if ([[params objectForKey:@"is_local"] boolValue]) {
        NSURLRequest *theRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        NSURLConnection *theConncetion=[[NSURLConnection alloc]
                                        initWithRequest:theRequest delegate:self];

        _receivedData=[NSMutableData data];

        [theConncetion start];
        [self showWaitingIcon];
    } else {

        [_webView loadRequest:self.request];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    //use default back btn
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithTitle:@"返回" image:[UIImage imageNamed:@"nav_return"] highlightImage:nil style:UIBarButtonItemStylePlain target:self action:@selector(back) space:4];

    [self setupRightNavItem];
    
    if (!_webView) {
        CGRect bounds = self.view.bounds;
        _webView = [[UIWebView alloc] initWithFrame:bounds];
        _webView.backgroundColor = [UIColor clearColor];
        _webView.delegate = self;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_webView setAllowsInlineMediaPlayback:YES];
        [_webView setMediaPlaybackRequiresUserAction:NO];
        _webView.scalesPageToFit = YES;
        
        [self.view addSubview:_webView];
    }
    NSURL *url = self.request.URL;
    if (url.absoluteString.length > 0) {
        if (self.handleHostError && ![Utility isHostAvailable:[url host]]) {
            self.hasNav = YES;
            self.navigationItem.rightBarButtonItem = nil;
            if (self.title.length == 0) {
                [self setCustomTitle:locationString(@"network_error")];
            }
        } else {
            [self processUrl:url];
        }
    }else{
        if (self.title.length == 0) {
            [self setCustomTitle:locationString(@"empyt_network_address")];
        }
    }

    [self updateViewFrame];
}

-(void)initUIView{
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
}

- (void)updateViewFrame{
    CGRect bounds = self.view.bounds;

    CGFloat offsetY = 0;
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        id<UILayoutSupport> topGuide = [self topLayoutGuide];
        offsetY = [topGuide length];
    }
    
    CGRect webVFrame = bounds;
    webVFrame.origin.y = offsetY;
    webVFrame.size.height = CGRectGetHeight(bounds) - offsetY;

    _webView.frame = webVFrame;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [self updateViewFrame];
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    DLog(@"%@ shouldStartLoadRequest:\n=====\n%@\n=====\n",self,request);
       
//    [[PiwikTracker sharedInstance1] sendEventWithCategory:@"webview" action:esString(request.URL.absoluteString) name:@"" value:@(0)];
    
    //[[PiwikTracker sharedInstance1] dispatch];
    
    

    //no close btn
//    if (self.showCloseBtn && !self.didShowCloseBtn) {
//        UIBarButtonItem *closeItem = [UIBarButtonItem barItemWithTitle:@"关闭" target:self action:@selector(closeWebView) andTextColor:nil andIsRight:NO];
//
//        NSArray *items = @[
//                           self.navigationItem.leftBarButtonItem,
//                           closeItem
//                           ];
//        self.navigationItem.leftBarButtonItems = items;
//        self.didShowCloseBtn = YES;
//    }

    BaseJSAction *action = [[JSActionFactory defaultFactory] makeAction:request.URL inWebView:webView inBaseController:self webUrlString:self.request.URL.absoluteString];
    
    if (action) {
        //TODO
        [action excute];
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self updateActionButtons];
    [self showWaitingIcon];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self dismissWaitingIcon];
    
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    if ([title length]) {
        [self setCustomTitleUntilAppear:title];
    }
    [self updateActionButtons];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self updateActionButtons];
    [self dismissWaitingIcon];

    [self alertError:error];
    
//    __weak id<UIAlertViewDelegate> delegate = self;
//    
//    if([error code] == NSURLErrorCancelled) {
//        return;
//    }
//    
//    if (!_alertView) {
//        _alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加载没有成功哦～～" delegate:delegate cancelButtonTitle:@"返回" otherButtonTitles:@"重试", nil];
//        [_alertView show];
//    }
}

- (void)alertError:(NSError *)error{
    
    //__weak id<UIAlertViewDelegate> delegate = self;
    
    if([error code] == NSURLErrorCancelled) {
        return;
    }


    NSString *cancelPrompt =locationString(@"cancel");
    if (!self.hasNav) {
        cancelPrompt = locationString(@"back");
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:locationString(@"hint") message:locationString(@"loading_failure") delegate:self cancelButtonTitle:cancelPrompt otherButtonTitles:locationString(@"try_again"), nil];
    [alertView show];
}

#pragma mark - ====== UIWebView Delegate End ======

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (!self.hasNav) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        if (self.presentingViewController) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    } else {
        [_webView loadRequest:self.request];
    }
    
    _alertView = nil;
}

- (void)updateActionButtons
{
    self.navigationItem.rightBarButtonItem.enabled = !_webView.isLoading;
}

#pragma mark - Target actions
- (void)goBackClicked
{
    [_webView goBack];
}

- (void)actionButtonClicked
{
    NSArray *buttonTitles = [_actionsDictArr valueForKeyPath:@"title"];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    for (NSString *title in buttonTitles) {
        [actionSheet addButtonWithTitle:title];
    }
    
    [actionSheet addButtonWithTitle:locationString(@"cancel")];
    actionSheet.cancelButtonIndex = buttonTitles.count;
    
    [actionSheet showInView:self.view.window];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if (buttonIndex < [_actionsDictArr count]) {
        NSDictionary *actionDict = [_actionsDictArr objectAtIndex:buttonIndex];
        NSString *selectorString = [actionDict objectForKey:@"action"];
        SEL action = NSSelectorFromString(selectorString);
        if ([self respondsToSelector:action] && action != @selector(share)) {
            [self performSelector:action];
        }
    }
#pragma clang diagnostic pop
    
    /*switch (buttonIndex) {
     case 0:
     [[UIApplication sharedApplication] openURL:_webView.request.URL];
     break;
     case 1: {
     UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
     pasteboard.string = _webView.request.URL.absoluteString;
     [Utility showMessage:@"复制成功"];
     break;
     }
     case 2:
     
     break;
     default:
     break;
     }*/
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if (buttonIndex < [_actionsDictArr count]) {
        NSDictionary *actionDict = [_actionsDictArr objectAtIndex:buttonIndex];
        NSString *selectorString = [actionDict objectForKey:@"action"];
        SEL action = NSSelectorFromString(selectorString);
        if ([self respondsToSelector:action] && action == @selector(share)) {
            [self performSelector:action];
        }
    }
#pragma clang diagnostic pop
    
}

#pragma mark - Actions

- (void)openWithSafari{
    [[UIApplication sharedApplication] openURL:_webView.request.URL];
}

- (void)copyLink{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _webView.request.URL.absoluteString;
    [Utility showMessage:locationString(@"copy_success")];
}

//- (void)share{
//    ShareSheet *actionSheet = [[ShareSheet alloc] initWithDelegate:self];
//    [actionSheet show];
//}

#pragma mark - Share
//- (void)shareSheet:(ShareSheet *)shareSheet clickedAtSnsType:(ShareSnsType)type
//{
//    [self share:type];
//}
//
//- (void)share:(ShareSnsType)type
//{
//    NSDictionary *dict = [self getShareData];
//    ShareData *share = [[ShareData alloc] initWithData:dict type:type];
//    [[ShareSnsUtil mainSnsUtil] shareSnsWithData:share onVC:self];
//}

- (NSDictionary *)getShareData{
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionary];
    //get share data from js
//    NSString *webPageShareInfoStr = [self.webView stringByEvaluatingJavaScriptFromString:@"mmb_getShareInfo(null)"];
//    NSDictionary *shareDict = [NSObject jsonStringToDict:webPageShareInfoStr];
//    if ([shareDict isKindOfClass:[NSDictionary class]]) {
//        
//        
//        mutDict[@"url"] = safeEmpty(shareDict[@"share_url"]);
//        mutDict[@"desc"] = safeEmpty(shareDict[@"share_desc"]);
//        mutDict[@"thumb"] = safeEmpty(shareDict[@"share_img_url"]);
//        mutDict[@"title"] = safeEmpty(shareDict[@"share_string"]);
//        
//    }else if (self.shareInfo) {
//        
//        mutDict[@"url"] = safeEmpty(self.shareInfo[ShareURLKey]);
//        mutDict[@"desc"] = safeEmpty(self.shareInfo[ShareDescKey]);
//        mutDict[@"thumb"] = safeEmpty(self.shareInfo[ShareImageURLKey]);
//        mutDict[@"title"] = safeEmpty(self.shareInfo[ShareTitleKey]);
//        
//    }else{
//        NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//        NSString *desc = [self.webView stringByEvaluatingJavaScriptFromString:@"getMetaDescription()"];
//        mutDict[@"url"] = safeEmpty(_webView.request.URL.absoluteString);
//        mutDict[@"desc"] = safeEmpty(desc);
//        mutDict[@"thumb"] = @"";
//        mutDict[@"title"] = safeEmpty(title);
//        
//    }
    return mutDict;
}

#pragma mark - Property Accessor

- (void)setRequest:(NSURLRequest *)request{
    if (_request == request) {
        return;
    }
    
    _request = [request copy];
    [_webView loadRequest:_request];
}

- (void)setHasNav:(BOOL)hasNav{
    [self setHasNav:hasNav animated:NO];
}

- (void)setHasNav:(BOOL)hasNav animated:(BOOL)animated{
    _hasNav = hasNav;
    if (!self.isViewLoaded) {
        return;
    }
    if (animated) {
        [UIView animateWithDuration:TOOLBAR_ANIMATION_DURATION delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self updateViewFrame];
        } completion:^(BOOL finished){
            
        }];
    }else{
        [self updateViewFrame];
    }
}

- (void)closeWebView {
    if (self.navigationController.visibleViewController == self) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)back
{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else {
        if(_returnRootViewController)
        {
            [[LTNCore globleCore] backToRootController:YES];
        }
        else
        {
        [super back];
        }
    }
    //    if (self.webView.canGoBack) {
//        [self.webView goBack];
//        self.showCloseBtn = YES;
//    } else {
//        [self closeWebView];
//    }
}



@end
