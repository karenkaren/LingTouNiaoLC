//
//  LTNFriendsViewController.m
//  lingtouniao
//
//  Created by 郑程锋 on 15/12/25.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNFriendsViewController.h"
#import "UIBarButtonItem+ClearBackground.h"
#import "LTNFriendsHeaderView.h"
#import "LTNServerConstant.h"
#import "QCSlideSwitchView.h"
#import "BaseTableViewController.h"

#define kFriends @"friends"
#define kFriendss @"friendss"

@interface LTNFriendsCell : UITableViewCell

@end

@implementation LTNFriendsCell

- (void)layoutSubviews {
    [super layoutSubviews];
    self.detailTextLabel.left = kScreenWidth / 2 + self.textLabel.left;
}

@end

@interface UserViewController : BaseTableViewController

@property (nonatomic) MyFriendsStatus flag;
@property (nonatomic) BOOL loadSucceeds;
@property (nonatomic, weak) LTNFriendsHeaderView *headerView;
@property (nonatomic)NSString *star;
@end

@implementation UserViewController

- (void)viewDidLoad {
    self.hideRefreshHeader = YES;
    [super viewDidLoad];
    self.tableView.backgroundColor = BACKGROUND_COLOR;
}

#pragma mark - tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = NSStringFromClass([self class]);
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LTNFriendsCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        cell.textLabel.font = [CustomerizedFont heiti:14];
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        cell.detailTextLabel.font = [CustomerizedFont heiti:12];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.contentView.width, [Utility lineWidth])];
        lineView.bottom = cell.height;
        lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        lineView.backgroundColor = DEVIDE_LINE_COLOR;
        [cell.contentView addSubview:lineView];
    }
    
    //    if (indexPath.row == 0) {
    //        cell.textLabel.text = [self firstRowTitleForTableView];
    //        cell.detailTextLabel.text = @"";
    //    } else
    if (indexPath.row == 0){
        cell.textLabel.text = locationString(@"partner_earning_list_header_type");
        cell.textLabel.font = [CustomerizedFont heiti:13];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        if (self.flag == MyFriendsStatusRegister) {
            cell.detailTextLabel.text = locationString(@"partner_register_time");
            cell.detailTextLabel.font = [CustomerizedFont heiti:13];
            cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        } else {
            cell.detailTextLabel.text = @"";
        }
    } else {
        
        NSDictionary *data = self.data[indexPath.row - 1];
        if (!isDictionary(data)) {
            data =@{@"mobile":@"",@"createDate":@"",@"realName":@""};
        }
        NSString *mobile = esString([data valueForKey:@"mobile"]);
        if (mobile.length == 11) {
            mobile = [mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }
        cell.textLabel.text = mobile;
        if (self.flag == MyFriendsStatusRegister) {
            cell.detailTextLabel.text = esString([data valueForKey:@"createDate"]);
        }else if (self.flag == MyFriendsStatusPurchased || self.flag == MyFriendsStatusNameAuthenticated) {
            NSString *str = esString([data valueForKey:@"realName"]);
            cell.detailTextLabel.text = [str stringByReplacingCharactersInRange:NSMakeRange(1, 1) withString:@"*"];
        }
        else {
            cell.detailTextLabel.text = @"";
        }
    }
    return cell;
}

- (NSString *)firstRowTitleForTableView {
    NSString *str = locationString(@"partner_zhuce");
    switch (self.flag) {
        case MyFriendsStatusNameAuthenticated:
            str = locationString(@"partner_bangka");
            break;
        case MyFriendsStatusPurchased:
            str = locationString(@"partner_touzi");
            break;
        default:
            break;
    }
    return str;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //return 48;
    if (indexPath.row == 0) {
        return 40;
    }
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //2 more for headers
    return self.data.count + 1;
}

- (NSString *)flagStringForType {
    NSString *str = @"ZC";
    switch (self.flag) {
            //        case MyFriendsStatusNameAuthenticated:
            //            str = @"SM";
            //            break;
        case MyFriendsStatusNameAuthenticated:
            str = @"BK";
            break;
        case MyFriendsStatusPurchased:
            str = @"TZ";
            break;
        default:
            break;
    }
    
    return str;
}

