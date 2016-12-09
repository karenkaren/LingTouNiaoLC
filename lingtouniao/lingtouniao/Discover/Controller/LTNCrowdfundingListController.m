//
//  LTNCrowdfundingListController.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/9/21.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNCrowdfundingListController.h"
#import "UIImageView+WebCache.h"
#import "BaseWebViewController.h"
#import "CrowdfundingCell.h"
#import "LTNBanner.h"


NSString * const kArrangCell = @"CrowdfundCell";

@interface LTNCrowdfundingListController ()

@property (nonatomic) UIView *topView;
@property (nonatomic) UILabel *lab;
@property (nonatomic, assign) NSTimeInterval refreshTime;

@end

@implementation LTNCrowdfundingListController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
   
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if (now - self.refreshTime > 30 * 60) {
        self.refreshTime = 0;
        [self pullReload];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = locationString(@"crowdfunding");
    
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    self.topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.topView];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 14, 44, 44)];
//    [btn setTitle:@"返回" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIImage *img = [UIImage imageNamed:@"nav_return"];
    [btn setImage:img forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 14, kScreenWidth, 44)];
    self.lab = lab;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = locationString(@"crowdfunding");
    lab.hidden = YES;
    [self.topView addSubview:lab];
    [self.topView addSubview:btn];
    [self.tableView registerClass:[CrowdfundingCell class] forCellReuseIdentifier:kArrangCell];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:kNeedToRefreshCrowfundingList object:nil];
}

- (void)refreshUI
{
    [self pullReload];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [super scrollViewDidScroll:scrollView];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY> 64) {
         CGFloat alpha = MIN(1, 1 - ((64 + 64 - offsetY) / 64));
        self.topView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:alpha];
        self.lab.hidden = NO;
    }else{
        self.topView.backgroundColor = [UIColor clearColor];
        self.lab.hidden = YES;
    }
    
}

- (void)getServiceData:(BOOL)isGetMore{
    [super getServiceData:isGetMore];
    
    kWeakSelf
    [self apiForPath:kProductZcUrl method:kGetMethod parameter:nil responseModelClass:[CrowdfundingList class] onComplete:^(id response, id data, NSError *error) {
        
        [self initHeadView];
        self.refreshTime = [[NSDate date] timeIntervalSince1970];

        CrowdfundingList *list = (CrowdfundingList *)data;
        if ([list isKindOfClass:[CrowdfundingList class]]) {
            [weakSelf.data addObjectsFromArray:list.productZcList];
        }
        if (error || self.data.count == 0) {
            [self.navigationController setNavigationBarHidden:NO];
        }
    }];
}

-(void)initHeadView{
    
    NSArray * bannerList = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] valueForKey:kBannerCrowdingAndBannerIntroduction]];
    
    NSString *imgSting = nil;
    LTNBanner *banner = (LTNBanner *)bannerList.firstObject;
    imgSting = banner.bannerPicture;
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, DimensionBaseIphone6(215))];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:headView.frame];
    [imageV sd_setImageWithURL:[NSURL URLWithString:imgSting] placeholderImage:[UIImage imageNamed:@"placeholder_banner"] options:SDWebImageRetryFailed];
    [headView addSubview:imageV];
    self.tableView.tableHeaderView = headView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.data.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCrowdfundingCellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 18;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CrowdfundingCell *cell = [tableView dequeueReusableCellWithIdentifier:kArrangCell];
    cell.data =  self.data[indexPath.section];
    cell.hideTopLine = YES;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *detailUrl = [self.data[indexPath.section] valueForKey:@"zcDetailUrl"];
    BaseWebViewController * webController = [[BaseWebViewController alloc] initWithURL:detailUrl];
    [self.navigationController pushViewController:webController animated:YES];
}

@end
