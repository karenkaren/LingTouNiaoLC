//
//  LTNMyCurrentDepositController.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/1/20.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNMyCurrentDepositController.h"
#import "LTNMyCurrentDepositCell.h"
#import "LTNRollInController.h"
#import "LTNRollOutController.h"
#import "LTNBaseDetailController.h"
#import "LTNBaseDetailRevseController.h"

#define kMyCurrentDepositCell @"MyCurrentDepositCell"

@interface LTNMyCurrentDepositController ()<LTNMyCurrentDepositCellDelegate>

{
    UIAlertView * _verifyRealNameAlertView;//实名认证弹窗
    UIAlertView * _boundBankCardAlertView;//银行卡认证弹窗
}

@property (nonatomic, strong) LTNMyCurrentDepositModel * currentDepositInfo;

@end

@implementation LTNMyCurrentDepositController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self pullReload];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = locationString(@"current_hold_amount");
    [self.tableView registerClass:[LTNMyCurrentDepositCell class] forCellReuseIdentifier:kMyCurrentDepositCell];
    self.tableView.hidden = YES;
}

- (void)getServiceData:(BOOL)isGetMore
{
    [super getServiceData:isGetMore];
    kWeakSelf
    [self apiForPath:kCurrentDepositUrl method:kGetMethod parameter:nil responseModelClass:[LTNMyCurrentDepositModel class] onComplete:^(id response, id data, NSError *error) {
        if (!error) {
            weakSelf.tableView.hidden = NO;
            weakSelf.currentDepositInfo = data;
            [weakSelf.data addObject:data];
            [weakSelf.tableView reloadData];
            return;
        }
    }];
}

#pragma mark 返回
- (void)back
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshMyCurrentDepositWithRemainAmount:)]) {
        [self.delegate refreshMyCurrentDepositWithRemainAmount:self.currentDepositInfo.current_remain_amount];
    }
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshInvestPage];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LTNMyCurrentDepositCell * cell = [[LTNMyCurrentDepositCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMyCurrentDepositCell];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.currentDepositInfo = self.currentDepositInfo;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kMyCurrentDepositCellHeight;
}

#pragma mark - cell代理方法
- (void)myCurrentDepositCellWillShowTotalIncome
{
    DLog(@"活期收益明细");
    LTNBaseDetailRevseController * currentIncomeDetailController = [[LTNBaseDetailRevseController alloc] init];
    currentIncomeDetailController.naviTitle = locationString(@"current_details");
    currentIncomeDetailController.apiPath = kCurrentIncomeListUrl;
    currentIncomeDetailController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:currentIncomeDetailController animated:YES];
}

#pragma mark 转入
- (void)myCurrentDepositCellWillRoolIn
{
    if ([self verifyRealNameandboundBank]) {
        LTNRollInController * rollInController = [[LTNRollInController alloc] init];
        rollInController.currentDepositInfo = self.currentDepositInfo;
        [self.navigationController pushViewController:rollInController animated:YES];
    }
}

#pragma mark 转出
- (void)myCurrentDepositCellWillRoolOut
{
//    if ([self verifyRealNameandboundBank]) {
        LTNRollOutController * rollOutController = [[LTNRollOutController alloc] init];
        rollOutController.currentDepositInfo = self.currentDepositInfo;
        [self.navigationController pushViewController:rollOutController animated:YES];
//    }
}

#pragma mark - 验证是否完成用户认证、银行卡认证
-(BOOL)verifyRealNameandboundBank
{
    if(![CurrentUser verifyedRealName])
    {
        _verifyRealNameAlertView = [[UIAlertView alloc] initWithTitle:nil message:locationString(@"realname_text") delegate:self cancelButtonTitle:locationString(@"cancel") otherButtonTitles:locationString(@"next"), nil];
        [_verifyRealNameAlertView show];
        return NO;
    }
    else if(![CurrentUser bindedBankCard])
    {
        _boundBankCardAlertView = [[UIAlertView alloc] initWithTitle:nil message:locationString(@"bindbank_text") delegate:self cancelButtonTitle:locationString(@"cancel") otherButtonTitles:locationString(@"next"), nil];
        [_boundBankCardAlertView show];
        return NO;
    }
    return YES;
}

#pragma mark alertView delegate
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView == _verifyRealNameAlertView) {
        if (buttonIndex == 1)
        {
            [LTNCore verifyRealNameViewController:nil];
        }
    }
    if (alertView == _boundBankCardAlertView) {
        if (buttonIndex == 1)
        {
            [LTNCore boundBankCardViewController:nil];
        }
    }
}

@end
