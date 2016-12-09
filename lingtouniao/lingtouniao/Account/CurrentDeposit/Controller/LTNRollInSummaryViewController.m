//
//  LTNRollInSummaryViewController.m
//  lingtouniao
//
//  Created by peijingwu on 2/21/16.
//  Copyright © 2016 lingtouniao. All rights reserved.
//

#import "LTNRollInSummaryViewController.h"
#import "CustomizedBackWebViewController.h"
#import "LTNRollInSuccessController.h"
#import "TableViewDevider.h"

#define kTableRowHeight 49
#define kTableHeaderHeight 10

@interface LTNRollInSummaryViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray * titlesArray;
@property (nonatomic, strong) NSArray * datasArray;
@property (nonatomic, strong) UITableView * table;

@end

@implementation LTNRollInSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = locationString(@"confirm_buy");
    NSString * amount = [NSString stringWithFormat:locationString(@"amount_yuan_decimal"), [self.params[@"amount"] doubleValue]];
    NSString * holdAmount = [NSString stringWithFormat:locationString(@"amount_yuan_decimal"), [self.params[@"holdAmount"] doubleValue]];
    NSString * revenue = [NSString stringWithFormat:locationString(@"amount_yuan_decimal"), [self.params[@"revenue"] doubleValue]];
    self.titlesArray = @[locationString(@"current_buy_in"), locationString(@"current_buy_out"), locationString(@"current_buy_tomorrow")];
    self.datasArray = @[amount, holdAmount, revenue];
    [self setupUI];

}

- (void)setupUI
{
    CGFloat height = kTableRowHeight * self.titlesArray.count + kTableHeaderHeight;
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height) style:UITableViewStylePlain];
    self.table.scrollEnabled = NO;
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.allowsSelection = NO;
    [self.view addSubview:self.table];
    
    UIButton * confirmButton = [Utility createButtonWithTitle:locationString(@"btn_confirm_yes") color:[UIColor whiteColor] font:[CustomerizedFont heiti:18] block:^(UIButton *btn) {
        
        [TrackingUtility event:kHQClicked];
        double amount = [self.params[@"amount"] doubleValue];
        NSMutableDictionary * dicM = [NSMutableDictionary dictionaryWithDictionary:@{@"order_amount" : @(amount)}];
        kWeakSelf
        btn.enabled = NO;
        [self apiForPath:kCurrentRollInUrl method:kPostMethod parameter:dicM responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
            btn.enabled = YES;
            if (!error) {
                LTNRollInSuccessController * successController = [[LTNRollInSuccessController alloc] init];
                successController.rollInAmount = [self.params[@"amount"] doubleValue];
                [weakSelf.navigationController pushViewController:successController animated:YES];
            }
        }];
    }];
    [confirmButton setDisenableBackgroundColor:HexRGB(0xcccccc) enableBackgroundColor:HexRGB(kMainColor)];
    confirmButton.top = self.table.bottom + kGeneralHeight * 0.5;
    confirmButton.width = kScreenWidth - kGeneralHeight;
    confirmButton.left = kGeneralHeight * 0.5;
    confirmButton.height = kGeneralHeight;
    confirmButton.layer.cornerRadius = 5;
    confirmButton.layer.masksToBounds = YES;
    [self.view addSubview:confirmButton];
    
    if ([self.table respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.table setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.table respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.table setLayoutMargins:UIEdgeInsetsZero];
    }}

#pragma mark table datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"RollInSummaryCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [CustomerizedFont heiti:16];
        cell.textLabel.textColor = HexRGB(0x6a6a6a);
        cell.detailTextLabel.font = [CustomerizedFont heiti:16];
        cell.detailTextLabel.textColor = HexRGB(0x3a3a3a);
    }
    
    cell.textLabel.text = self.titlesArray[indexPath.row];
    cell.detailTextLabel.text = self.datasArray[indexPath.row];
    
    return cell;
}

#pragma mark table delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kTableHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [TableViewDevider getHeaderViewWithHeight:kTableHeaderHeight showTopLine:YES showBottomLine:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
