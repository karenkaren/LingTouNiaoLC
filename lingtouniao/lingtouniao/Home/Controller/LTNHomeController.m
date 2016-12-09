//
//  LTNHomeController.m
//  lingtouniao
//
//  Created by LiuFeifei on 15/11/11.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNHomeController.h"
#import "LTNBannerView.h"
#import "LTNAcitonBar.h"
#import "LTNProduct.h"
#import "FinanciaCouponViewController.h"
#include "BaseWebViewController.h"
#import "LTNLoginController.h"
#import "LTNProductDetailController.h"
#import "UpdateModel.h"
#import "HandeUrlUtil.h"
#import "LTNPartnerViewController.h"
#import "GoldenEggButton.h"
#import "LTNTabBarController.h"
#import "LTNBaseDetailController.h"
#import "GoldenEggsViewController.h"
#import "LTNNewZoneController.h"
#import "HomeSectionHeaderView.h"
#import "HomeHeaderView.h"
#import "BaseProductListCell.h"
#import "HomeDivisionCell.h"
#import "HomeBannerCell.h"
#import "TableViewDevider.h"
#import "HomeModel.h"
#import "StringUtil.h"
#import "HomeIntroduceAttachedCellFrame.h"
#import "CooperationCell.h"
#import "CrowdfundingCell.h"
#import "HomeLoanCell.h"
#import "LTNMessageViewController.h"
#import "GoldenEggButton.h"
#import "LTNCooperationListController.h"
#import "LTNCrowdfundingListController.h"
#import "CooperationConfirmInvestController.h"

#import "LoanListViewController.h"
#import "LTNLoanProgressController.h"

#import "LTNDiscoverViewController.h"

NSString * const kHomeDivisionCell = @"HomeDivisionCell";
NSString * const kHomeBannerCell = @"HomeBannerCell";
NSString * const kBaseProductListCell = @"BaseProductListCell";
NSString * const kMainIntroduceCell = @"MainIntroduceCell";
NSString * const kAttachedIntroduceCell = @"AttachedIntroduceCell";

NSString * const kCooperationCell = @"CooperationCell";
NSString * const kCrowdfundingCell = @"CrowdfundingCell";
NSString * const kHomeLoanCell = @"HomeLoanCell";

@interface LTNHomeController ()<UITableViewDataSource, UITableViewDelegate, HomeBannerCellDelegate, HomeHeaderViewDelegate,UIWebViewDelegate, LTNProductDetailControllerDelegate, HomeSectionHeaderViewDelegate>
{
    UpdateModel *_updateModel;
    NSMutableURLRequest *_request;
    BOOL _isAllowShown;//活动是否开启
    BOOL _isHasShown;//是否已经显示过
    BOOL hasUserName;
    NSString *_loanStringStatus;
    NSInteger _loanSettingStatus;//1-原生 2-H5 如果是2的话，detail字段就应该是h5链接
    NSString * _loanSettingDetail;//接上
}

@property (nonatomic, strong) HomeHeaderView * homeHeaderView;
@property (nonatomic, strong) HomeSectionHeaderView * homeSectionHeader;
@property (nonatomic, assign) NSTimeInterval refreshTime;
@property (nonatomic) BOOL needCheckUpdate;
@property (nonatomic, strong) NSMutableArray * productIntroduces;
@property (nonatomic, strong) HomeModel * homeModel;
@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, strong) GoldenEggButton * goldenEggButton;

@end

@implementation LTNHomeController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kNeedToRefreshHomePage] || now - self.refreshTime > 30 * 60) {
        [self refreshUI];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self performSelector:@selector(showGoldenEgg) withObject:nil afterDelay:0.5];
}

