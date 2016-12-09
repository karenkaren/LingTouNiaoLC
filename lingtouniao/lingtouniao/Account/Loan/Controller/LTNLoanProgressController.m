//
//  LTNLoanProgressController.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/3/25.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNLoanProgressController.h"
#import "LTNLoanProgressCell.h"
#import "LTNLoanProgressModel.h"
#import "LoanListViewController.h"

@interface LTNLoanProgressController ()

@property (nonatomic, strong) UIButton * footerButton;

@end

@implementation LTNLoanProgressController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = locationString(@"borrow_status");
    [self addHeaderView];
    [self addFooterView];
    self.tableView.hidden = YES;
    [self pullReload];
}

#pragma mark tableView的header、footer视图
- (void)addHeaderView
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 15 + 22)];
    headerView.backgroundColor = BACKGROUND_COLOR;
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, headerView.width, 0.5)];
    lineView.backgroundColor = HexRGB(0xe2e2e2);
    [headerView addSubview:lineView];
    UIView * whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, lineView.bottom, lineView.width, headerView.height - lineView.bottom)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:whiteView];
    self.tableView.tableHeaderView = headerView;
}

- (void)addFooterView
{
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 66)];
    footerView.backgroundColor = BACKGROUND_COLOR;
    UIButton * footerButton = [Utility createButtonWithTitle:locationString(@"btn_confirm") color:[UIColor whiteColor] font:[CustomerizedFont heiti:20] block:nil];
    footerButton.backgroundColor = HexRGB(kMainColor);
    footerButton.layer.cornerRadius = 5;
    footerButton.layer.masksToBounds = YES;
    footerButton.frame = CGRectMake(10, 22, footerView.width - 20, 44);
    [footerView addSubview:footerButton];
    self.footerButton = footerButton;
    self.tableView.tableFooterView = footerView;
}

#pragma mark 刷新数据
- (void)getServiceData:(BOOL)isGetMore
{
    [super getServiceData:isGetMore];
    
    kWeakSelf
    [self apiForPath:kLoanQuery method:kGetMethod parameter:nil responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        if (!error) {
            self.tableView.hidden = NO;
            NSDictionary * dic = [data[@"intents"] firstObject];
            if (![dic[@"valid_tag"] boolValue]) {
                [self.footerButton setTitle:locationString(@"btn_resubmit") forState:UIControlStateNormal];
                [self.footerButton addTarget:self action:@selector(applyAgain:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                [self.footerButton setTitle:locationString(@"btn_confirm") forState:UIControlStateNormal];
                [self.footerButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
            }
            LTNLoanProgressModel * loanModel = [[LTNLoanProgressModel alloc] initWithData:dic];
            [weakSelf.data addObjectsFromArray:loanModel.datas];
        }
    }];
}

- (void)back
{
    [self.navigationController setNavigationBarHidden:YES];
  //  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshAccountInfo];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark 重新申请
- (void)applyAgain:(UIButton *)sender {
    DLog(@"重新申请");
    LoanListViewController * controller = [[LoanListViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"LoacProgressCell";
    LTNLoanProgressCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[LTNLoanProgressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.data = self.data[indexPath.row];

    if (indexPath.row == self.data.count - 1) {
        cell.hiddenBottomLine = YES;
    }
    
    return cell;
}

#pragma mark tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kLoanProgressCellHeight;
}

@end
