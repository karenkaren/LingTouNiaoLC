//
//  LTNAccountController.m
//  lingtouniao
//
//  Created by LiuFeifei on 15/11/11.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNAccountController.h"
#import "LTNAccountCell.h"
#import "LTNMyInvestmentViewController.h"
#import "FinanciaCouponViewController.h"
#import "LTNAccountInfoController.h"
#import "LTNPartnerViewController.h"
#import "RechargeViewController.h"
#import "ChargeViewController.h"
#import "LTNRevenueController.h"
#import "LTNServerConstant.h"
#import "BoundBankCardViewController.h"
#import "VerifyRealNameViewController.h"
#import "LTNBaseDetailController.h"
#import "LTNMyCurrentDepositController.h"
#import "LTNMyOfflineOrderController.h"
#import "LTNMessageViewController.h"
#import "LTNBaseStatisticsController.h"
#import "GuideShade.h"
#import "AppDelegate.h"

#import "LoanListViewController.h"
#import "LTNLoanProgressController.h"

#import "LTNAccountCollectionCell.h"
#import "LTNAccountDetailCollectionCell.h"

#import "GuideShadeView.h"
#import "CustomizedBackWebViewController.h"

#import "LTNMyEachHelpViewController.h"
#import "LTNMyArrangeViewController.h"

#define kAccountHeaderHeight 149
#define kAccountActionHeaderHeight 270
#define kMargin 20
#define kSide 30

#define PrivateShow @"PrivateShow"
#define kButtonEyesStatus @"ButtonStatus"

//cell的重用Id
#define kCellReuseId1  @"cellId1"
#define kCellReuseId2  @"cellId2"

#define kCellIdParter  @"cellIdParter"
#define kCellIdTicket  @"cellIdTicket"

#define kHeaderView @"HeaderView"
#define kFooterView @"FooterView"

@interface LTNAccountController ()<LTNAccountCellDelegate,UIAlertViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIAlertView *_verifyRealNameAlertView;//实名认证弹窗
    UIAlertView *_boundBankCardAlertView;//银行卡认证弹窗
    
    UILabel *_expectedIncomeLabel,*_birdCionLabel,*_userNameLabel;
    NSString *_expectedCollectString,*_expectedBirdCoinString,*_userName,*_name;
    BOOL hasUserName;
    NSInteger _loanTotalCount;
    UIView *_expectedIncomeView;
    NSString *_loanStringStatus;
    NSInteger _loanSettingStatus;//1-原生 2-H5 如果是2的话，detail字段就应该是h5链接
    NSString * _loanSettingDetail;//接上
}
@property (nonatomic, strong) NSArray * accountList1;
@property (nonatomic, strong) NSArray * accountList2;
@property (nonatomic,assign) BOOL show;
@property (nonatomic) UIButton *button;
@property (nonatomic, assign) NSTimeInterval refreshTime;
@property (nonatomic) UILabel *amountLabel;//消息中心数量
@property (nonatomic) LTNAccountCell *cellView;
@property (nonatomic) UIView *headView;
@property (nonatomic) UICollectionView *collectionView;

@property (nonatomic)BOOL shouldShowTeach;

@property (nonatomic) NSString *taskString;
@property (nonatomic) NSString *investString;
@property (nonatomic) NSString *fincalString;

@property (nonatomic,strong)UILabel * expectedIncomeSubLabel;
@property (nonatomic,strong)UILabel * coinLabel;
@property (nonatomic) CGSize incomeSize;

@end

@implementation LTNAccountController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    _show = [[[NSUserDefaults standardUserDefaults] objectForKey:PrivateShow] boolValue];
    
    if([GuideShadeView shouldShowTeachingViewWithType:LTNTeachTypeNone]){
        [GuideShadeView showTeachType:LTNTeachTypeNone withFrame:CGRectZero withCloseBlock:nil];
    }
    
    if(self.shouldShowTeach){
        [self showTeachView];
    }
    
    [self initCellListData];
    // 第一次进入或超过1分钟时刷新数据
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if ([[CurrentUser mine] sessionKey] && (now - self.refreshTime > 60 || [[NSUserDefaults standardUserDefaults] boolForKey:kNeedToRefreshAccountInfo])) {
        self.refreshTime = 0;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kNeedToRefreshAccountInfo];
        [self pullReload];
    }
    
    [self.tableView reloadData];
    [self.collectionView reloadData];
    
    if ([[CurrentUser mine] hasLogged]) {
        //拆分接口：任务进度 投资产品数 理财金券使用数
        [BaseDataEngine apiForPath:kUserAccountSpiltUrl method:kGetMethod parameter:nil responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
            
            if (!error) {
                _taskString = [NSString stringWithFormat:@"%@/%@",data[@"myTasking"],data[@"myTask"]];
                _investString = [NSString stringWithFormat:@"%@",data[@"myOrder"]];
                _fincalString = [NSString stringWithFormat:@"%@",data[@"myCoupons"]];
                
                [self.tableView reloadData];
                [self.collectionView reloadData];
            }
            
        }];
    }
    
    /*
    //TODO:请求服务器获取借款状态，如果为0 这个是否可以放在用户系统里？
    [BaseDataEngine apiForPath:kLoanQuery method:kGetMethod parameter:nil responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        if(!error){
            _loanTotalCount=esInteger(data[@"totalCount"]);
    
            if (_loanTotalCount == 0) {
               _loanStringStatus = @"未借款";
            }else if (_loanTotalCount == 1){
               _loanStringStatus = @"借款中";
            }
            [self.tableView reloadData];
            [self.collectionView reloadData];
        }
    }];
     */

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleUpdateUserInfoNotification) name:NotificationMsg_Update_UserInfo object:nil];
}