- (void)viewDidLoad {
    self.isTableViewStyleGrouped = YES;
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self checkAppUpdate];
    });
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.homeModel = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] valueForKey:kHomeModel]];
    [self initCellDataWithData:self.homeModel];
    self.productIntroduces = [NSMutableArray array];
    [self registerCell];
    [self addNotification];
    [self refreshUI];
    
    self.goldenEggButton = [[GoldenEggButton alloc] initInView:self.view];
    self.goldenEggButton.bottom = self.view.height - self.tabBarController.tabBar.height - kMargin;
    self.goldenEggButton.right = self.view.width - kMargin;
    [self.goldenEggButton startShake];
    
    kWeakSelf
    self.goldenEggButton.tapBlock = ^(GoldenEggButton *_avatarButton) {
        [LTNUtilsHelper actionWhenLogin:^{
            {
                /**
                 *显示砸金蛋界面
                 */
                kStrongSelf
                [strongSelf.goldenEggButton stopShake];
                [strongSelf startShowGoldenEggs];
                _isHasShown = YES;
                [CurrentUser mine].haveNotShowEggToday = NO;
            }
        } onVC:nil];
    };
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private methods
- (void)registerCell
{
    [self.tableView registerClass:[HomeDivisionCell class] forCellReuseIdentifier:kHomeDivisionCell];
    [self.tableView registerClass:[HomeBannerCell class] forCellReuseIdentifier:kHomeBannerCell];
    [self.tableView registerClass:[BaseProductListCell class] forCellReuseIdentifier:kBaseProductListCell];
    [self.tableView registerClass:[CooperationCell class] forCellReuseIdentifier:kCooperationCell];
    [self.tableView registerClass:[CrowdfundingCell class] forCellReuseIdentifier:kCrowdfundingCell];
    [self.tableView registerClass:[HomeLoanCell class] forCellReuseIdentifier:kHomeLoanCell];
}

- (void)refreshHeaderView
{
    if (!self.homeHeaderView) {
        self.homeHeaderView = [HomeHeaderView getHomeHeaderViewWithTarget:self];
        self.tableView.tableHeaderView = self.homeHeaderView;
    }
    [self.homeHeaderView refresh];
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showGoldenEgg) name:@"GestureSuccessNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:@"NotificationMsg_Land_Sucess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:kNeedToRefreshProducts object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:kNeedToRefreshHomePage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:kCompleteNewHandTask object:nil];
}

- (void)refreshUI
{
    self.refreshTime = 0;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kNeedToRefreshHomePage];
    [self pullReload];
    [self refreshHeaderView];
}

-(BOOL)isFirstController{
    if(self.isViewLoaded &&
       self.view.window &&
       [self.view.window isKeyWindow]&&
       !self.tabBarController.presentedViewController&&
       self.tabBarController.selectedIndex==0)
    {
        
        return YES;
    }
    else{
        
        return NO;
    }
}

-(void)showGoldenEgg{
    if([self isFirstController])
    {
        [self showGoldenEggWhenViewWillShow];
    }
}

-(void)showGoldenEggWhenViewWillShow{
    if([[CurrentUser mine] sessionKey].length && ([CurrentUser mine].haveNotShowEggToday ||!_isHasShown) && _isAllowShown)
    {
        [self startShowGoldenEggs];
        _isHasShown = YES;
        [CurrentUser mine].haveNotShowEggToday=NO;
        [self.goldenEggButton startShake];
    }
}

//-(void)testWebView{
//    NSString * webpage = [NSBundle pathForResource:@"sessionkey" ofType:@"html" inDirectory:[[NSBundle mainBundle] bundlePath]];
//    BaseWebViewController *baseWebViewController = [[BaseWebViewController alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:webpage]]];
//    [self.navigationController pushViewController:baseWebViewController animated:YES];
//}

