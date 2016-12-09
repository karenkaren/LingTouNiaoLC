//
//  LTNMyArrangeViewController.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/9/21.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNMyArrangeViewController.h"
#import "QCSlideSwitchView.h"
#import "BaseTableViewController.h"
#import "StringUtil.h"
#import "NSStringUtil.h"
#import "LTNServerConstant.h"
#import "LTNCrowdFundingCell.h"
#import "BaseWebViewController.h"

NSString * const kCrowdFundingCell = @"CrowdFundingCell";

@interface LTNPrepareViewController : BaseTableViewController

@property (nonatomic) NSString *parameters;

@property (nonatomic) BOOL loadSucceeds;

@end

@implementation LTNPrepareViewController

-(void)viewDidLoad{
    self.isTableViewStyleGrouped = YES;
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = DEVIDE_LINE_COLOR;
    self.tableView.sectionFooterHeight = 0;
    
    [self.tableView registerClass:[LTNCrowdFundingCell class] forCellReuseIdentifier:kCrowdFundingCell];
    
}

- (void)viewWillAppear:(BOOL)animated {
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

- (void)getServiceData:(BOOL)isGetMore {
    [super getServiceData:isGetMore];
    
    NSDictionary *dict = @{@"orderSt":self.parameters};
    [self apiForPath:kOrderZcUrl method:kGetMethod parameter:dict responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        [self.data addObjectsFromArray:[data valueForKey:@"orderZcList"]];
        if (!error || self.data.count) {
            self.loadSucceeds = YES;
        } else {
            self.loadSucceeds = NO;
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LTNCrowdFundingCell *cell = [tableView dequeueReusableCellWithIdentifier:kCrowdFundingCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.data = self.data[indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140+15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *detailUrl = [self.data[indexPath.row] valueForKey:@"zcDetailUrl"];
    
    BaseWebViewController * webController = [[BaseWebViewController alloc] initWithURL:detailUrl];
    [self.navigationController pushViewController:webController animated:YES];
}



@end


@interface LTNInvolvementViewController : LTNPrepareViewController

@end

@interface LTNRepaymentViewController : LTNPrepareViewController

@end

@implementation LTNInvolvementViewController

-(void)viewDidLoad{
    
    self.parameters = @"ZFCG";
    
    [super viewDidLoad];
    
    self.title = locationString(@"joined_Crowfunding");
    
}

@end

@implementation LTNRepaymentViewController

-(void)viewDidLoad{
    
    self.parameters = @"YHK";
    
    [super viewDidLoad];
    
    self.title = locationString(@"anxintou_huankuan");
}

@end

@interface LTNMyArrangeViewController ()<QCSlideSwitchViewDelegate>

@property (nonatomic) QCSlideSwitchView *slideSwitchView;

@property (nonatomic) NSMutableArray *viewControllers;

@end

@implementation LTNMyArrangeViewController

- (void)back{
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = locationString(@"my_Crowdfunding");
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
                     NSStringFromClass([LTNInvolvementViewController class]),
                     NSStringFromClass([LTNRepaymentViewController class])
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
    [self.slideSwitchView setSelectIndex:number animated:YES];
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