- (void)viewDidLoad {
    self.isTableViewStyleGrouped = YES;
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f3f5f7"];
    
    [self.tableView addSubview:self.collectionView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTeachView) name:@"GestureSuccessNotification" object:nil];
    [self getLoanSetting];
}

-(void)showTeachView{
    [GuideShadeView showTeachType:LTNTeachTypeParter withCloseBlock:^{
        [GuideShadeView showTeachType:LTNTeachTypeBirdCoin withCloseBlock:^{
            [GuideShadeView showTeachType:LTNTeachTypeBirdTicket withCloseBlock:^{
                
            }];
        }];
    }];
}

-(BOOL)isFirstController{
    if(self.isViewLoaded &&
       self.view.window &&
       [self.view.window isKeyWindow]&&
       self.tabBarController.selectedIndex==3)
    {
        NSLog(@"首页第一响应");
        return YES;
    }
    else{
        NSLog(@"首页不是第一响应");
        return NO;
    }
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)handleUpdateUserInfoNotification{
    [self updateUserAccount];
    [self pullReload];
}

-(void)updateUserAccount{
    
    NSString *amountString = [NSString stringWithFormat:@"%ld",[CurrentUser mine].accountInfo.unreadMessageCount];
    
    if (![amountString isEqualToString:@"0"]) {
        self.amountLabel.hidden=NO;
        self.amountLabel.text = amountString;
    }else{
        self.amountLabel.hidden=YES;
    }
}

- (void)getServiceData:(BOOL)isGetMore
{
    [super getServiceData:isGetMore];
    kWeakSelf
    [self apiForPath:kUserAccountUrl method:kGetMethod parameter:nil responseModelClass:[AccountInfoModel class] onComplete:^(id response, id data, NSError *error) {
        if (!error) {
            self.refreshTime = [[NSDate date] timeIntervalSince1970];
            [CurrentUser mine].accountInfo = data;
            
            
            NSString *amountString = [NSString stringWithFormat:@"%ld",[CurrentUser mine].accountInfo.unreadMessageCount];
            
            if (![amountString isEqualToString:@"0"]) {
                self.amountLabel.hidden=NO;
                self.amountLabel.text = amountString;
            }else{
                self.amountLabel.hidden=YES;
            }
            
            [weakSelf.data addObject:data];
            [weakSelf initCellListData];
            //[[GuideShade guideShade] newUserGuide];
            [self.tableView reloadData];
            [self.collectionView reloadData];
            
        }
    }];
}

-(void)initCellListData{
    
    NSMutableArray * arrayM1 = [NSMutableArray arrayWithObjects:@{@"image":@"icon_task",
                                                                  @"title":locationString(@"mytask_title"),
                                                                  @"sel":@"showMyTask",
                                                                  @"detail":locationString(@"get_task_reward")},
                                @{@"image":@"icon_partner",
                                  @"title":locationString(@"my_friends"),
                                  @"sel":@"showPartner",@"detail":locationString(@"get_partner_reward")},
                                
                                nil];
    
    NSMutableArray * arrayM2 = [NSMutableArray arrayWithObjects:@{@"image":@"icon_crowd",
                                                                  @"title":locationString(@"my_Crowdfunding"),
                                                                  @"sel":@"arrange",
                                                                  @"detail":locationString(@"granis_Sand")
                                                                  },
                                @{@"image":@"icon_mutual",
                                  @"title":locationString(@"my_Mutual"),
                                  @"sel":@"eachHelp",
                                  @"detail":locationString(@"release_Home")
                                  },
                                @{@"image":@"icon_investment",
                                  @"title":locationString(@"myinvest_title"),
                                  @"sel":@"myInvestment",
                                  },
                                @{@"image":@"icon_ticket",
                                  @"title":locationString(@"text_money_volume"),
                                  @"sel":@"ticketList",
                                  },
                                @{@"image":@"icon_jiekuan",
                                  @"title":locationString(@"loan_title"),
                                  @"sel":@"loanList",
                                  @"detail":locationString(@"loca_detail")
                                  },
                                @{
                                  @"image":@"icon_shezhi",
                                  @"title":locationString(@"account_settings"),
                                  @"sel":@"accountInfo",
                                  @"detail":locationString(@"account_settings_detail")
                                  },
                                
                                nil];
    
    //暂时移除随心投
//    if ([LTNCore shouldShowCurrentInvestment] ) {
//        [arrayM2 insertObject:@{@"image":@"icon_current",
//                                @"title":@"随心投",
//                                @"sel":@"myCurrentDeposit", @"detail":@"随存随取"} atIndex:0];
//        
//    }
    
    self.accountList1 = [NSArray arrayWithArray:arrayM1];
    self.accountList2 = [NSArray arrayWithArray:arrayM2];
}

