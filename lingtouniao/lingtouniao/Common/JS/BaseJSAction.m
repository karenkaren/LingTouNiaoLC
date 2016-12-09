//
//  BaseJSAction.m
//  webFramework
//
//

#import "BaseJSAction.h"
#import "JSActionFactory.h"

@implementation BaseJSAction

- (id)initInWebView:(UIWebView *)webView inBaseViewController:(BaseViewController *)baseViewController urlString:(NSString *)urlString
{
    self = [super init];
    
    if(self) {
        self.webView = webView;
        self.baseViewController = baseViewController;
        self.urlString=urlString;
    }
    
    return self;
}

- (void)excute
{
    if (self.method != nil) {
        [[JSActionFactory defaultFactory] addJSAction:self];
        
        SEL sel = NSSelectorFromString(self.method);
        
        if ([self respondsToSelector:sel]) {
            [self performSelector:sel withObject:nil afterDelay:0];
        }
    }
}

- (void)excuteCallback:(NSDictionary *)result
{
    if (self.callback) {
        if (result == nil) {
            result = @{};
        }
        NSString *param = [Utility jsonStringWithObject:result];
        
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@('%@')", self.callback, param]];
    }
    
    [[JSActionFactory defaultFactory] removeJSAction:self];
}

@end


@implementation BaseJSAction (UIWebViewShowEvent)

+ (NSString *)webViewWillShow:(UIWebView *)webView params:(NSDictionary *)params{
    NSString *scriptString = @"new NativeApi().raiseEvent('onBackedShow');";
    NSString *resultString = [webView stringByEvaluatingJavaScriptFromString:scriptString];
    return resultString;
}

@end