- (void)getServiceData:(BOOL)isGetMore
{
    [super getServiceData:isGetMore];
    self.isRefreshing = YES;
    kWeakSelf
    [self apiForPath:kHomeRecommendUrl method:kGetMethod parameter:nil responseModelClass:[HomeModel class] onComplete:^(id response, id data, NSError * error) {
        self.isRefreshing = NO;
        weakSelf.refreshTime = [[NSDate date] timeIntervalSince1970];
        if (!error) {
            [self.productIntroduces removeAllObjects];
            self.homeModel = (HomeModel *)data;
            [[NSUserDefaults standardUserDefaults] setValue:[NSKeyedArchiver archivedDataWithRootObject:self.homeModel] forKey:kHomeModel];
            [[NSUserDefaults standardUserDefaults] setBool:self.homeModel.productZcList.count ? YES : NO forKey:@"isHasCrowdData"];
            if (![self initCellDataWithData:self.homeModel]) {
                return;
            }
            weakSelf.tableView.hidden = NO;
            _isAllowShown = self.homeModel.isAllowShown;
            _isHasShown = self.homeModel.isHasShown;
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:self.homeModel.platformAllAmount forKey:kPlatformAllAmount];
            [defaults setValue:self.homeModel.platformRegisterNum forKey:kPlatformRegisterNum];
            [defaults setValue:self.homeModel.sumRevenue forKey:kSumRevenue];
            [defaults setInteger:self.homeModel.unreadMessageCount forKey:kUnreadMessageCount];
            [defaults synchronize];
            [self refreshHeaderView];
            if([self isFirstController]){
                if([[CurrentUser mine] sessionKey].length && ([CurrentUser mine].haveNotShowEggToday ||!_isHasShown) && _isAllowShown)
                {
                    [self startShowGoldenEggs];
                    _isHasShown = YES;
                    [CurrentUser mine].haveNotShowEggToday=NO;
                    [self.goldenEggButton stopShake];
                }
            }else{
                if(!_isHasShown&&[[CurrentUser mine] sessionKey].length>0)
                    [CurrentUser mine].haveNotShowEggToday=YES;
            }
        }
    }];
    
    [LTNServerHelper retrieveBannerListWithFinishBlock:^(id sender) {
        [self.tableView reloadData];
    }];
}

/**
 *  初始化数据
 *
 *  @param data 首页数据模型
 *
 *  @return 初始化数据是否成功
 */
- (BOOL)initCellDataWithData:(HomeModel *)data
{
    [self.data removeAllObjects];
    NSDictionary * dic1 = @{@"title" : @"",
                           @"titleDetail" : @"",
                           @"class" : [HomeDivisionCell class],
                           @"value" : @"",
                           @"height" : @(kDivisionCellHeight),
                           @"sel" : @"goToTaskDivision"};
    if (!data.isShowXsModel && data.productList.count) {
        dic1 = @{@"title" : locationString(@"tab_home_licai"),
                @"titleDetail" : @"更多",
                @"class" : [BaseProductListCell class],
                @"value" : data.productList,
                @"height" : @(kBaseProductListCellHeight),
                @"sel" : @"goToProductDetail:"};
    }
    
    NSDictionary * dic2 = @{@"title" : locationString(@"tab_home_huzhu"),
                           @"titleDetail" : @"更多",
                           @"class" : [CooperationCell class],
                            @"value" : data.productHzList.count ? data.productHzList : @"",
                           @"height" : @(kCooperationCellHeight),
                           @"sel" : @"goToCooperationDetail:"};
    
    NSDictionary * dic3 = [self getBannerDictonary];
    if (!dic3 || !dic3.count) {
        dic3 = @{@"title" : locationString(@"tab_home_huodong"),
                 @"titleDetail" : @"更多",
                 @"class" : [HomeBannerCell class],
                 @"value" : [NSArray array],
                 @"height" : @(kBannerCellHeight),
                 @"sel" : @""};
    }

    NSDictionary * dic4 = @{@"title" : locationString(@"tab_home_zhongchou"),
                @"titleDetail" : data.productZcList.count ? @"更多" : @"",
                @"class" : [CrowdfundingCell class],
                @"value" : data.productZcList.count ? data.productZcList : @"",
                @"height" : @(kCrowdfundingCellHeight),
                @"sel" : @"goToCrowdfundingDetail:"};

    NSDictionary * dic5 = @{@"title" : locationString(@"tab_home_jiekuan"),
                            @"titleDetail" : @"详情",
                            @"class" : [HomeLoanCell class],
                            @"value" : @"",
                            @"height" : @(kHomeLoanCellHeight),
                            @"sel" : @"goToLoan"};

    [self.data addObjectsFromArray:@[dic1, dic2, dic3, dic4, dic5]];
    return YES;
}