- (void)getServiceData:(BOOL)isGetMore {
    [super getServiceData:isGetMore];
    NSDictionary *dict = @{@"type" : [self flagStringForType]};
    kWeakSelf
    [self apiForPath:kFriendsCountUrl method:kGetMethod parameter:dict responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        FriendsModel *model = [[FriendsModel alloc]initWithDictionary:data[kFriends]];
        weakSelf.headerView.model = model;
        [self.data addObjectsFromArray:[data valueForKey:@"userFriendlist"]];
        if (!error || self.data.count) {
            self.loadSucceeds = YES;
        } else {
            self.loadSucceeds = NO;
        }
        
    }];
}

- (void)refreshIfNeeded {
    if (!self.loadSucceeds) {
        [self pullReload];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshIfNeeded];
}

@end


@interface RegisteredUserViewController : UserViewController

@end

@implementation RegisteredUserViewController

- (void)viewDidLoad {
    self.flag = MyFriendsStatusRegister;
    [super viewDidLoad];
}

@end

@interface NameAuthenticatedUserViewController : UserViewController

@end

@implementation NameAuthenticatedUserViewController

- (void)viewDidLoad {
    self.flag = MyFriendsStatusNameAuthenticated;
    [super viewDidLoad];
}

@end

@interface PurchasedUserViewController : UserViewController

@end

@implementation PurchasedUserViewController

- (void)viewDidLoad {
    self.flag = MyFriendsStatusPurchased;
    [super viewDidLoad];
}

@end

@interface  LTNMyFriendsViewController: BaseViewController <QCSlideSwitchViewDelegate, LTNFriendsHeaderViewTapDelegate>

@property (nonatomic) BOOL loadSucceeds;
@property (nonatomic) NSString *keyName;
@property (nonatomic) LTNFriendsHeaderView *headerView;
@property (nonatomic) QCSlideSwitchView *slideSwitchView;
@property (nonatomic) NSMutableArray *viewControllers;
@property (nonatomic) UIView *backGroundView;

@property (nonatomic) NSInteger num;

@end

@implementation LTNMyFriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createHeaderView];
    
    if ([self.keyName isEqualToString:kFriends]) {
        [self createQCSlideSwitchView];
        DLog(@"最后选中======== %ld",self.num);
        [self.slideSwitchView setSelectIndex:self.num animated:NO];
        [self.headerView selectStatus:(MyFriendsStatus)self.num];
    } else {
        //朋友推荐的朋友，不需要显示个人信息
        
    }
}

