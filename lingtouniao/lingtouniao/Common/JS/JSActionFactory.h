//
//  JSActionFactory.h
//  webFramework
//
//

#import <Foundation/Foundation.h>
#import "BaseJSAction.h"

@interface JSActionFactory : NSObject
{
    NSMutableDictionary *_actionClassNames;
    NSMutableArray *_actionArray;
}

@property (atomic) NSMutableDictionary *backup;
@property (atomic) UIWebView *currentWebView;

- (void)registerActionClass:(Class)actionClass forKey:(NSString *)key;

+ (JSActionFactory *)defaultFactory;
- (void)addJSAction:(BaseJSAction *)action;
- (void)removeJSAction:(BaseJSAction *)action;
- (BaseJSAction *)makeAction:(NSURL *)url inWebView:(UIWebView *)webView inBaseController:(BaseViewController *)baseViewController webUrlString:(NSString *)urlString;

@end
