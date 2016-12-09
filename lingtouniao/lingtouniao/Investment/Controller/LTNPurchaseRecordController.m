//
//  LTNPurchaseRecordController.m
//  lingtouniao
//
//  Created by LiuFeifei on 15/12/25.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNPurchaseRecordController.h"
#import "LTNServerConstant.h"
#import "LTNPurchaseRecordCell.h"

@interface LTNPurchaseRecordController ()

@property (nonatomic) NSInteger total;

@end

@implementation LTNPurchaseRecordController

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
    LTNPurchaseRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[LTNPurchaseRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
//        [titleLabel sizeToFit];
//        titleLabel.centerY = titleView.height * 0.5;
        titleLabel.frame = CGRectMake(20 + (width + margin) * i, 0, width, titleView.height);
        
//        if (i == 0) {
//            titleLabel.left = 20;
//        } else if (i == 1) {
//            titleLabel.left = 120;
//        } else {
//            titleLabel.left = 200;
//        }
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
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:@{@"productId" : @(self.productId)}];
    [self apiForPath:kPurchaseHistoryUrl method:kGetMethod parameter:dic responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        if (!error && [data[@"purchaseHistoryList"] count] > 0) {
            weakSelf.total = [[data valueForKey:@"totalCount"] integerValue];
            [weakSelf.data addObjectsFromArray:[data valueForKey:@"purchaseHistoryList"]];
        }
    }];
}

@end