- (NSDictionary *)getBannerDictonary
{
    NSDictionary * dic = nil;
    NSArray * bannerList = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] valueForKey:kBannerHomeAndBannerIntroduction]];
    if (isArray(bannerList) && bannerList.count) {
        dic = @{@"title" : locationString(@"tab_home_huodong"),
                @"titleDetail" : @"更多",
                @"class" : [HomeBannerCell class],
                @"value" : bannerList,
                @"height" : @(kBannerCellHeight),
                @"sel" : @""};
    }
    return dic;
}

#pragma mark - tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary * dataDictionary = self.data[section];
    Class cellClass = dataDictionary[@"class"];
    id value = [self.data[section] valueForKey:@"value"];
    if (cellClass == [HomeBannerCell class]) {
        return 1;
    } else {
        if (isArray(value)) {
            NSArray * datas = (NSArray *)value;
            return datas.count;
        } else {
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dataDictionary = self.data[indexPath.section];
    Class cellClass = dataDictionary[@"class"];
    if (cellClass == [HomeDivisionCell class]) {
        return [self getDivisionCellWithIndexPath:indexPath];
    } else if (cellClass == [BaseProductListCell class]) {
        return [self getProductListCellWithIndexPath:indexPath];
    } else if (cellClass == [CooperationCell class]) {
        return [self getCooperationCelllWithIndexPath:indexPath];
    } else if (cellClass == [HomeBannerCell class]) {
        return [self getBannerCellWithIndexPath:indexPath];
    } else if (cellClass == [CrowdfundingCell class]) {
        return [self getCrowdfundingCelllWithIndexPath:indexPath];
    } else if (cellClass == [HomeLoanCell class]) {
        return [self getHomeLoanCelllWithIndexPath:indexPath];
    } else {
        return [self getDivisionCellWithIndexPath:indexPath];
    }
}

#pragma mark - 获取不同cell
- (UITableViewCell *)getCooperationCelllWithIndexPath:(NSIndexPath *)indexPath
{
    CooperationCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kCooperationCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    id value = self.data[indexPath.section][@"value"];
    if (isArray(value)) {
        cell.data = self.data[indexPath.section][@"value"][indexPath.row];
    } else {
        cell.data = value;
    }
    cell.hideJoin = YES;
    return cell;
}

- (UITableViewCell *)getCrowdfundingCelllWithIndexPath:(NSIndexPath *)indexPath
{
    CrowdfundingCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kCrowdfundingCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    id value = self.data[indexPath.section][@"value"];
    if (isArray(value)) {
        NSArray * datas = (NSArray *)value;
        cell.data = datas[indexPath.row];
    } else {
        cell.data = value;
    }
    return cell;
}

- (UITableViewCell *)getHomeLoanCelllWithIndexPath:(NSIndexPath *)indexPath
{
    HomeLoanCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kHomeLoanCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UITableViewCell *)getDivisionCellWithIndexPath:(NSIndexPath *)indexPath
{
    HomeDivisionCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kHomeDivisionCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    [cell startShake];
    return cell;
}

- (UITableViewCell *)getBannerCellWithIndexPath:(NSIndexPath *)indexPath
{
    HomeBannerCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kHomeBannerCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.data = [self.data[indexPath.section] valueForKey:@"value"];
    return cell;
}

- (UITableViewCell *)getProductListCellWithIndexPath:(NSIndexPath *)indexPath
{
    BaseProductListCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kBaseProductListCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray * productList = [self.data[indexPath.section] valueForKey:@"value"];
    cell.product = productList[indexPath.row];
    cell.progressView.hidden = YES;
    return cell;
}

#pragma mark - tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kDefaultSectionHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [[self.data[indexPath.section] valueForKey:@"height"] floatValue];
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSDictionary * dataDictionary = self.data[section];
    Class cellClass = dataDictionary[@"class"];
    if (cellClass == [HomeDivisionCell class]) {
        return kDefaultSectionHeight;
    }
    return kSectionHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary * dataDictionary = self.data[section];
    Class cellClass = dataDictionary[@"class"];
    if (cellClass == [HomeDivisionCell class]) {
        UIView * headerView = [[UIView alloc]initWithFrame:CGRectZero];
        headerView.backgroundColor = [UIColor whiteColor];
        return headerView;
    } else {
        HomeSectionHeaderView * homeSectionHeader = [HomeSectionHeaderView getHomeSectionHeaderViewWithTitle:[self.data[section] valueForKey:@"title"] titleDetail:[self.data[section] valueForKey:@"titleDetail"]];
        homeSectionHeader.delegate = self;
        homeSectionHeader.classString = NSStringFromClass(cellClass);
        self.homeSectionHeader = homeSectionHeader;
        return self.homeSectionHeader;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isRefreshing) {
        return;
    }
    NSString * selName = [self.data[indexPath.section] valueForKey:@"sel"];
    SEL action = NSSelectorFromString(selName);
    if (action && [self respondsToSelector:action]) {
        [self performSelector:action withObject:indexPath afterDelay:0];
    }
}


