//
//  LTNRollOutSuccessController.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/1/21.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNRollOutSuccessController.h"
#import "LTNPromptView.h"
#import "LTNMyCurrentDepositController.h"
#import "LTNSuccessView.h"

@interface LTNRollOutSuccessController ()

@end

@implementation LTNRollOutSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = locationString(@"acount_out_success");
    [self setupUI];
}

- (void)setupUI
{
    LTNSuccessView * successView = [[LTNSuccessView alloc] initWithSuccessTitle:locationString(@"cong_suixintou") buttonTitle:locationString(@"complete_out") actionBlock:^(UIButton *button) {
        [self back];
    }];
    successView.prompt = locationString(@"roll_out_success_prompt");
    [self.view addSubview:successView];
}

- (void)back
{
    NSArray * array = self.navigationController.childViewControllers;
    for (UIViewController * vc in array) {
        if ([vc isKindOfClass:[LTNMyCurrentDepositController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
}

@end