-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        //布局对象
        //规则布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];//设置其布局方向
        _collectionView.alwaysBounceVertical = YES;
        
        //创建网格视图
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
        //设置代理和数据源代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //设置背景颜色
        _collectionView.backgroundColor = self.tableView.backgroundColor;
        
        //自适应大小
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        //注册cell  headView
        [_collectionView registerClass:[LTNAccountCollectionCell class] forCellWithReuseIdentifier:kCellReuseId1];
        
        [_collectionView registerClass:[LTNAccountDetailCollectionCell class] forCellWithReuseIdentifier:kCellReuseId2];
        
        [_collectionView registerClass:[LTNAccountDetailCollectionCell class] forCellWithReuseIdentifier:kCellIdParter];
        
        [_collectionView registerClass:[LTNAccountCollectionCell class] forCellWithReuseIdentifier:kCellIdTicket];
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderView];//头部视图注册
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterView];//脚部视图注册
    }
    return _collectionView;
}

// 借款开关
- (void)getLoanSetting
{
    [BaseDataEngine apiForPath:kLoanSettingUrl method:kGetMethod parameter:nil responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        if (!error&& isDictionary(data)) {
            _loanSettingStatus = esInteger(data[@"status"]);
            _loanSettingDetail = data[@"detail"];
        }
    }];
}

-(void)updateHeaderView{
    //TODO: 账户信息需要整理
    hasUserName = [CurrentUser mine].userInfo.userName && ![[CurrentUser mine].userInfo.userName isEqualToString:@""];
    NSString * name = hasUserName ? [CurrentUser mine].userInfo.userName : [[NSUserDefaults standardUserDefaults] objectForKey:kUserNameKey];
    _name = name;
    NSString * userName = [NSString stringWithFormat:locationString(@"hello"), name];
    _userName = userName;
    _userNameLabel.text = userName;
    [_userNameLabel sizeToFit];
    _userNameLabel.top = 30;
    _userNameLabel.left = 12;
    
    NSInteger count = [CurrentUser mine].accountInfo.birdCoinRevenue > 0 ? 2 : 1;
    
    CGFloat expectedIncomeWidth = kScreenWidth * 0.5;
    NSString * expectedCollectString = [NSString stringWithFormat:@"%.2f", [CurrentUser mine].accountInfo.collectRevenue];
    NSString * expectedBirdCoinString = [NSString stringWithFormat:@"%.2f", [CurrentUser mine].accountInfo.birdCoinRevenue];
    
    _expectedCollectString = expectedCollectString;
    _expectedBirdCoinString = expectedBirdCoinString;
    
    _incomeSize = [self sizeWithText:expectedCollectString maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:32];
    CGSize birdCoinSize = [self sizeWithText:expectedCollectString maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:32];
    
    if (count == 1) {
        _expectedIncomeLabel.frame = CGRectMake((kScreenWidth - _incomeSize.width)/2, 100, _incomeSize.width, _incomeSize.height);
        _birdCionLabel.hidden=YES;
        _coinLabel.hidden=YES;
        
    }else {
        _birdCionLabel.hidden=NO;
        _coinLabel.hidden=NO;
        _expectedIncomeLabel.frame = CGRectMake((expectedIncomeWidth - _incomeSize.width)/2, 100, _incomeSize.width, _incomeSize.height);
        
        _birdCionLabel.frame = CGRectMake((expectedIncomeWidth + (expectedIncomeWidth - birdCoinSize.width)/2), 100, birdCoinSize.width, birdCoinSize.height);
        
        _birdCionLabel.text = expectedBirdCoinString;
        [_birdCionLabel sizeToFit];
    }
    
    _expectedIncomeLabel.text = expectedCollectString;
    [_expectedIncomeLabel sizeToFit];
    
    _expectedIncomeSubLabel.centerX = _expectedIncomeLabel.centerX;
    _expectedIncomeSubLabel.top = _expectedIncomeLabel.bottom;
    
    _coinLabel.centerX = _birdCionLabel.centerX;
    _coinLabel.top = _birdCionLabel.bottom;
    
    self.button.left = _expectedIncomeLabel.right - 10;
    
    NSUserDefaults *buttonStatus = [NSUserDefaults standardUserDefaults];
    [buttonStatus objectForKey:kButtonEyesStatus];
    if ([[buttonStatus objectForKey:kButtonEyesStatus] integerValue]) {
        self.show =YES;
        self.button.selected =YES;
    }
    
    if (self.button.selected == YES) {
        if (hasUserName) {
            NSString *user = [StringUtil starsReplacedOfString:_name withinRange:NSMakeRange(1, 1)];
            _userNameLabel.text = [NSString stringWithFormat:locationString(@"hello"),user];
        }
        self.cellView.isShow = YES;
        _expectedIncomeLabel.text = [_expectedIncomeLabel.text stringByReplacingOccurrencesOfString:_expectedIncomeLabel.text withString:@"****"];
        _birdCionLabel.text = [_birdCionLabel.text stringByReplacingOccurrencesOfString:_birdCionLabel.text withString:@"****"];
        
        _expectedIncomeLabel.width = 65;
        if (_birdCionLabel.hidden == YES) {
            _expectedIncomeLabel.left = (kScreenWidth - 65)/2;
        }else{
            _expectedIncomeLabel.left = (kScreenWidth/2 - 65)/2;
        }

    }else{
        self.cellView.isShow = NO;
        _expectedIncomeLabel.text =_expectedCollectString;
        _birdCionLabel.text = _expectedBirdCoinString;
        _userNameLabel.text = [NSString stringWithFormat:locationString(@"hello"),_name];
   
        _expectedIncomeLabel.width = _incomeSize.width;
        if (_birdCionLabel.hidden == YES) {
            _expectedIncomeLabel.left = (kScreenWidth - _incomeSize.width)/2;
            
        }else{
            _expectedIncomeLabel.left = (kScreenWidth/2 - _incomeSize.width)/2;

        }
    
    }
    _button.left = _expectedIncomeLabel.right -10;
    _expectedIncomeLabel.adjustsFontSizeToFitWidth = YES;
    
    [self.cellView updateCell];
}