#pragma mark - select row method
#pragma mark 跳转到新手任务
- (void)goToTaskDivision
{
    LTNNewZoneController * newZone = [[LTNNewZoneController alloc]init];
    newZone.navigationTitle = locationString(@"new_region_title");
    newZone.groupName = @"XSRW";
    newZone.showHeader = YES;
    newZone.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newZone animated:YES];
}

#pragma mark 跳转到互助详情页
- (void)goToCooperationDetail:(NSIndexPath *)indexPath
{
    NSArray * cooperationList = [self.data[indexPath.section] valueForKey:@"value"];
    if (isArray(cooperationList)) {
        CooperationModel * cooperationModel = cooperationList[indexPath.row];
        BaseWebViewController * webController = [[BaseWebViewController alloc] initWithURL:cooperationModel.hzDetailUrl];
        webController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webController animated:YES];
    }
}

#pragma mark 跳转到众筹详情页
- (void)goToCrowdfundingDetail:(NSIndexPath *)indexPath
{
    NSArray * crowdfundingList = [self.data[indexPath.section] valueForKey:@"value"];
    if (isArray(crowdfundingList)) {
        CrowdfundingModel * crowdfundingModel = crowdfundingList[indexPath.row];
        BaseWebViewController * webController = [[BaseWebViewController alloc] initWithURL:crowdfundingModel.zcDetailUrl];
        webController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webController animated:YES];
    }
}

#pragma mark 跳转到借款页面
- (void)goToLoan
{
    [LTNUtilsHelper actionWhenLogin:^{
        [[LTNCore globleCore] jumpToLoan];
    }];
}

#pragma mark 跳转到产品详情
- (void)goToProductDetail:(NSIndexPath *)indexPath
{
    NSDictionary * dic = self.data[indexPath.section];
    NSArray * productList = [dic valueForKey:@"value"];
    LTNProductDetailController * detailController = [[LTNProductDetailController alloc] init];
    detailController.delegate = self;
    detailController.product = productList[indexPath.row];
    detailController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark - other delegate
#pragma mark -- 查看运营报告 delegate
- (void)clickCheckReport:(UIButton *)button
{
    if (self.isRefreshing) {
        return;
    }
    if (self.homeModel.yyUrl && ![self.homeModel.yyUrl isEqualToString:@""]) {
        BaseWebViewController * webController = [[BaseWebViewController alloc] initWithURL:self.homeModel.yyUrl];
        webController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webController animated:YES];
    }
}

