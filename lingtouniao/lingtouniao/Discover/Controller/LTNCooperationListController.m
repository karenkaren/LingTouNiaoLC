//
//  LTNCooperationListController.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/9/21.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNCooperationListController.h"
#import "UIImageView+WebCache.h"
#import "CooperationCell.h"
#import "LTNBanner.h"
#import "BaseWebViewController.h"

NSString * const kMutualCell = @"CooperationCell";

@interface LTNCooperationListController ()

@property (nonatomic) UIView *topView;
@property (nonatomic) UILabel *lab;
@property (nonatomic, assign) NSTimeInterval refreshTime;

@end

@implementation LTNCooperationListController

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
    self.title = locationString(@"mutual");
    
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
    lab.text = locationString(@"mutual");
    lab.hidden = YES;
    [self.topView addSubview:lab];
    [self.topView addSubview:btn];

    [self.tableView registerClass:[CooperationCell class] forCellReuseIdentifier:kMutualCell];
    
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
    [self apiForPath:kHelpListUrl method:kGetMethod parameter:nil responseModelClass:[CooperationList class] onComplete:^(id response, id data, NSError *error) {
        
        [self initHeadView];
        self.refreshTime = [[NSDate date] timeIntervalSince1970];
        CooperationList *list = (CooperationList *)data;
        if ([list isKindOfClass:[CooperationList class]]) {
            [weakSelf.data addObjectsFromArray:list.helpList];
        }
        if (error || self.data.count == 0) {
            [self.navigationController setNavigationBarHidden:NO];
        }
    }];
}

-(void)initHeadView{
    
    NSArray * bannerList = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] valueForKey:kBannerMutualAndBannerIntroduction]];
    
    NSString *imgSting = nil;
//    for (LTNBanner *banner in bannerList) {
//        imgSting = banner.bannerPicture;
//    }
    LTNBanner *banner = (LTNBanner *)bannerList.firstObject;
    imgSting = banner.bannerPicture;
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, DimensionBaseIphone6(215))];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:headView.frame];
    [imageV sd_setImageWithURL:[NSURL URLWithString:imgSting] placeholderImage:[UIImage imageNamed:@"placeholder_banner"] options:SDWebImageRetryFailed];
    [headView addSubview:imageV];
    self.tableView.tableHeaderView = headView;
    
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CooperationCell *cell = [tableView dequeueReusableCellWithIdentifier:kMutualCell];
    cell.data =  self.data[indexPath.section];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *detailUrl = [self.data[indexPath.section] valueForKey:@"hzDetailUrl"];
    
    BaseWebViewController * webController = [[BaseWebViewController alloc] initWithURL:detailUrl];
    [self.navigationController pushViewController:webController animated:YES];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.data.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kCooperationCellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 16;
    }
    return 18;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
