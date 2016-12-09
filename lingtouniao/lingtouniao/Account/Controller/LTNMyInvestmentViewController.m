//
//  LTNMyInvestmentViewController.m
//  lingtouniao
//
//  Created by wupeijing on 12/17/15.
//  Copyright © 2015 lingtouniao. All rights reserved.
//

#import "LTNMyInvestmentViewController.h"
#import "QCSlideSwitchView.h"
#import "BaseTableViewController.h"
#import "StringUtil.h"
#import "NSStringUtil.h"

#import "LTNMyOfflineOrderController.h"
#import "LTNBaseSlideViewController.h"
#import "LTNBaseOfflineController.h"

#import "LTNOfflineInvestTableCell.h"
#import "LTNOfflineTitleCell.h"

#import "LTNProductDetailController.h"
#import "LTNInvestViewCell.h"

#import "LTNPopView.h"

#define kContentIdentifier @"ContentCell"
#define KTitleIdentifier @"TitleCell"

@interface LTNInvestViewController : BaseTableViewController

@property (nonatomic) NSString *apiPath;
@property (nonatomic) NSString *contentIdentifier;
@property (nonatomic) NSString *titleIdentifier;
@property (nonatomic) NSString *status;
@property (nonatomic) BOOL loadSucceeds;

@property (nonatomic) LTNPopView *popView;
@property (nonatomic) UIButton *sortBtn;

@property (nonatomic) NSInteger clickIndex;

@end

@implementation LTNInvestViewController

- (void)viewDidLoad {
    self.isTableViewStyleGrouped = YES;
    [super viewDidLoad];
    
    _contentIdentifier = @"LTNInvestmentCellContent";
    [self.tableView registerClass:[LTNInvestViewCell class] forCellReuseIdentifier:self.contentIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = DEVIDE_LINE_COLOR;
    self.tableView.sectionFooterHeight = 0;
    
    
    if([self.status isEqualToString:@"3"]){
        self.clickIndex=2;
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showNavigationBarSeparator:NO];
    if (!self.loadSucceeds) {
        [self pullReload];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self showNavigationBarSeparator:YES];
}

- (void)refreshIfNeeded {
    if (!self.loadSucceeds) {
        [self pullReload];
    }
}

- (void)getServiceData:(BOOL)isGetMore {
    [super getServiceData:isGetMore];

    [self clickWithIndex:self.clickIndex];
    
//    NSDictionary *dict = @{@"Status":self.status};
//    [self apiForPath:kMyInvestimentUrl method:kGetMethod parameter:dict responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
//        [self.data addObjectsFromArray:[data valueForKey:@"investments"]];
//        if (!error || self.data.count) {
//            self.loadSucceeds = YES;
//        } else {
//            self.loadSucceeds = NO;
//        }
//        [self createSortBtn];
//    }];
}

-(UIButton *)sortBtn{
    if (!_sortBtn) {
        _sortBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 100, 0, 90, 25)];
        [_sortBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        _sortBtn.titleLabel.font = kFont(16);
        [_sortBtn addTarget:self action:@selector(changeSort:) forControlEvents:UIControlEventTouchUpInside];
        if ([self.status isEqualToString:@"3"]) {
            [_sortBtn setTitle:locationString(@"expire_time_down") forState:UIControlStateNormal];
        }else{
            [_sortBtn setTitle:locationString(@"exchange_time_down") forState:UIControlStateNormal];
        }
        
        [self.tableView addSubview:_sortBtn];
    }
    return _sortBtn;
}

-(void)changeSort:(UIButton *)sender{
    NSArray *titles = @[locationString(@"exchange_time_down"),locationString(@"exchange_time_up"),locationString(@"expire_time_down"),locationString(@"expire_time_up")];
    kWeakSelf;
    if (!_popView) {
        _popView = [[LTNPopView alloc] initWithTouchView:sender popWidth:115];
        [_popView setTitleArray:titles];
        
        _popView.selectRowAtIndex = ^(NSInteger index){
            [sender setTitle:titles[index] forState:UIControlStateNormal];
            sender.tag = index;
            DLog(@".......%@",weakSelf.status);
            DLog(@"..... %ld",index);
            
            weakSelf.clickIndex = index;
            
            [weakSelf pullReload];
            
        };
    }
    [_popView show];
    
    
}