#pragma mark -- 砸金蛋 delegate
//- (void)testCooperation
//{
//    CooperationConfirmInvestController * vc = [[CooperationConfirmInvestController alloc] init];
//    vc.productId = 100112;
//    vc.investAmount = @"2132";
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//}

/**
 *  显示砸金蛋界面
 */
-(void)startShowGoldenEggs
{
//    [self testWebView];
//    [self testCooperation];
//    return;
    if([LTNCore globleCore].goldenEggsWindowIsShowing)
        return;
    [LTNCore globleCore].goldenEggsWindowIsShowing=YES;
    UIWindow *keyWindow = [[[UIApplication sharedApplication]delegate]window];
    GoldenEggsViewController *goldenEggsViewController = [[GoldenEggsViewController alloc]init];
    goldenEggsViewController.goldenEggsWindow = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    goldenEggsViewController.goldenEggsWindow.bottom = 0;
    UINavigationController *navGoldenEggsViewController = [[UINavigationController alloc]initWithRootViewController:goldenEggsViewController];
    goldenEggsViewController.goldenEggsWindow.rootViewController = navGoldenEggsViewController;
    [keyWindow addSubview:goldenEggsViewController.goldenEggsWindow];
    [UIView animateWithDuration:0.25 animations:^{
        goldenEggsViewController.goldenEggsWindow.top = 0;
    }];
    [goldenEggsViewController.goldenEggsWindow setWindowLevel:UIWindowLevelAlert];
    [goldenEggsViewController.goldenEggsWindow makeKeyAndVisible];
    
    [goldenEggsViewController setCallBack:^{
        [self.goldenEggButton startShake];
    }];
}

#pragma mark -- detail controller delegate
- (void)needsRefreshWithProduct:(LTNProduct *)product
{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -- bannerView代理方法
- (void)clickBannerView:(LTNBannerView *)bannerView banner:(LTNBanner *)banner
{
    NSString *name = banner.shareTitle;
    NSString *linkUrl = banner.shareUrl;
    NSString *content = banner.shareContent;

    [HandeUrlUtil receiveOpenUrlString:banner.bannerUrl fromNavViewController:self.navigationController andHaveNav:YES andHaveBtn:banner.isShare andShareName:name andShareIcon:banner.sharePic andShareUrl:linkUrl andShareContent:content];
}

#pragma mark -- actionBar代理方法
- (void)clickAcitonBar:(LTNAcitonBar *)acitonBar clickedItemIndex:(NSInteger)index
{
    switch (index) {
        case 0: // 品牌介绍
        {
            NSString * urlString = kH5AboutUrl;
            BaseWebViewController * webController = [[BaseWebViewController alloc] initWithURL:urlString];
            webController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webController animated:YES];
        }
            break;
        case 1: // 热门活动
        {
            [self jumpToDiscoverBar];
        }
            
//            [[LTNCore globleCore] backToDiscoverController];
            break;
        case 2: // 理财金券
        {
            [LTNUtilsHelper actionWhenLogin:^{
                [self pushToFinanciaCouponViewController];
            }];
        }
            break;
        case 3: // 安全保障
        {
            NSString * urlString = kH5InsuranceUrl;
            BaseWebViewController * webController = [[BaseWebViewController alloc] initWithURL:urlString];
            webController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webController animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark -- 消息中心点击代理方法
- (void)clickMessageCenter:(UIButton *)button
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kUnreadMessageCount];
//    [CurrentUser mine].accountInfo.unreadMessageCount = 0;
    LTNMessageViewController *message = [[LTNMessageViewController alloc]init];
    message.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:message animated:YES];
}