- (UIView *)creatHeadView{
    
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kAccountActionHeaderHeight)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.headView.frame];
    imageView.image = [UIImage imageNamed:@"icon_accountBg"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [self.headView addSubview:imageView];
    
    UIImage *setImage = [[UIImage imageNamed:@"icon_setting"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIButton *settingButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 20, kGeneralHeight, kGeneralHeight)];
    [settingButton setImage:setImage forState:UIControlStateNormal];
    [settingButton setTitleColor:[UIColor colorWithHexString:@"#3A3A3A"] forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(accountInfo) forControlEvents:UIControlEventTouchUpInside];
  //  [self.headView addSubview:settingButton];
    
    UIImage *messageImage = [[UIImage imageNamed:@"icon_message"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIButton *messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    messageButton.frame = CGRectMake(kScreenWidth - kGeneralHeight*2.2 + 10, 20, kGeneralHeight*2.2, kGeneralHeight);
    [messageButton setImage:messageImage forState:UIControlStateNormal];
    [messageButton setImageEdgeInsets:UIEdgeInsetsMake(0, (kGeneralHeight - messageImage.size.width), 0, 0)];
    [messageButton addTarget:self action:@selector(messageClick) forControlEvents:UIControlEventTouchUpInside];
    [messageButton addSubview:self.amountLabel];
   // [self.headView addSubview:messageButton];
    
    UILabel * userNameLabel = [Utility createLabel:[CustomerizedFont systemFontOfSize:14] color:[UIColor whiteColor]];
    userNameLabel.textColor = [UIColor whiteColor];
    [self.headView addSubview:userNameLabel];
    _userNameLabel = userNameLabel;
    
    UIButton * revenueDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [revenueDetailBtn setTitle:locationString(@"check_income_detail") forState:UIControlStateNormal];
    [revenueDetailBtn setTitleColor:HexRGB(0x0090ff) forState:UIControlStateNormal];
    revenueDetailBtn.titleLabel.font=[UIFont systemFontOfSize:11];
    [revenueDetailBtn sizeToFit];
    revenueDetailBtn.centerY = userNameLabel.centerY + 35;
    revenueDetailBtn.right = kScreenWidth - 12;
    [revenueDetailBtn setEnlargeEdge:10];
    [revenueDetailBtn addTarget:self action:@selector(showRevenueDetail:) forControlEvents:UIControlEventTouchUpInside];
   // [self.headView addSubview:revenueDetailBtn];
    
    NSArray * expectedIncomeTitles = @[locationString(@"uncollected_revenue"), locationString(@"uncollected_bird_coin")];
    //布局待收收益和待收鸟币
    _expectedIncomeLabel = [[UILabel alloc]init];
    _expectedIncomeLabel.textColor = [UIColor whiteColor];
    _expectedIncomeLabel.userInteractionEnabled = YES;
    _expectedIncomeLabel.textAlignment = NSTextAlignmentCenter;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showRevenueDetail:)];
    [_expectedIncomeLabel addGestureRecognizer:tap];

    [self.headView addSubview:_expectedIncomeLabel];
    
    _expectedIncomeSubLabel = [Utility createLabel:kFont(11) color:[UIColor whiteColor]];
    _expectedIncomeSubLabel.text = expectedIncomeTitles[0];
    _expectedIncomeSubLabel.userInteractionEnabled = YES;
    [_expectedIncomeSubLabel sizeToFit];
    [self.headView addSubview:_expectedIncomeSubLabel];
    
    UITapGestureRecognizer * taps = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showRevenueDetail:)];
    [_expectedIncomeSubLabel addGestureRecognizer:taps];
    
    _birdCionLabel = [[UILabel alloc]init];
    [self.headView addSubview:_birdCionLabel];
    _expectedIncomeLabel.font = [CustomerizedFont heiti:32];
    _birdCionLabel.font = [CustomerizedFont heiti:32];

    _birdCionLabel.textColor = [UIColor whiteColor];
    _birdCionLabel.textAlignment = NSTextAlignmentCenter;
    
    _coinLabel = [Utility createLabel:kFont(11) color:[UIColor whiteColor]];
    _coinLabel.text = expectedIncomeTitles[1];
    [_coinLabel sizeToFit];
    
    [self.headView addSubview:_coinLabel];
    [self.headView addSubview:self.button];
    
    LTNAccountCell *cellView = [[LTNAccountCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kGeneralHeight)];
    cellView.bottom=256;
    cellView.delegate = self;
    [self.headView addSubview:cellView];
    self.cellView = cellView;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    lineView.bottom=cellView.top;
    lineView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:0.4];
    [self.headView addSubview:lineView];

    //提现充值按钮
    NSArray * actions = @[@"withdraw",@"prepay"];
    NSArray * titles = @[locationString(@"with_draw_title"),locationString(@"deposit")];
    CGFloat width = (kScreenWidth - 6 * kSide) * 0.5;
    CGFloat y = lineView.top -kGeneralHeight;
    NSArray *imgArray = @[@"icon_tixian",@"icon_recharge"];
    for (int i = 0; i < 2; i++) {
        CGFloat x = kSide*2.5 + (kSide + width) * i;
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, kGeneralHeight-7)];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.titleLabel.font = [CustomerizedFont heiti:15];
        //[button setEnlargeEdge:10];
        [button setImage:[UIImage imageNamed:imgArray[i]] forState:UIControlStateNormal];
        button.imageEdgeInsets =  UIEdgeInsetsMake(5, -10, 5, button.titleLabel.size.width);//上左下右
        if (i ==1) {
            button.frame = CGRectMake(x+10, y, width, kGeneralHeight-7);
        }
        SEL selName = NSSelectorFromString(actions[i]);
        [button addTarget:self action:selName forControlEvents:UIControlEventTouchUpInside];
        [self.headView addSubview:button];
        
    }
    return _headView;
}