-(void)clickWithIndex:(NSInteger)index{
    //sortPro   0-交易时间1-到期时间 string
    //sortType 0-升序 1-降序 number
    
    
    NSMutableDictionary *dict = nil;
    
    
    if (index == 0) {//交易时间降序
        dict = [NSMutableDictionary dictionaryWithDictionary:@{@"sortPro":@"0",@"sortType":@1,@"Status":self.status}];
    }else if (index == 1){//交易时间升序
        dict = [NSMutableDictionary dictionaryWithDictionary:@{@"sortPro":@"0",@"sortType":@0,@"Status":self.status}];
    }else if (index == 2){//到期时间降序
        dict = [NSMutableDictionary dictionaryWithDictionary:@{@"sortPro":@"1",@"sortType":@1,@"Status":self.status}];
    }else if (index == 3){//到期时间升序
        dict = [NSMutableDictionary dictionaryWithDictionary:@{@"sortPro":@"1",@"sortType":@0,@"Status":self.status}];
    }
    
    [self apiForPath:kMyInvestimentUrl method:kGetMethod parameter:dict responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        [self.data addObjectsFromArray:[data valueForKey:@"investments"]];
        if (!error || self.data.count) {
            self.loadSucceeds = YES;
        } else {
            self.loadSucceeds = NO;
        }
    }];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    LTNInvestViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:self.contentIdentifier];
    contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.section<[self.data count])
        contentCell.data = self.data[indexPath.section];
    cell = contentCell;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
    //return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
  //return [self.data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 140;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
//    if ([self.status isEqualToString:@"2"] || [self.status isEqualToString:@"4"]) {
    if (section == 0) {
        return 25;
    }
//    }
    return 15.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(self.data.count>0){
        if (section == 0) {
            UIView *sectionHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 25)];
            [sectionHeadView addSubview:self.sortBtn];
            return sectionHeadView;
        }
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LTNInvestViewCell *selectCell = [tableView cellForRowAtIndexPath:indexPath];
    if (selectCell.imgView.hidden) {
        return;
    }
    
    NSString *productId = [self.data[indexPath.section] valueForKey:@"productId"];
    LTNProductDetailController *detail = [[LTNProductDetailController alloc]init];
    detail.productId = esInteger(productId);
    [self.navigationController pushViewController:detail animated:YES];
    
    
}

@end

@interface LTNMyInvestingViewController : LTNInvestViewController


@end

@interface LTNMyInvestedViewController : LTNInvestViewController

@end

@interface LTNMyPlanInvestViewController : LTNInvestViewController

@end

@interface LTNMyDepositingInvestViewController : LTNInvestViewController

@end

//...............................安心投页面.....................................


@interface LTNOffLineCell : UITableViewCell

@end


@implementation LTNOffLineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.font = [CustomerizedFont heiti:16];
        self.textLabel.textColor = [UIColor colorWithHex:0x3a3a3a alpha:1];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.left = 20;
}

@end

@interface LTNBaseOffLineController : BaseTableViewController


@property (nonatomic) NSString *statusFly;

@property (nonatomic) BOOL loadSucceeds;

@end

@implementation LTNBaseOffLineController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refreshIfNeeded];
}

- (void)refreshIfNeeded {
    if (!self.loadSucceeds) {
        [self pullReload];
    }
}


-(void)viewDidLoad{
    self.isTableViewStyleGrouped = YES;
    [super viewDidLoad];
    
    [self.tableView registerClass:[LTNOfflineInvestTableCell class] forCellReuseIdentifier:kContentIdentifier];
    [self.tableView registerClass:[LTNOfflineTitleCell class] forCellReuseIdentifier:KTitleIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = DEVIDE_LINE_COLOR;
    self.tableView.sectionFooterHeight = 0;
    [self pullReload];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:KTitleIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary * dic = self.data[indexPath.section];
        cell.textLabel.text = dic[@"product_name"];
    } else {
        LTNOfflineInvestTableCell *contentCell = [tableView dequeueReusableCellWithIdentifier:kContentIdentifier];
        contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        contentCell.data = self.data[indexPath.section];
        cell = contentCell;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //2, one for header, the other for content
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 48.0;
    }
    return 136;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.0;
}


