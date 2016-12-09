//
//  ChangeCardViewControoler.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/5/5.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "ChangeCardViewControoler.h"
#import "NSStringUtil.h"
#import "CustomizedBackWebViewController.h"

@implementation ChangeCardViewControoler

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)initUIView
{
    self.title = locationString(@"bank_card_setting");
}

- (void)confirmClick:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    NSString *textString = [self.cardIdTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSDictionary *dict = @{@"cardId" : safeEmpty(textString) , @"belongBank" : safeEmpty(self.selectBankField.text)};
    
    sender.enabled = NO;
    kWeakSelf
    [self apiForPath:kChangeCardUrl method:kPostMethod parameter:dict responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        sender.enabled = YES;
        if (!error) {
            CustomizedBackWebViewController * baseWebViewController = [[CustomizedBackWebViewController alloc] initWithURL:[data valueForKey:@"url"]];
            baseWebViewController.returnRootViewController = YES;
            [weakSelf.navigationController pushViewController:baseWebViewController animated:YES];
        }
    }];
}

@end