//计算文字的大小
- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize
{
    //    CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    
    CGSize nameSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return nameSize;
}

#pragma mark - tabelview datasource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = self.tableView.backgroundColor;
    }
    
    return cell;
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (indexPath.section == 0) {
            LTNAccountCell * cell = [[LTNAccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
    
            if (self.show) {
                cell.isShow=YES;
            }
            return cell;
        }
    
        LTNAccountDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LTNAccountDetailCell"];
        NSDictionary * dic = self.accountList[indexPath.row];
        cell.textLabel.text = dic[@"title"];
        cell.imageView.image = [UIImage imageNamed:dic[@"image"]];
    
        if([dic[@"title"] isEqualToString:@"我的随心投"]){
            //红点显示条件：首次进入程序显示，点击随心投之后永远消失
            NSNumber *hadShowRedPoint = [[NSUserDefaults standardUserDefaults] valueForKey:@"HadShowRedPoint"];
            if([hadShowRedPoint boolValue])
                cell.pointButton.hidden=YES;
            else
                cell.pointButton.hidden=NO;
        }else if([dic[@"title"] isEqualToString:@"我要借款"]){
            //红点显示条件：首次进入程序显示，点击随心投之后永远消失
            NSNumber *hadShowLoanRedPoint = [[NSUserDefaults standardUserDefaults] valueForKey:@"HadShowRedLoanPoint"];
            if([hadShowLoanRedPoint boolValue])
                cell.pointButton.hidden=YES;
            else
                cell.pointButton.hidden=NO;
        }else{
            cell.pointButton.hidden=YES;
        }
    
    return cell;
}
 */

#pragma mark -collectionView datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.accountList1.count;
    }else{
        return self.accountList2.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        LTNAccountDetailCollectionCell *cell;
        if(indexPath.item == 0){
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseId2 forIndexPath:indexPath];
        }if (indexPath.item == 1){
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdParter forIndexPath:indexPath];
        }
        
        //设置cell的背景颜色
        cell.backgroundColor = self.tableView.backgroundColor;

        NSDictionary *dic =self.accountList1[indexPath.item];
        cell.titleLabel.text = dic[@"title"];
        cell.detailLabel.text = dic[@"detail"];
        cell.img.image = [UIImage imageNamed:dic[@"image"]];
        cell.taskSchedul.hidden = YES;
    
//        NSString *titleString = [NSString stringWithFormat:@"%d/%d",[CurrentUser mine].accountInfo.myTasking,[CurrentUser mine].accountInfo.myTask];
        
        CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
        CGSize taskSize =[_taskString boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [CustomerizedFont heiti:11]} context:nil].size;
        
        if (indexPath.item == 0) {
            cell.view1.frame = CGRectMake(10, 15, (kScreenWidth - 30)/2, 60);
            cell.taskSchedul.hidden = NO;
            cell.taskSchedul.frame = CGRectMake(cell.titleLabel.right, 12, taskSize.width + 10, taskSize.height);
            cell.taskSchedul.text = _taskString;
        }if (indexPath.item == 1) {
            cell.view1.frame = CGRectMake(5, 15, (kScreenWidth - 30)/2, 60);
        }
        
        if([cell.titleLabel.text isEqualToString:locationString(@"my_friends")]){
            if([GuideShadeView shouldShowTeachingViewWithType:LTNTeachTypeParter]){
                [GuideShadeView addTeachType:LTNTeachTypeParter withView:cell.view1];
            }
        }
        [cell.detailLabel sizeToFit];
        return cell;
    }
    
    NSDictionary *dic =self.accountList2[indexPath.item];
    LTNAccountCollectionCell *cell;
    if([dic[@"title"] isEqualToString:locationString(@"text_money_volume")]){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdTicket forIndexPath:indexPath];
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseId1 forIndexPath:indexPath];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.titleLabel.text = dic[@"title"];
    cell.detailLabel.text = dic[@"detail"];
    cell.img.image = [UIImage imageNamed:dic[@"image"]];
    cell.line2.hidden = NO;
    cell.detailLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    cell.titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    
    if([dic[@"title"] isEqualToString:locationString(@"tab_new_account_sxt")]){
        //红点显示条件：首次进入程序显示，点击随心投之后永远消失
        NSNumber *hadShowRedPoint = [[NSUserDefaults standardUserDefaults] valueForKey:@"HadShowRedPoint"];
        if([hadShowRedPoint boolValue])
            cell.pointButton.hidden=YES;
        else
            cell.pointButton.hidden=NO;
    }else if([dic[@"title"] isEqualToString:locationString(@"loan_title")]){
        //红点显示条件：首次进入程序显示，点击随心投之后永远消失
        NSNumber *hadShowLoanRedPoint = [[NSUserDefaults standardUserDefaults] valueForKey:@"HadShowRedLoanPoint"];
        if([hadShowLoanRedPoint boolValue])
            cell.pointButton.hidden=YES;
        else
            cell.pointButton.hidden=NO;
    }else{
        cell.pointButton.hidden=YES;
    }