- (void)refreshIfNeeded {
    if (!self.loadSucceeds && [self.keyName isEqualToString:kFriendss]) {
        [self showWaitingIcon];
        [BaseDataEngine apiForPath:kFriendsCountUrl method:kGetMethod parameter:nil responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
            [self dismissWaitingIcon];
            FriendsModel *model = [[FriendsModel alloc]initWithDictionary:data[self.keyName]];
            _headerView.model = model;
            self.loadSucceeds = !error;
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshIfNeeded];
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
    MyFriendsStatus status = (MyFriendsStatus)number;
    [self.headerView selectStatus:status];
    
    UIViewController *vc = self.viewControllers[number];
    if ([vc respondsToSelector:@selector(refreshIfNeeded)]) {
        [vc performSelector:@selector(refreshIfNeeded)];
    }
    
    DLog(@"加载为当前视图 = %@, index=%@",vc.title,@(number));
    [[PiwikTracker sharedInstance] sendViews:NSStringFromClass([vc class]), vc.title, nil];
}

#pragma mark - LTNFriendsHeaderViewTapDelegate
- (void)selectStatus:(MyFriendsStatus)status {
    NSInteger index = (NSInteger)status;
    if (index != self.slideSwitchView.selectIndex) {
        [self.slideSwitchView setSelectIndex:index animated:YES];
    }
}

#pragma mark - private funcs

- (void)createQCSlideSwitchView {
    _slideSwitchView = [[QCSlideSwitchView alloc] initWithFrame:CGRectMake(0, self.backGroundView.height, kScreenWidth, self.view.height - self.backGroundView.height)];
    [self.view addSubview:_slideSwitchView];
    
    _slideSwitchView.slideSwitchViewDelegate = self;
    _slideSwitchView.topScrollViewHeight = 0;
    _slideSwitchView.rootScrollView.scrollEnabled = NO;
    
    NSArray *vcs = @[
                     NSStringFromClass([RegisteredUserViewController class]),
                     NSStringFromClass([NameAuthenticatedUserViewController class]),
                     NSStringFromClass([PurchasedUserViewController class])
                     ];
    self.viewControllers = [NSMutableArray arrayWithCapacity:vcs.count];
    
    for (NSString *cls in vcs) {
        UIViewController *vc = [[NSClassFromString(cls) alloc] init];
        [self.viewControllers addObject:vc];
        if ([vc isKindOfClass:[UserViewController class]]) {
            ((UserViewController *)vc).headerView = self.headerView;
        }
    }
    [self.slideSwitchView buildUI];
    [self.slideSwitchView adjustScreenWidth];
}

- (void)createHeaderView {
    UIView *backGroundView = [[UIView alloc] init];
    backGroundView.backgroundColor = BACKGROUND_COLOR;
    
    _headerView = [[LTNFriendsHeaderView alloc] initWithSelectableStatus:[self.keyName isEqualToString:kFriends]];
    self.headerView.delegate = self;
    self.headerView.backgroundColor = [UIColor whiteColor];
    
    backGroundView.width = kScreenWidth;
    backGroundView.height = _headerView.height + 15 + 25;
    self.headerView.top = 15;
    [backGroundView addSubview:self.headerView];
    
    [self.view addSubview:backGroundView];
    _backGroundView = backGroundView;
}

@end


@interface LTNMyRecommendViewController : LTNMyFriendsViewController

@property (nonatomic) NSInteger quailty;

@end

@interface LTNFriendsRecommendViewController : LTNMyFriendsViewController

@end

@implementation LTNMyRecommendViewController

- (void)viewDidLoad{
    self.keyName = kFriends;
    self.num = self.quailty;
    DLog(@"==——— num   %ld",self.num);
    DLog(@"====—————quail   %ld",self.quailty);
    
    [super viewDidLoad];
    self.title=locationString(@"parter_count_title1");
    
}

@end

@implementation LTNFriendsRecommendViewController

- (void)viewDidLoad{
    self.keyName = kFriendss;
    
    [super viewDidLoad];
    
    self.title = locationString(@"parter_count_title2");
}

@end


@interface LTNFriendsViewController ()<QCSlideSwitchViewDelegate>

@property (nonatomic) QCSlideSwitchView *slideSwitchView;

@property (nonatomic) NSMutableArray *viewControllers;

@end

@implementation LTNFriendsViewController

- (void)back{
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = locationString(@"partner_friend");
    
    [self createQCSlideSwitchView];
    
    [self.slideSwitchView setSelectIndex:0 animated:NO];
    
}
- (void)createQCSlideSwitchView{
    _slideSwitchView = [[QCSlideSwitchView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_slideSwitchView];
    
    _slideSwitchView.slideSwitchViewDelegate = self;
    _slideSwitchView.rootScrollView.scrollEnabled = NO;
    
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
                     NSStringFromClass([LTNMyRecommendViewController class]),
                     NSStringFromClass([LTNFriendsRecommendViewController class])
                     ];
    self.viewControllers = [NSMutableArray arrayWithCapacity:vcs.count];
    
//    for (NSString *cls in vcs) {
//        UIViewController *vc = [[NSClassFromString(cls) alloc] init];
//        [self.viewControllers addObject:vc];
//       
//    }
   
    LTNMyRecommendViewController *my = [[LTNMyRecommendViewController alloc]init];
    LTNFriendsRecommendViewController *fr =[[LTNFriendsRecommendViewController alloc]init];
    my.quailty = self.selectNum;
    
    [self.viewControllers addObject:my];
    [self.viewControllers addObject:fr];
    
    DLog(@"——===selectNum   %ld",self.selectNum);
    DLog(@"——========myquanlit   %ld",my.quailty);
    
    
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

@end
