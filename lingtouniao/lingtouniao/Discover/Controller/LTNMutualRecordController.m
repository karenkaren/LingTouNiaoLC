
//
//  LTNMutualListRecordController.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/9/27.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNMutualRecordController.h"
#import "LTNListRecordCell.h"
#import "LTNServerConstant.h"

@interface LTNMutualRecordController ()

@property (nonatomic) NSInteger total;

@end

@implementation LTNMutualRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = locationString(@"product_buy_record");
    [self pullReload];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"PurchaseRecordCell";
    LTNListRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[LTNListRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.data = self.data[indexPath.row];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30 + kGeneralHeight)];
    headerView.backgroundColor = HexRGB(0xf9f9f9);
    
    UILabel * titleLabel = [Utility createLabel:[CustomerizedFont boldHeiti:16] color:[UIColor blackColor]];
    titleLabel.text = [NSString stringWithFormat:locationString(@"product_buy_record_txt"), @(self.total)];
    titleLabel.frame = CGRectMake(20, 0, kScreenWidth - 40, 30);
    [headerView addSubview:titleLabel];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 29, kScreenWidth, 0.5)];
    view.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [headerView addSubview:view];
    
    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, headerView.width, kGeneralHeight)];
    titleView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:titleView];
    
    NSArray * titles = @[locationString(@"invest_user"), locationString(@"invest_amount"), locationString(@"invest_time")];
    CGFloat margin = 10;
    CGFloat width = (kScreenWidth - 2 * 20 - margin * 2) / 3.0;
    for (int i = 0; i < titles.count; i++) {
        UILabel * titleLabel = [Utility createLabel:[CustomerizedFont heiti:16] color:[UIColor blackColor]];
        titleLabel.text = titles[i];
        titleLabel.frame = CGRectMake(20 + (width + margin) * i, 0, width, titleView.height);
        [titleView addSubview:titleLabel];
    }
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 69, kScreenWidth, 0.5)];
    view1.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [headerView addSubview:view1];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30 + kGeneralHeight;
}

- (void)getServiceData:(BOOL)isGetMore {
    [super getServiceData:isGetMore];
    
    kWeakSelf
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:@{@"productId" : self.productId}];
    [self apiForPath:kMemberListUrl method:kGetMethod parameter:dic responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        if (!error && [data[@"memberList"] count] > 0) {
            weakSelf.total = [[data valueForKey:@"totalCount"] integerValue];
            [weakSelf.data addObjectsFromArray:[data valueForKey:@"memberList"]];
        }
    }];
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
