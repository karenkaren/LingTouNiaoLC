//
//  BaseJSAction.h
//  webFramework
//
//

#import <Foundation/Foundation.h>

#define kWebCacheFolderName @"webCache"

@class BaseViewController;

@interface BaseJSAction : NSObject
{
    
}

@property (nonatomic, copy)   NSString *callback;
@property (nonatomic, retain) BaseViewController *baseViewController;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic,strong) NSString *urlString;
@property (nonatomic, retain) NSDictionary *params;
@property (nonatomic, retain) NSString *method;

@property (nonatomic, copy) void(^dismisscallback)();



- (id)initInWebView:(UIWebView *)webView inBaseViewController:(BaseViewController *)baseViewController urlString:(NSString *)urlString;

- (void)excute;
- (void)excuteCallback:(NSDictionary *)result;

@end

@interface BaseJSAction(UIWebViewShowEvent)

+ (NSString *)webViewWillShow:(UIWebView *)webView params:(NSDictionary *)params;

@end
