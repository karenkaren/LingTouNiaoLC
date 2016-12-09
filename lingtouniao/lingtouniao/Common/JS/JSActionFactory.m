//
//  JSActionFactory.m
//  webFramework
//
//

#import "JSActionFactory.h"
#import "UrlParamUtil.h"
#import "JSONKit.h"
#import "UtilJSAction.h"

@implementation JSActionFactory

+ (JSActionFactory *)defaultFactory;
{
    static JSActionFactory *factory = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        factory = [[JSActionFactory alloc] init];
    });
    
    return factory;
}

- (id)init
{
    self = [super init];
    if (self) {
        _actionArray = [[NSMutableArray alloc] init];
        self.backup = [[NSMutableDictionary alloc] init];
        
        _actionClassNames = [[NSMutableDictionary alloc] init];
        
        [_actionClassNames setObject:NSStringFromClass([UtilJSAction class]) forKey:@"util"];
    }
    
    return self;
}

- (BaseJSAction *)makeAction:(NSURL *)url inWebView:(UIWebView *)webView inBaseController:(BaseViewController *)baseViewController webUrlString:(NSString *)urlString
{
    BaseJSAction *action = nil;
    NSString *requestUrl = [NSString stringWithFormat:@"%@", url];
    
    
    if ([requestUrl rangeOfString:@"callclient"].location != NSNotFound) {
        NSDictionary *params = [UrlParamUtil getParamsFromUrl:url];
        NSString *class = [params objectForKey:@"class"] ? [params objectForKey:@"class"] : @"util";
        
        if (class && [_actionClassNames objectForKey:class]) {
            NSString *className = [_actionClassNames objectForKey:class];
            action = [[NSClassFromString(className) alloc] initInWebView:webView inBaseViewController:baseViewController urlString:urlString];
            
            action.callback = [params objectForKey:@"callback"];
            action.method = [params objectForKey:@"method"];
            
            NSString *param = [params objectForKey:@"param"];
            if (param) {
                NSData *JSONData = [param dataUsingEncoding:NSUTF8StringEncoding];
                action.params = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
            }
        }
    }
    
    return action;
}

- (void)addJSAction:(BaseJSAction *)action
{
    [_actionArray addObject:action];
}
- (void)removeJSAction:(BaseJSAction *)action
{
    [_actionArray removeObject:action];
}

#pragma mark -

- (void)registerActionClass:(Class)actionClass forKey:(NSString *)key{
    if (key == nil) {
        return;
    }
    
    if (actionClass == NULL) {
        [_actionClassNames removeObjectForKey:key];
    } else {
        [_actionClassNames setObject:NSStringFromClass(actionClass) forKey:key];
    }
}

@end
