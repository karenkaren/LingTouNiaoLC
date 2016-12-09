//
//  LTNRollInSuccessController.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/2/23.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNRollInSuccessController.h"
#import "LTNMyCurrentDepositController.h"
#import "LTNRollInSuccessCell.h"
#import "TableViewDevider.h"

@interface LTNRollInSuccessController ()

@end

@implementation LTNRollInSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = locationString(@"current_account_out_success");
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    [self addFooterView];
}

- (void)addFooterView
{
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 66)];
    footerView.backgroundColor = BACKGROUND_COLOR;
    UIView *tpLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1.0/[UIScreen mainScreen].scale)];
    tpLine.backgroundColor = DEVIDE_LINE_COLOR;
    [footerView addSubview:tpLine];

    UIButton * checkButton = [Utility createButtonWithTitle:locationString(@"current_account_check_success") color:[UIColor whiteColor] font:[CustomerizedFont heiti:20] block:^(UIButton *btn) {
        [self back];
        
    }];
    checkButton.frame = CGRectMake(10, 22, kScreenWidth - 10 * 2, 44);
    checkButton.layer.cornerRadius = 5;
    checkButton.layer.masksToBounds = YES;
    checkButton.backgroundColor = HexRGB(kMainColor);
    [footerView addSubview:checkButton];
    
    self.tableView.tableFooterView = footerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"RollInSuccessCell";
    LTNRollInSuccessCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[LTNRollInSuccessCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.rollInAmount = self.rollInAmount;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRollInSuccessCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [TableViewDevider getHeaderViewWithHeight:15 showTopLine:YES showBottomLine:YES];
}

- (void)back
{
    [TrackingUtility event:kHQSuccess];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"needToRefreshAccountInfo"];
    NSArray * array = self.navigationController.childViewControllers;
    for (UIViewController * vc in array) {
        if ([vc isKindOfClass:[LTNMyCurrentDepositController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
}

@end
