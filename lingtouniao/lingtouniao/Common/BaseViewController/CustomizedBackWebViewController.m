//
//  CustomizedBackWebViewController.m
//  lingtouniao
//
//  Created by peijingwu on 1/9/16.
//  Copyright © 2016 lingtouniao. All rights reserved.
//

#import "CustomizedBackWebViewController.h"

@interface CustomizedBackWebViewController ()

@end

@implementation CustomizedBackWebViewController

- (void)back {
    
    if (![[self.webView.request.URL absoluteString] hasPrefix:API_BASE_URL]) {
        [super back];
        [LTNServerHelper retrieveUserInfoWithFinishBlock:nil];
        [LTNServerHelper retrieveAccountInfoWithFinishBlock:nil];
    } else {
        if (self.backBlock) {
            self.backBlock();
        } else {
            NSString *scriptString = [self.webView stringByEvaluatingJavaScriptFromString:
                                      @"document.getElementById(\"submitBtn\").getAttribute(\"onclick\")"];
            if (![scriptString length]) {
                [super back];
                return;
            }
            [self.webView stringByEvaluatingJavaScriptFromString:scriptString];
        }
    }
}

@end
