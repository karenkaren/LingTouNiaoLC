//
//  ShareSnsUtils.h
//  lingtouniao
//
//  Created by LiuFeifei on 16/7/26.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocial.h"

@interface ShareSnsUtils : NSObject

#pragma mark - shareSns
+ (void)shareSnsOnViewController:(UIViewController *)viewController delegate:(id<UMSocialUIDelegate>)delegeta;
+ (void)shareSnsOnViewController:(UIViewController *)viewController shareTitle:(NSString *)shareTitle shareText:(NSString *)shareText shareImage:(NSString *)shareImage shareUrl:(NSString *)shareUrl delegate:(id<UMSocialUIDelegate>)delegate;

@end