//    if (indexPath.item == 3) {
//        cell.line2.hidden = YES;
//        
//    }
    if (indexPath.item == 2) {
        cell.line2.hidden = YES;
        
        NSString *investString= _investString ? _investString :@"0";
      //  NSString *string = [NSString stringWithFormat:@"%d",[CurrentUser mine].accountInfo.myOrder];
        cell.detailLabel.text =[NSString stringWithFormat:locationString(@"lntcount_product_tab"),investString];;
        [cell.detailLabel addAttributes:@{NSForegroundColorAttributeName : HexRGB(0xea5504)} forString:investString];
    }else if (indexPath.item == 3){
        cell.line2.hidden = YES;
        
      //  NSString *string = [NSString stringWithFormat:@"%d",[CurrentUser mine].accountInfo.myCoupons];
        NSString *fincalString= _fincalString ? _fincalString :@"0";
        cell.detailLabel.text = [NSString stringWithFormat:locationString(@"usable_coupon"),fincalString];
        [cell.detailLabel addAttributes:@{NSForegroundColorAttributeName : HexRGB(0xea5504)} forString:fincalString];
        
    }else if (indexPath.item == 0){
        cell.line2.hidden = YES;
    }else if (indexPath.item == 1){
        cell.line2.hidden = YES;
    }else if (indexPath.item == 4){
        // cell.detailLabel.text = _loanStringStatus;
    }
    [cell.detailLabel sizeToFit];
    
    if([cell.titleLabel.text isEqualToString:locationString(@"text_money_volume")]&&
       [GuideShadeView shouldShowTeachingViewWithType:LTNTeachTypeBirdTicket]){
        [GuideShadeView addTeachType:LTNTeachTypeBirdTicket withView:cell];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
//    if(indexPath.section==0&&indexPath.item==1&&[GuideShadeView shouldShowTeachingViewWithType:LTNTeachTypeParter]){
//        [GuideShadeView showTeachType:LTNTeachTypeParter withCloseBlock:^{
//            [GuideShadeView showTeachType:LTNTeachTypeBirdCoin withCloseBlock:^{
//                [GuideShadeView showTeachType:LTNTeachTypeBirdTicket withCloseBlock:^{
//                    
//                }];
//            }];
//        }];
//        
//    }
    
    if(indexPath.section==0&&indexPath.item==1&&[GuideShadeView shouldShowTeachingViewWithType:LTNTeachTypeParter]){
        if([self isFirstController]){
            [self showTeachView];
        }else{
            self.shouldShowTeach=YES;
        }
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSDictionary * dic = nil;
    if (indexPath.section == 0) {
        dic = self.accountList1[indexPath.item];
    }else{
        dic = self.accountList2[indexPath.item];
    }
    
    NSString * selName = dic[@"sel"];
    SEL action = NSSelectorFromString(selName);
    if([self respondsToSelector:action])
        [self performSelector:action withObject:nil afterDelay:0.0f];
}

#pragma mark collectionView 头部大小和脚步大小

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderView forIndexPath:indexPath];
  
        /*
        if(headerView.subviews.count>0){
            [self.headView removeFromSuperview];
            self.headView=nil;
        }
         */
            
        if (!headerView.subviews.count) {
            [headerView addSubview:[self creatHeadView]];
        }
        
        reusableView = headerView;
        
        [self updateHeaderView];
    }
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterView forIndexPath:indexPath];
        
        footView.backgroundColor = self.tableView.backgroundColor;
        reusableView = footView;
    }
    return reusableView;
}


#pragma mark - UICollectionViewDelegateFlowLayout
//cell的网格视图大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(kScreenWidth/2, 90);
    }
    return CGSizeMake(kScreenWidth/2,60);
}

// 设置每个cell上左下右相距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    if (section == 0) {
//        return UIEdgeInsetsMake(5, 5, 5, 5);
//    }else{
//        return UIEdgeInsetsMake(0, 0, 0, 0);
//    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    if (section == 0) {
//        return 10;
//    }
    return 0;
    
}

// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
//    if (section == 0) {
//        return 10;
//    }
    return 0;
}

//设置collectionView头部大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = {0,0};
    if (section == 0) {
        CGSize size = {kScreenWidth,kAccountActionHeaderHeight};
        return size;
    }
    return size;
}

//设置collectionView脚部大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size = {0,0};
    if (section == 1) {
        CGSize size = {kScreenWidth,10};
        return size;
    }
    return size;
}

#pragma mark 消息中心上显示数量的按钮
-(UILabel *)amountLabel{
    if (!_amountLabel) {
        CGFloat  messageLabelWidth = 16;
        CGFloat  messageLabelHeight = 16;
        CGFloat  messageLabelX = 65;
        CGFloat  messageLabelY = 6;
        
        _amountLabel = [Utility createLabel:[CustomerizedFont heiti:10] color:[UIColor whiteColor]];
        _amountLabel.frame = CGRectMake(messageLabelX, messageLabelY, messageLabelWidth, messageLabelHeight);
        _amountLabel.textAlignment = NSTextAlignmentCenter;
        _amountLabel.backgroundColor = [UIColor redColor];
        _amountLabel.layer.cornerRadius = 8;
        _amountLabel.layer.masksToBounds = YES;
        
        if (_amountLabel.text == nil) {
            _amountLabel.hidden = YES;
        }
    }
    return _amountLabel;
}

