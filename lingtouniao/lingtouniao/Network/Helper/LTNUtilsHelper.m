//
//  LTNUtilsHelper.m
//  lingtouniao
//
//  Created by LiuFeifei on 15/11/19.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNUtilsHelper.h"
#import "AppDelegate.h"
#import "LTNLoginController.h"

@implementation LTNUtilsHelper

#pragma mark - 提示框
#pragma mark 提示框，定时消失
+ (void)boxShowWithMessage:(NSString *)message onView:(UIView *)view duration:(NSTimeInterval)duration
{
    CGSize size = [message boundingRectWithSize:CGSizeMake(view.bounds.size.width - 80, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFont(18)} context:nil].size;
    CGFloat width = size.width + 40;
    CGFloat height = size.height + 30;
    
    UIView * textView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    textView.backgroundColor = [UIColor blackColor];
    textView.alpha = 0.7;
    textView.layer.cornerRadius = 10;
    textView.layer.masksToBounds = YES;
    textView.center = CGPointMake(view.bounds.size.width * 0.5, view.bounds.size.height * 0.5);
    
    UILabel * messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, size.width, size.height)];
    messageLabel.font = kFont(18);
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.text = message;
    messageLabel.numberOfLines = 0;
    [textView addSubview:messageLabel];
    [view addSubview:textView];
    
    [UIView animateWithDuration:duration animations:^{
        textView.alpha = 0;
    } completion:^(BOOL finished) {
        [textView removeFromSuperview];
    }];
}

+ (void)boxShowWithMessage:(NSString *)message duration:(NSTimeInterval)duration
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [self boxShowWithMessage:message onView:window duration:duration];
}

+ (void)boxShowWithMessage:(NSString *)message onView:(UIView *)view
{
    [self boxShowWithMessage:message onView:view duration:2.5f];
}

+ (void)boxShowWithMessage:(NSString *)message
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [self boxShowWithMessage:message onView:window duration:2.5f];
}

#pragma mark 提示框，网络访问时出现，访问成功消失
+ (void)boxShowLoadWithMessage:(NSString *)message onView:(UIView *)view
{
    UIView * boxView = [[UIView alloc] init];
    boxView.backgroundColor = [UIColor blackColor];
    boxView.alpha = 0.7;
    boxView.tag = 70000;
    CGSize size = [message boundingRectWithSize:CGSizeMake(view.bounds.size.width - 80, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kFont(18)} context:nil].size;
    CGFloat width = size.width + 40;
    CGFloat height = size.height + 30 + 60;
    boxView.bounds = CGRectMake(0, 0, width, height);
    boxView.center = CGPointMake(view.bounds.size.width * 0.5, view.bounds.size.height * 0.5);
    boxView.layer.cornerRadius = 5;
    boxView.layer.masksToBounds = YES;
    [view addSubview:boxView];
    
    UILabel * messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, size.width + 20, size.height + 10)];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.text = message;
    messageLabel.numberOfLines = 0;
    messageLabel.font = kFont(18);
    [boxView addSubview:messageLabel];
    
    UIActivityIndicatorView * activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((width - 40) / 2, 20, 40, 40)];
    activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    activityView.tintColor = [UIColor whiteColor];
    [activityView startAnimating];
    [boxView addSubview:activityView];
}

+ (void)boxShowLoadWithMessage:(NSString *)message
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [self boxShowLoadWithMessage:message onView:window];
}

+ (void)removeLoadMessageBoxFromView:(UIView *)view
{
    UIView * boxView = [view viewWithTag:70000];
    [boxView removeFromSuperview];
}

+ (void)removeLoadMessageBox
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self removeLoadMessageBoxFromView:window];
}

#pragma mark 网络相关
+ (void)openNetwork:(UIViewController *)viewController
{
    [self boxShowWithMessage:locationString(@"open_network")];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                    message:@"请进入设置进行联网操作" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
//    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
//        if (buttonIndex == 1) {
//            //TODO: UIApplicationOpenSettingsURLString只在ios8中有
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//        }
//    }];
}

+ (void)actionWhenLogin:(VoidBlock)block onVC:(UIViewController *)vc {
    if ([[CurrentUser mine] hasLogged]) {
        // 如果用户已经登录，跳转到理财金券页面
        if (block) {
            block();
        }
    } else {
        // 如果用户未登录，跳转到登录页面
        [[LTNCore globleCore] loginController:^(void){
            if (block) {
                block();
            }

        }];
        
        /*
        LTNLoginController * loginController = [LTNLoginController loginControllerWithFinishBlock:^{
            if (block) {
                block();
            }
        }];
        UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:loginController];
        [vc presentViewController:navController animated:YES completion:nil];
         */
    }
}

+ (void)actionWhenLogin:(VoidBlock)block
{
    [self actionWhenLogin:block onVC:nil];
}

@end
