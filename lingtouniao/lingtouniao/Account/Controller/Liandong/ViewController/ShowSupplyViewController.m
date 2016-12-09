//
//  ShowSupplyViewController.m
//  lingtouniao
//
//  Created by 徐凯 on 16/4/5.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "ShowSupplyViewController.h"
#import "ShowSupplyCell.h"
#import "SupplySuccessView.h"
#import "ReplaceView.h"

@interface ShowSupplyViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    ReplaceView *_replaceView;
}

@end

@implementation ShowSupplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUIView
{
    self.title = locationString(@"submit_success");
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f3f5f7"];
    [self setTableView];
}

- (void)setTableView
{
    CGFloat navibarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat tabbarHeight = self.navigationController.tabBarController.tabBar.frame.size.height;
    CGFloat statusHeight = [[UIApplication sharedApplication]statusBarFrame].size.height;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - navibarHeight - tabbarHeight - statusHeight)style:UITableViewStylePlain];

    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableHeaderView = [[[NSBundle mainBundle]loadNibNamed:@"SupplySuccessView"owner:nil options:nil]lastObject];
    _replaceView = [[ReplaceView alloc]init];
    [_replaceView.replaceButton setTitle:locationString(@"apply_ok_btn") forState:UIControlStateNormal];
    [_replaceView.replaceButton addTarget:self action:@selector(knownClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_replaceView];
    _tableView.tableFooterView = _replaceView;
;
   
    [_tableView registerNib:[UINib nibWithNibName:@"ShowSupplyCell" bundle:nil] forCellReuseIdentifier:@"showSupplyCell"];

    [self.view addSubview:_tableView];
}

- (void)knownClick:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 432.5*kScreenWidth/375;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShowSupplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"showSupplyCell" forIndexPath:indexPath];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