#pragma mark - 点击cell方法
#pragma mark 我的安心投
//- (void)myOfflineOrder
//{
//    LTNMyOfflineOrderController * controller = [[LTNMyOfflineOrderController alloc] init];
//    controller.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:controller animated:YES];
//}

#pragma mark 我的众筹
-(void)arrange{
    LTNMyArrangeViewController *arrange = [[LTNMyArrangeViewController alloc]init];
    arrange.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:arrange animated:YES];    
}

#pragma mark 我的互助
-(void)eachHelp{
    LTNMyEachHelpViewController *eachHelp = [[LTNMyEachHelpViewController alloc]init];
    eachHelp.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:eachHelp animated:YES];
}

#pragma mark 我的随心投
- (void)myCurrentDeposit
{
    BOOL showSXT = [LTNCore shouldShowCurrentInvestment];
    
    if (showSXT) {
        
        [self enterCurrentDeposit];
        
        return;
    }

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:locationString(@"dialog_call_service_title") message:locationString(@"current_deposit_suggestment") delegate:nil cancelButtonTitle:locationString(@"think_again") otherButtonTitles:locationString(@"do_not"), nil];
        
    [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            
        if (buttonIndex == 1) {
            
            [self enterCurrentDeposit];
        }
    }];
    
}

-( void)enterCurrentDeposit{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"HadShowRedPoint"];
    LTNMyCurrentDepositController * controller = [[LTNMyCurrentDepositController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark 我要借款
-(void)loanList{
    
    if(![CurrentUser verifyedRealName])
    {
        _verifyRealNameAlertView = [[UIAlertView alloc] initWithTitle:nil message:locationString(@"realname_text") delegate:self cancelButtonTitle:locationString(@"cancel") otherButtonTitles:locationString(@"next"), nil];
        [_verifyRealNameAlertView show];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:@YES forKey:@"HadShowRedLoanPoint"];
    // 借款用h5展示
    if (_loanSettingStatus == 2) {
        CustomizedBackWebViewController * webViewController = [[CustomizedBackWebViewController alloc] initWithURL:_loanSettingDetail];
        webViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webViewController animated:YES];
        return;
    }
    
    [self showWaitingIcon];
    [BaseDataEngine apiForPath:kLoanQuery method:kGetMethod parameter:nil responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        [self dismissWaitingIcon];
        if(!error){
            _loanTotalCount=esInteger(data[@"totalCount"]);
            
            if (_loanTotalCount == 0) {
                LoanListViewController *loanController= [[LoanListViewController alloc] init];
                loanController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:loanController animated:YES];
            }else if (_loanTotalCount == 1){
                LTNLoanProgressController *controller=[[LTNLoanProgressController alloc] init];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
    }];
    
    
    
    /*
    if(_loanTotalCount==0){
        LoanListViewController *loanController= [[LoanListViewController alloc] init];
        loanController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loanController animated:YES];
    }else if(_loanTotalCount==1){
        LTNLoanProgressController *controller=[[LTNLoanProgressController alloc] init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
     */
}
#pragma mark 我的投资
-(void)myInvestment{
    LTNMyInvestmentViewController *controller=[[LTNMyInvestmentViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark 我的理财金券
-(void)ticketList{
    
    FinanciaCouponViewController *controller=[[FinanciaCouponViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark 账户信息
-(void)accountInfo{
    LTNAccountInfoController *controller=[[LTNAccountInfoController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark 我的任务
-(void)showMyTask{
    [self showMyTaskWithAnimated:YES];
}

-(LTNMyTaskController *)showMyTaskWithAnimated:(BOOL)animated{
    LTNMyTaskController *myTask = [[LTNMyTaskController alloc]init];
    myTask.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myTask animated:animated];
    return myTask;
}

#pragma mark - accountCell delegate
- (void)accountCellWillShowUsableBalanceDetail
{
    DLog(@"可用余额明细");
    LTNBaseDetailController * detailController = [[LTNBaseDetailController alloc] init];
    detailController.naviTitle = locationString(@"bank_detail_balance");
    detailController.apiPath = kBalanceDetailUrl;
    detailController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailController animated:YES];
}

- (void)accountCellWillShowBirdCoinDetail
{
    DLog(@"鸟币明细");
    LTNBaseDetailController * detailController = [[LTNBaseDetailController alloc] init];
    detailController.naviTitle = locationString(@"bird_detail");
    detailController.apiPath = kBirdCoinAmountUrl;
    detailController.hidesBottomBarWhenPushed = YES;
    detailController.isHaveBiedCoinHelp = YES;
    [self.navigationController pushViewController:detailController animated:YES];
}

- (void)accountCellWillShowTotalAssetDetail
{
    DLog(@"总资产明细");
    LTNBaseStatisticsController * totalAssetController = [[LTNBaseStatisticsController alloc] init];
    totalAssetController.centerText = locationString(@"total_amount");
    totalAssetController.naviTitle = locationString(@"total_assets_all_money");
    totalAssetController.apiPath = kTotalAccountUrl;
    if ([LTNCore shouldShowCurrentInvestment]) {
        totalAssetController.colors = @[HexRGB(0x41b8fc), HexRGB(0xEA5503), HexRGB(0xFF75AD), HexRGB(0xFFC000), HexRGB(0x78E8B8), [UIColor colorWithHexString:@"#800080"]];
    } else {
        totalAssetController.colors = @[HexRGB(0x41b8fc), HexRGB(0xEA5503), HexRGB(0xFF75AD), HexRGB(0x78E8B8), [UIColor colorWithHexString:@"#800080"]];
    }
    totalAssetController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:totalAssetController animated:YES];
}

#pragma mark - 私有方法
#pragma mark 收益明细
- (void)showRevenueDetail:(UIGestureRecognizer *)recognizer
{
    DLog(@"收益明细");
    LTNRevenueController * revenueController = [[LTNRevenueController alloc] init];
    revenueController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:revenueController animated:YES];
}

#pragma mark 提现
- (void)withdraw
{
    if([self verifyRealNameandboundBank]){
        //pc端和手机端可以同时登陆，在进行提现操作的时候先进行账户金额的刷新及提现次数的拉取
        [LTNServerHelper retrieveAccountInfoContainFreeCountWithFinishBlock:^{
            
        }];
        [LTNCore chargeViewController:^{
            [self pullReload];
        }];
    }
}

#pragma mark 充值
- (void)prepay
{
    if([self verifyRealNameandboundBank]){
        [LTNCore rechargeViewController:^{
            [self pullReload];
        }];
    }
}

#pragma mark 验证是否完成用户认证、银行卡认证
-(BOOL)verifyRealNameandboundBank
{
    if(![CurrentUser verifyedRealName])
    {
        _verifyRealNameAlertView = [[UIAlertView alloc] initWithTitle:nil message:locationString(@"realname_text") delegate:self cancelButtonTitle:locationString(@"cancel") otherButtonTitles:locationString(@"next"), nil];
        [_verifyRealNameAlertView show];
        return NO;
    }
    else if(![CurrentUser bindedBankCard])
    {
        _boundBankCardAlertView = [[UIAlertView alloc] initWithTitle:nil message:locationString(@"bindbank_text") delegate:self cancelButtonTitle:locationString(@"cancel") otherButtonTitles:locationString(@"next"), nil];
        [_boundBankCardAlertView show];
        return NO;
    }
    return YES;
}

//button 懒加载
- (UIButton *)button{
    if (_button == nil) {
        _button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
        _button.top = 95;
        [_button setImage:[UIImage imageNamed:@"icon_hideeyes"] forState:UIControlStateSelected];
        [_button setImage:[UIImage imageNamed:@"icon_showeyes"] forState:UIControlStateNormal];
        //[self.button setEnlargeEdge:5];
        [_button addTarget:self action:@selector(showInfo:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (void)showInfo:(UIButton *)btn{
    
    if (btn.selected == NO) {
       
        self.show =YES;
        btn.selected =YES;
        self.cellView.isShow = YES;
        if (hasUserName) {
            NSString *user = [StringUtil starsReplacedOfString:_name withinRange:NSMakeRange(1, 1)];
            _userNameLabel.text = [NSString stringWithFormat:locationString(@"hello"),user];
        }
        
        _expectedIncomeLabel.width = 65;
        if (_birdCionLabel.hidden == YES) {
           _expectedIncomeLabel.left = (kScreenWidth - 65)/2;
        }else{
            _expectedIncomeLabel.left = (kScreenWidth/2 - 65)/2;
        }
        
        _expectedIncomeLabel.text = [_expectedIncomeLabel.text stringByReplacingOccurrencesOfString:_expectedIncomeLabel.text withString:@"****"];
        _birdCionLabel.text = [_birdCionLabel.text stringByReplacingOccurrencesOfString:_birdCionLabel.text withString:@"****"];
        
        [[NSUserDefaults standardUserDefaults] setValue:@(self.show) forKey:PrivateShow];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kButtonEyesStatus];
        
    }else{
    
        btn.selected = NO;
        self.show = NO;
        self.cellView.isShow = NO;
    
        _expectedIncomeLabel.width = _incomeSize.width;
        if (_birdCionLabel.hidden == YES) {
            _expectedIncomeLabel.left = (kScreenWidth - _incomeSize.width)/2;
            
        }else{
            _expectedIncomeLabel.left = (kScreenWidth/2 - _incomeSize.width)/2;
        }
        
        _userNameLabel.text = [NSString stringWithFormat:locationString(@"hello"),_name];
        _expectedIncomeLabel.text =_expectedCollectString;
        _birdCionLabel.text = _expectedBirdCoinString;

        
        [[NSUserDefaults standardUserDefaults] setValue:@(self.show) forKey:PrivateShow];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kButtonEyesStatus];
    }
    _button.left = _expectedIncomeLabel.right -10;
    _expectedIncomeLabel.adjustsFontSizeToFitWidth = YES;
}

//合伙人按钮的回调
-(void)showPartner{
    LTNPartnerViewController *partner=[[LTNPartnerViewController alloc]init];
    partner.ownName = _name;
    partner.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:partner animated:YES];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView == _verifyRealNameAlertView) {
        if (buttonIndex == 1)
        {
            [LTNCore verifyRealNameViewController:^{
                
            }];
        }
    }
    if (alertView == _boundBankCardAlertView) {
        if (buttonIndex == 1)
        {
            [LTNCore boundBankCardViewController:^{
                
            }];
        }
    }
}

//消息中心
-(void)messageClick{
    LTNMessageViewController *message = [[LTNMessageViewController alloc]init];
    message.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:message animated:YES];
}

@end