#pragma mark -- 点击section header代理方法
- (void)showMore:(HomeSectionHeaderView *)sectionHeaderView
{
    Class sectionClass = NSClassFromString(sectionHeaderView.classString);
    if ([sectionClass isSubclassOfClass:[CooperationCell class]]) {
        DLog(@"互助");
        LTNCooperationListController * cooperationListController = [[LTNCooperationListController alloc]init];
        cooperationListController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cooperationListController animated:YES];
    }  else if ([sectionClass isSubclassOfClass:[HomeBannerCell class]]) {
        DLog(@"banner");
        [self jumpToDiscoverBar];
        //[[LTNCore globleCore] backToDiscoverController];
    } else if ([sectionClass isSubclassOfClass:[CrowdfundingCell class]]) {
        DLog(@"众筹");
        LTNCrowdfundingListController * crowdfundingListController = [[LTNCrowdfundingListController alloc]init];
        crowdfundingListController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:crowdfundingListController animated:YES];
    } else if ([sectionClass isSubclassOfClass:[HomeLoanCell class]]) {
        DLog(@"借款");
        [self goToLoan];
    } else {
        [[LTNCore globleCore] backToInvestmentListController];
    }
}

#pragma mark - others
-(void)pushToFinanciaCouponViewController{
    FinanciaCouponViewController * couponController = [[FinanciaCouponViewController alloc] init];
    couponController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:couponController animated:YES];
}

- (void)checkAppUpdate
{
    kWeakSelf
    [BaseDataEngine apiForPath:kCheckUpdateUrl method:kGetMethod parameter:nil responseModelClass:[UpdateModel class] onComplete:^(id response, id data, NSError *error) {
        if (error) {
            return;
        }
        UpdateModel *updateInfoModel = (UpdateModel *)data;
        if ([updateInfoModel hasUpdate]) {
            _updateModel = updateInfoModel;
            
            if ([updateInfoModel forceUpdate]){//强制升级
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:locationString(@"update_title")
                                                                message:[_updateModel updateInfo]
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:locationString(@"update_btn"), nil];
                [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                    [weakSelf openAppUrl];
                }];
                return;

            }
                
            BOOL isRemind = NO;
            NSString *versionString = [Utility getDataWithKey:@"UpDateVersionRemind"];
            if (versionString) {
                if (![_updateModel.versionNo isEqualToString:versionString]) {
                    isRemind = YES;
                }
            } else {
                isRemind = YES;
            }
            if (!isRemind) {
                return ;
            }
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:locationString(@"update_title")
                                                            message:[_updateModel updateInfo]
                                                           delegate:nil
                                                  cancelButtonTitle:locationString(@"btn_cancel")
                                                  otherButtonTitles:locationString(@"ignore_update"),locationString(@"update_btn"), nil];
            [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [Utility clearDataWithKey:@"UpDateVersionRemind"];
                    [Utility saveDataWithKey:@"UpDateVersionRemind"ofValue:_updateModel.versionNo];
                }else if(buttonIndex == 2){
                    [weakSelf openAppUrl];
                }
            }];
         }
    }];
}

- (void)openAppUrl {
    NSString *str = _updateModel.downloadUrl;
    if (![str length]) {
        str = kUpdateUrl;
    }
    NSLog(@"updateApp downloadURL:(%@)",str);
    [Utility openURL:[NSURL URLWithString:str]];
    
    _needCheckUpdate = YES;
}

- (void)enterForeground {
    if (self.needCheckUpdate) {
        self.needCheckUpdate = NO;
        [self checkAppUpdate];
    }
}

- (void)jumpToDiscoverBar{
    
    UIViewController * vc = [[LTNCore globleCore] jumpToDiscoverController];
    if ([vc isKindOfClass:[LTNDiscoverViewController class]]) {
        LTNDiscoverViewController * discoverViewController = (LTNDiscoverViewController *)vc;
        discoverViewController.isSlipping = YES;
    }
    
}

@end