- (void)getServiceData:(BOOL)isGetMore {
    [super getServiceData:isGetMore];
    
    NSDictionary *dict = @{@"orderType":self.statusFly};
    [self apiForPath:kFindOfflineOrder method:kGetMethod parameter:dict responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        [self.data addObjectsFromArray:[data valueForKey:@"offlineOrderList"]];
        if (!error || self.data.count) {
            self.loadSucceeds = YES;
        } else {
            self.loadSucceeds = NO;
        }
    }];
}


@end


@interface CYZOffLineController : LTNBaseOffLineController

@end

@implementation CYZOffLineController

- (void)viewDidLoad {
    
    self.statusFly = @"CYZ";
    [super viewDidLoad];
    self.title = locationString(@"anxintou_chiyou");
}

@end

@interface HKZOffLineController : LTNBaseOffLineController

@end

@implementation HKZOffLineController

- (void)viewDidLoad {
    
    self.statusFly = @"YHK";
    [super viewDidLoad];
    self.title = locationString(@"anxintou_huankuan");
}

@end




@interface LTNOffLineViewController : BaseViewController  <QCSlideSwitchViewDelegate>

@property (nonatomic) BOOL loadSucceeds;

@property (nonatomic) QCSlideSwitchView *slideSwitchView;
@property (nonatomic) NSMutableArray *viewControllers;
@property (nonatomic) UIView *backGroundView;

@end


@implementation LTNOffLineViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = locationString(@"anxintou");
    
    [self createQCSlideSwitchView];
    [self.slideSwitchView setSelectIndex:0 animated:NO];
    
}

#pragma mark - private funcs

