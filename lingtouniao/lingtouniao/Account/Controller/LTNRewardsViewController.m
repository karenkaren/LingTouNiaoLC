//
//  LTNRewardsViewController.m
//  lingtouniao
//
//  Created by 郑程锋 on 15/12/30.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNRewardsViewController.h"
#import "QCSlideSwitchView.h"
#import "BaseTableViewController.h"
#import "StringUtil.h"
#import "NSStringUtil.h"
#import "LTNServerConstant.h"
#import "LTNRewardCell.h"
#import "LTNRewardModel.h"

@interface  LTNRewaViewController: BaseTableViewController

@property (nonatomic) BOOL loadSucceeds;
@property (nonatomic) NSDictionary * extraParams;

@end

@implementation LTNRewaViewController

- (void)viewDidLoad{
    self.isTableViewStyleGrouped = YES;
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.top = 15;
    self.tableView.height = kScreenHeight-15;
    self.tableView.backgroundColor =[UIColor colorWithHexString:@"#f9f9f9"];
    self.tableView.separatorColor = [UIColor colorWithHexString:@"#e2e2e2"];
    
    self.tableView.tableHeaderView = [self creatHeadView];
}

- (UIView *)creatHeadView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
 //   view.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9"];
   
    NSArray *labelTitles = @[locationString(@"partner_earning_list_header_type"),locationString(@"partner_earning_list_header_shouyi"),locationString(@"partner_earning_list_header_jiangli")];
    for (int i=0; i<labelTitles.count; i++) {
        UILabel *label = [Utility createLabel:[CustomerizedFont heiti:16] color:[UIColor colorWithHexString:@"#8A8A8A"]];
        label.frame = CGRectMake(20+i*kScreenWidth/3, 0, kScreenWidth/3, kGeneralHeight);
        label.text = labelTitles[i];
        [view addSubview:label];
    }
   
    return view;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self pullReload];
}

- (void)refreshIfNeeded {
    if (!self.loadSucceeds) {
        [self pullReload];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellId";
    LTNRewardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[LTNRewardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model=self.data[indexPath.row];
    return cell;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 44;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)getServiceData:(BOOL)isGetMore{
    [super getServiceData:isGetMore];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.extraParams];
    
    [self apiForPath:kEarningUrl method:kGetMethod parameter:dict responseModelClass:[LTNRewardModelList class] onComplete:^(id response, id data, NSError *error) {
        DLog(@"---rewardData---%@",data);
        LTNRewardModelList *dataModelList = (LTNRewardModelList *)data;
        if ([dataModelList isKindOfClass:[LTNRewardModelList class]]) {
            [self.data addObjectsFromArray:dataModelList.listPartnerEarnings];
        }
    }];    
}
@end


@interface LTNMyInviteViewController : LTNRewaViewController


@end


@interface LTNFriendInviteViewController : LTNRewaViewController

@end

@implementation LTNMyInviteViewController

- (void)viewDidLoad{
    self.extraParams = @{@"type" : @0};
    [super viewDidLoad];
    self.title=locationString(@"parter_earning_title1");
}

@end

@implementation LTNFriendInviteViewController

- (void)viewDidLoad{
    self.extraParams = @{@"type" : @1};
    [super viewDidLoad];
    self.title = locationString(@"parter_earning_title2");
}

@end

@interface LTNRewardsViewController ()<QCSlideSwitchViewDelegate>

@property (nonatomic) QCSlideSwitchView *slideSwitchView;

@property (nonatomic) NSMutableArray *viewControllers;

@end

@implementation LTNRewardsViewController

- (void)back{
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = locationString(@"reword_money");
    [self createQCSlideSwitchView];
    
    [self.slideSwitchView setSelectIndex:0 animated:NO];
}

- (void)createQCSlideSwitchView{
    _slideSwitchView = [[QCSlideSwitchView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_slideSwitchView];
    
    _slideSwitchView.slideSwitchViewDelegate = self;
    
    CGFloat topHeight = NavigationBarHeight;
    _slideSwitchView.topScrollViewHeight = topHeight;
    
    UIView *lineView = [[UIView alloc] initWithFrame: CGRectMake(0, topHeight - [Utility lineWidth], _slideSwitchView.width, [Utility lineWidth])];
    lineView.backgroundColor = [UIColor colorWithHex:0xe5e5e5 alpha:1.];
    [_slideSwitchView addSubview:lineView];
    
    _slideSwitchView.buttonWidthOffset = 44;
    _slideSwitchView.buttonLabelFont = [CustomerizedFont systemFontOfSize:14.0];
    _slideSwitchView.topScrollView.backgroundColor = [UIColor whiteColor];
    self.slideSwitchView.tabItemNormalColor = [UIColor colorWithHex:0x666666 alpha:1.];
    self.slideSwitchView.tabItemSelectedColor = COLOR_MAIN;
    UIView *bottomSlideView = [[UIView alloc] initWithFrame:CGRectMake(0, _slideSwitchView.topScrollViewHeight-2, 0, 2)];
    bottomSlideView.backgroundColor = COLOR_MAIN;
    self.slideSwitchView.shadowView = bottomSlideView;
    
    NSArray *vcs = @[
                     NSStringFromClass([LTNMyInviteViewController class]),
                     NSStringFromClass([LTNFriendInviteViewController class])
                     ];
    self.viewControllers = [NSMutableArray arrayWithCapacity:vcs.count];
    
    for (NSString *cls in vcs) {
        UIViewController *vc = [[NSClassFromString(cls) alloc] init];
        [self.viewControllers addObject:vc];
    }
    [self.slideSwitchView buildUI];
    [self.slideSwitchView adjustScreenWidth];
}

#pragma mark -- QCSlideSwitchViewDelegate

- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view{
    // you can set the best you can do it ;
    return self.viewControllers.count;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number{
    return self.viewControllers[number];
}

- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number{
    UIViewController *vc = self.viewControllers[number];
    if ([vc respondsToSelector:@selector(refreshIfNeeded)]) {
        [vc performSelector:@selector(refreshIfNeeded)];
    }
    DLog(@"加载为当前视图 = %@, index=%@",vc.title,@(number));
    [[PiwikTracker sharedInstance] sendViews:NSStringFromClass([vc class]), vc.title, nil];
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

