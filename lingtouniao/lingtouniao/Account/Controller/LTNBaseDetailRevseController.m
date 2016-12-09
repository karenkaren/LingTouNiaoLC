//
//  LTNBaseDetailRevseController.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/3/24.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNBaseDetailRevseController.h"
#import "LTNBaseDetailRevseCell.h"
#import "LTNBaseDetailCellModel.h"


#define kSectionHeaderHeight 228

@interface LTNBaseDetailRevseController ()

@property (nonatomic) BOOL loadSucceeds;
@property (nonatomic) NSString * total;
@property (nonatomic) NSString *lastTotal;

@end

@implementation LTNBaseDetailRevseController



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.loadSucceeds) {
        [self pullReload];
    }
}

- (void)refreshIfNeeded {
    if (!self.loadSucceeds) {
        [self pullReload];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.naviTitle;
    self.tableView.hidden = YES;
    self.tableView.backgroundColor = kRGBColor(247, 247, 247);

}

- (void)getServiceData:(BOOL)isGetMore
{
    [super getServiceData:isGetMore];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.extraParams];
    
    [self apiForPath:self.apiPath method:kGetMethod parameter:dic responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        if (!error) {
            self.tableView.hidden = NO;
            LTNBaseDetailCellModel * model = [[LTNBaseDetailCellModel alloc] initWithData:data];
            self.total = model.total;
            [self.data addObjectsFromArray:model.datas];
            if (self.data.count) {
                self.loadSucceeds = YES;
            }
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"DetailCell";
    LTNBaseDetailRevseCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[LTNBaseDetailRevseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.data = self.data[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kSectionHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSectionHeaderHeight)];
    sectionHeaderView.backgroundColor =  kRGBColor(247, 247, 247);
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSectionHeaderHeight )];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kSectionHeaderHeight)];
    imageView.image = [UIImage imageNamed:@"icon_bg"];
    imageView.autoresizingMask =
    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
    [headerView addSubview:imageView];
    [headerView sendSubviewToBack:imageView];
    [sectionHeaderView addSubview:headerView];
    
    UILabel * totalLabel = [Utility createLabel:[CustomerizedFont systemFontOfSize:40] color:[UIColor colorWithHexString:@"#EA5504"]];
    totalLabel.text = self.total;
    [totalLabel sizeToFit];
    totalLabel.center = CGPointMake(headerView.centerX, headerView.height / 3);
    [headerView addSubview:totalLabel];
    
    UILabel * titleLabel = [Utility createLabel:[CustomerizedFont heiti:16] color:[UIColor colorWithHexString:@"#3A3A3A"]];
    titleLabel.text = locationString(@"total_amount");
    [titleLabel sizeToFit];
    titleLabel.center = CGPointMake(headerView.centerX, headerView.height * 3/5);
    [headerView addSubview:titleLabel];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.height - 0.5, headerView.width, 0.5)];
    lineView.backgroundColor = HexRGB(0xcccccc);
    [headerView addSubview:lineView];
    
    UILabel *leftLabel = [Utility createLabel:[CustomerizedFont heiti:16] color:[UIColor blackColor]];
    leftLabel.frame = CGRectMake(15, kSectionHeaderHeight - 40, (kScreenWidth - 30)/3, 50);
    leftLabel.text = locationString(@"project");
    [headerView addSubview:leftLabel];
    
    UILabel *middleLabel = [Utility createLabel:[CustomerizedFont heiti:16] color:[UIColor blackColor]];
    middleLabel.frame = CGRectMake(leftLabel.right, kSectionHeaderHeight - 40, (kScreenWidth - 30)/3, 50);
    middleLabel.textAlignment = NSTextAlignmentRight;
    middleLabel.text = locationString(@"occurDate");
    [headerView addSubview:middleLabel];
    
    UILabel *rightLabel = [Utility createLabel:[CustomerizedFont heiti:16] color:[UIColor blackColor]];
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.frame = CGRectMake(middleLabel.right, kSectionHeaderHeight - 40, (kScreenWidth - 30)/3, 50);
    rightLabel.text = locationString(@"occuredMoney");
    [headerView addSubview:rightLabel];
    
    return sectionHeaderView;
}

@end
