//
//  ReplaceBankCardViewController.m
//  lingtouniao
//
//  Created by 徐凯 on 16/3/29.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "ReplaceBankCardViewController.h"
#import "ChangeCardViewControoler.h"
#import "MethodSecondViewController.h"
#import "FirstStepCell.h"
#import "SecondStepCell.h"
#import "TableViewDevider.h"
#import "ReplaceHeaderView.h"
#import "ShowSupplyViewController.h"

@interface ReplaceBankCardViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    UIButton *_submitButton;//开始换卡
    UIView *_footView;

}
@end

@implementation ReplaceBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
}
- (void)initUIView
{
    self.title = locationString(@"change_bank_card_title");
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f3f5f7"];
    [self setSubmitButton];
    [self setFooterView];
    [self setTableView];
   
}

-(void)setSubmitButton
{
    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_submitButton setTitle:locationString(@"begin_change_card") forState:UIControlStateNormal];
    [_submitButton setBackgroundImage:[UIImage imageNamed:@"confirmButton"] forState:UIControlStateNormal];
    [_submitButton addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    _submitButton.layer.masksToBounds = YES;
    _submitButton.layer.cornerRadius = 5;
}

-(void)setFooterView
{
    _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    _footView.backgroundColor = [UIColor colorWithHexString:@"#f3f5f7"];
    [_footView addSubview:_submitButton];
    [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_footView).offset(20);
        make.right.equalTo(_footView).offset(-20);
        make.top.equalTo(_footView.mas_top).offset(22);
        make.height.mas_equalTo(@44);
    }];
    
}

- (void)setTableView
{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.bounces = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"FirstStepCell" bundle:nil] forCellReuseIdentifier:@"firstStepCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"SecondStepCell" bundle:nil] forCellReuseIdentifier:@"secondStepCell"];
    _tableView.tableHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"ReplaceHeaderView" owner:nil options:nil] objectAtIndex:0];
    _tableView.tableFooterView = _footView;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;

}

/**
 *  开始换卡
 *
 *  @param sender <#sender description#>
 */
-(void)submitClick:(id)sender
{
    ChangeCardViewControoler *vc = [[ChangeCardViewControoler alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 230*kScreenWidth/375;
            break;
        case 1:
            return 513*kScreenWidth/375;
            break;
        default:
            return 0;
            break;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 1:
            return 20;
            break;
        default:
            return 0;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [TableViewDevider getHeaderView:NO];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        FirstStepCell *cell = [tableView dequeueReusableCellWithIdentifier:@"firstStepCell" forIndexPath:indexPath];
        return cell;
    }else if (indexPath.section == 1)
    {
        SecondStepCell *cell = [tableView dequeueReusableCellWithIdentifier:@"secondStepCell" forIndexPath:indexPath];
        return cell;
    }
    return nil;
}



@end
