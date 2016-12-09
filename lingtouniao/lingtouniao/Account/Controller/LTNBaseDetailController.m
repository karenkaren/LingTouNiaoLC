//
//  LTNBaseDetailController.m
//  lingtouniao
//
//  Created by LiuFeifei on 15/12/25.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNBaseDetailController.h"
#import "LTNBaseDetailCell.h"
#import "LTNBaseDetailCellModel.h"
#import "LTNListTabBar.h"
#import "BaseWebViewController.h"

#define kSectionHeaderHeight 228

@interface LTNBaseDetailController ()<LTNListTabBarDelegate,UIScrollViewDelegate>
@property (nonatomic) LTNListTabBar *listTabBar;
@property (nonatomic) UIScrollView *contentScrollView;//装有ViewController的ScrollView
@property (nonatomic) NSInteger currentIndex;//当前viewController的索引
@property (nonatomic) NSArray *newsUrlList;// 用来存放listtabBar上item的标题和item对应界面请求数据



@property (nonatomic) BOOL loadSucceeds;
@property (nonatomic) NSString * total;
@property (nonatomic) NSString *lastTotal;

@end

@implementation LTNBaseDetailController

- (void)back{
    
  //  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNeedToRefreshAccountInfo];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}

//懒加载
//-(NSArray *)newsUrlList{
//    if (_newsUrlList == nil) {
//        _newsUrlList = [[NSArray alloc]initWithObjects:locationString(@"deposit"),@"全部",locationString(@"with_draw_title"),@"合伙人分润",@"项目还款",nil];
//    }
//    return _newsUrlList;
//}

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
    _lastTotal = @"";
    
    if (self.isHaveBiedCoinHelp ) {
        
        UIButton *helpBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kGeneralHeight*2, kGeneralHeight)];
        [helpBtn setTitle:locationString(@"bird_help") forState:UIControlStateNormal];
        [helpBtn setTitleColor:[UIColor colorWithHexString:@"#3A3A3A"] forState:UIControlStateNormal];
        [helpBtn addTarget:self action:@selector(clickHelp) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:helpBtn];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        item.width = -10;
        
        self.navigationItem.rightBarButtonItems = @[item,rightBtn];
    }
    
}

- (void)clickHelp{
    NSString * urlString =kH5BirdCoinHelp;
    BaseWebViewController *web = [[BaseWebViewController alloc]initWithURL:urlString];
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
}


- (void)getServiceData:(BOOL)isGetMore
{
    [super getServiceData:isGetMore];
    if (!isGetMore) {
        self.lastTotal = @"";
    }
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.extraParams];
    [dic setObject:self.lastTotal forKey:@"lastTotal"];
    
    [self apiForPath:self.apiPath method:kGetMethod parameter:dic responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        if (!error) {
            self.tableView.hidden = NO;
            self.lastTotal = [data valueForKey:@"lastTotal"];
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
    LTNBaseDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[LTNBaseDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.data = self.data[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //return [LTNBaseDetailCell heightForData:self.data[indexPath.row]];
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
//    imageView.autoresizingMask =
//    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
    [headerView addSubview:imageView];
   // [headerView sendSubviewToBack:imageView];
    [sectionHeaderView addSubview:headerView];
    
//    CGFloat layerHeight = headerView.height * 0.8;
//    CAShapeLayer * layer = [CAShapeLayer layer];
//    UIBezierPath * path = [UIBezierPath bezierPath];
//    [path moveToPoint:CGPointMake(0, layerHeight)];
//    [path addLineToPoint:CGPointMake(0, 0)];
//    [path addLineToPoint:CGPointMake(headerView.width, 0)];
//    [path addLineToPoint:CGPointMake(headerView.width, layerHeight)];
//    [path addQuadCurveToPoint:CGPointMake(0, layerHeight) controlPoint:CGPointMake(headerView.width * 0.5, headerView.height + 15)];
//    layer.path = path.CGPath;
//    layer.fillColor = [UIColor colorWithRed:254 / 255.0 green:238 / 255.0 blue:208 / 255.0 alpha:1.0].CGColor;
//    [headerView.layer addSublayer:layer];
    
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
    
//    self.listTabBar = [[LTNListTabBar alloc]initWithFrame:CGRectMake(0, kSectionHeaderHeight - 50, kScreenWidth, 45)];
//    self.listTabBar.delegate =self;
//    self.listTabBar.itemsTitle = self.newsUrlList;
 //   [headerView addSubview:self.listTabBar];
    
    UILabel *leftLabel = [Utility createLabel:[CustomerizedFont heiti:16] color:[UIColor blackColor]];
    leftLabel.frame = CGRectMake(15, kSectionHeaderHeight - 40, (kScreenWidth - 30)/3, 50);
    leftLabel.text = locationString(@"project");
    [headerView addSubview:leftLabel];
    
    UILabel *middleLabel = [Utility createLabel:[CustomerizedFont heiti:16] color:[UIColor blackColor]];
    middleLabel.frame = CGRectMake(leftLabel.right, kSectionHeaderHeight - 40, (kScreenWidth - 30)/3, 50);
    middleLabel.textAlignment = NSTextAlignmentRight;
    middleLabel.text = locationString(@"occurMoney");
    [headerView addSubview:middleLabel];
    
    UILabel *rightLabel = [Utility createLabel:[CustomerizedFont heiti:16] color:[UIColor blackColor]];
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.frame = CGRectMake(middleLabel.right, kSectionHeaderHeight - 40, (kScreenWidth - 30)/3, 50);
    rightLabel.text =locationString(@"remindBalance");
    [headerView addSubview:rightLabel];
    
    
    
    
    
    
    return sectionHeaderView;
}

@end