- (void)createQCSlideSwitchView {
    _slideSwitchView = [[QCSlideSwitchView alloc] initWithFrame:CGRectMake(0, self.backGroundView.height + 15, kScreenWidth, self.view.height - self.backGroundView.height)];
    [self.view addSubview:_slideSwitchView];
    
    _slideSwitchView.slideSwitchViewDelegate = self;
    //    _slideSwitchView.topScrollViewHeight = 0;
    _slideSwitchView.rootScrollView.scrollEnabled = NO;
    
    CGFloat topHeight = NavigationBarHeight;
    //   _slideSwitchView.topScrollViewHeight = topHeight;
    
    UIView *lineView = [[UIView alloc] initWithFrame: CGRectMake(0, topHeight - [Utility lineWidth], _slideSwitchView.width, 1)];
    lineView.backgroundColor = DEVIDE_LINE_COLOR;
    [_slideSwitchView addSubview:lineView];
    
    _slideSwitchView.buttonWidthOffset = 44;
    _slideSwitchView.topScrollView.backgroundColor = [UIColor whiteColor];
    self.slideSwitchView.tabItemNormalColor = [UIColor colorWithHex:0x6a6a6a alpha:1.];
    self.slideSwitchView.tabItemSelectedColor = COLOR_MAIN;
    UIView *bottomSlideView = [[UIView alloc] initWithFrame:CGRectMake(0, _slideSwitchView.topScrollViewHeight-2, 0, 2)];
    bottomSlideView.backgroundColor = COLOR_MAIN;
    self.slideSwitchView.shadowView = bottomSlideView;
    NSArray *vcs = @[
                     NSStringFromClass([CYZOffLineController class]),
                     NSStringFromClass([HKZOffLineController class]),
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
    // you can set the best you can do it;
    return self.viewControllers.count;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number{
    return self.viewControllers[number];
}

- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number withRowAnimation:(UITableViewRowAnimation)animation {
    
    UIViewController *vc = self.viewControllers[number];
    if ([vc respondsToSelector:@selector(refreshIfNeeded)]) {
        [vc performSelector:@selector(refreshIfNeeded)];
    }
    
    DLog(@"加载为当前视图 = %@, index=%@",vc.title,@(number));
    [[PiwikTracker sharedInstance] sendViews:NSStringFromClass([vc class]), vc.title, nil];
}


@end










@implementation LTNMyInvestingViewController

- (void)viewDidLoad {
    self.status = @"2";
   
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"计息中";
}

@end

@implementation LTNMyPlanInvestViewController

- (void)viewDidLoad {
    self.status = @"1";
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = locationString(@"my_plan_invest");
}

@end

@implementation LTNMyInvestedViewController

- (void)viewDidLoad {
    self.status = @"3";
   
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = locationString(@"anxintou_huankuan");
}

@end

@implementation LTNMyDepositingInvestViewController

- (void)viewDidLoad {
    self.status = @"4";
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = locationString(@"my_depositing_invest");
}

@end

@interface LTNMyInvestmentViewController () <QCSlideSwitchViewDelegate>

@property (nonatomic) QCSlideSwitchView *slideSwitchView;
@property (nonatomic) NSMutableArray *viewControllers;

@end

@implementation LTNMyInvestmentViewController

- (void)back{
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = locationString(@"myinvest_title");
    
    [self createQCSlideSwitchView];
    
    [self performSelector:@selector(selectSecondController) withObject:nil afterDelay:0.5];
    
}

-(void)selectSecondController{
    [self.slideSwitchView setSelectIndex:1 animated:NO];
}

- (void)createQCSlideSwitchView
{
    _slideSwitchView = [[QCSlideSwitchView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_slideSwitchView];
    
    _slideSwitchView.slideSwitchViewDelegate = self;
    
    CGFloat topHeight = NavigationBarHeight;
    _slideSwitchView.topScrollViewHeight = topHeight;
    
    UIView *lineView1 = [[UIView alloc] initWithFrame: CGRectMake(0, 0, _slideSwitchView.width, 1)];
    lineView1.backgroundColor = DEVIDE_LINE_COLOR;
    [_slideSwitchView addSubview:lineView1];
    
    UIView *lineView = [[UIView alloc] initWithFrame: CGRectMake(0, topHeight - [Utility lineWidth], _slideSwitchView.width, 1)];
    lineView.backgroundColor = DEVIDE_LINE_COLOR;
    [_slideSwitchView addSubview:lineView];
    
    _slideSwitchView.buttonWidthOffset = 44;
    _slideSwitchView.topScrollView.backgroundColor = [UIColor whiteColor];
    self.slideSwitchView.tabItemNormalColor = [UIColor colorWithHex:0x6a6a6a alpha:1.];
    self.slideSwitchView.tabItemSelectedColor = COLOR_MAIN;
    UIView *bottomSlideView = [[UIView alloc] initWithFrame:CGRectMake(0, _slideSwitchView.topScrollViewHeight-2, 0, 2)];
    bottomSlideView.backgroundColor = COLOR_MAIN;
    self.slideSwitchView.shadowView = bottomSlideView;
    
    NSMutableArray *vcs = [@[
                             NSStringFromClass([LTNMyPlanInvestViewController class]),
                             NSStringFromClass([LTNMyInvestingViewController class]),
                             NSStringFromClass([LTNMyDepositingInvestViewController class]),
                             NSStringFromClass([LTNMyInvestedViewController class])
                             ]mutableCopy];
    if ([LTNCore shouldShowOfflineInvestment]) {
        [vcs addObject: NSStringFromClass([LTNOffLineViewController class])];
    }
    self.viewControllers = [NSMutableArray arrayWithCapacity:vcs.count];
    
    for (NSString *cls in vcs) {
        UIViewController *vc = [[NSClassFromString(cls) alloc] init];
        [self.viewControllers addObject:vc];
    }
    
    [self.slideSwitchView buildUI];
    [self.slideSwitchView adjustScreenWidth];
}

#pragma mark -- QCSlideSwitchViewDelegate
- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view
{
    // you can set the best you can do it ;
    return self.viewControllers.count;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    return self.viewControllers[number];
}


- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    UIViewController *vc = self.viewControllers[number];
    if ([vc respondsToSelector:@selector(refreshIfNeeded)]) {
        [vc performSelector:@selector(refreshIfNeeded)];
    }
    DLog(@"加载为当前视图 = %@, index=%@",vc.title,@(number));
    [self.slideSwitchView setSelectIndex:number animated:YES];
    [[PiwikTracker sharedInstance] sendViews:NSStringFromClass([vc class]), vc.title, nil];
    
}

@end
