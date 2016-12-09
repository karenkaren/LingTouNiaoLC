//
//  LTNPartnerViewController.m
//  lingtouniao
//
//  Created by 郑程锋 on 15/12/24.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNPartnerViewController.h"
#import "LTNFriendsViewController.h"
#import "LTNRewardsViewController.h"
//#import "ShareSnsUtil.h"
#import "BaseWebViewController.h"
#import "LTNServerConstant.h"
#import "LTNAddPartnerViewController.h"
#import "QRCodeViewController.h"


#import "PartnerIntroduceViewController.h"

#import "UIImageView+WebCache.h"

#define kAccountHeaderHeight 149 + 51
#define kMargin 20

@interface LTNPartnerModel : BaseModel

@property (nonatomic) NSString *totalReward;//累计奖励金额
@property (nonatomic) NSString *isPartnerUp;//是否有上线 0没有 1有
@property (nonatomic) NSString *isPartnerDown;//是否有下线 0没有 1有
@property (nonatomic) NSString *mobile;//手机号
@property (nonatomic) NSString *isStaff;//是否是内部员工 0不是 1是
@property (nonatomic) NSString *userLerver;
@property (nonatomic) NSString *myPhone;

@property (nonatomic) NSString *registeredNum;//注册人数
@property (nonatomic) NSString *bkPersonNum;//绑卡人数
@property (nonatomic) NSString *investNum;//投资人数

@property (nonatomic) NSString *iconUrl;//勋章

@end

@implementation LTNPartnerModel


@end

@interface LTNPartnerViewController ()

@property (nonatomic) NSString *expectedIncomeString;

@property (nonatomic) UILabel *userNameLabel;

@property (nonatomic) UILabel *rewardLabel,*leverLab;

@property (nonatomic) LTNPartnerModel * model;

@property (nonatomic) UIView *footView;

@property (nonatomic) UIButton *shareButton;

@property (nonatomic) UIImageView *leverImg;

@property (nonatomic) NSString *num1,*num2,*num3;

@property (nonatomic) UIImage *img;

@end

@implementation LTNPartnerViewController
@synthesize model = _model;

#define kDefaultPartner @"kDefaultPartner"
-(LTNPartnerModel *)model{
    if (!_model) {
        id data = [Utility getDataWithKey:kDefaultPartner];
        if (data) {
            LTNPartnerModel *partnerModel = (LTNPartnerModel *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
            NSString *userMobile = [[NSUserDefaults standardUserDefaults] valueForKey:kUserNameKey];
            
            if ([partnerModel.myPhone isEqualToString:userMobile]) {
                _model = partnerModel;
            }
        }
    }
    return _model;
}

-(void)setModel:(LTNPartnerModel *)model{
    if (_model != model) {
        _model = model;
        id data = [NSKeyedArchiver archivedDataWithRootObject:_model];
        [Utility saveDataWithKey:kDefaultPartner ofValue:data];
    }
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self createDataSource];
    
    NSNumber *hadShowed = [[NSUserDefaults standardUserDefaults] valueForKey:@"HadShowPartnerIntroduceView"];
    if(![hadShowed boolValue]){
        [PartnerIntroduceViewController showPartnerIntroduceViewController:^{
            [self rewardRule];
        }];
        [[NSUserDefaults standardUserDefaults] setValue:@YES forKey:@"HadShowPartnerIntroduceView"];
    }
    
    [self pullReload];
}

- (void)back{
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    self.isTableViewStyleGrouped = YES;
    
    [super viewDidLoad];
    self.title = locationString(@"my_friends");
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.tableView.separatorColor =[UIColor colorWithHexString:@"#e2e2e2"];
    
    self.tableView.tableHeaderView = [self accountHeaderView];
    
    [self updateContent];
    
    UIView *shareView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 60, kScreenWidth, 60)];
    [self.view addSubview:shareView];
    
    self.shareButton = [[UIButton alloc]initWithFrame:CGRectMake(20,10, kScreenWidth - 40, 40)];
    [self.shareButton setTitle:locationString(@"partner_intend") forState:UIControlStateNormal];
    [self.shareButton setBackgroundImage:[UIImage imageNamed:@"confirmButton"] forState:UIControlStateNormal];
    [self.shareButton setImage:[UIImage imageNamed:@"icon_shares"] forState:UIControlStateNormal];
    self.shareButton.imageEdgeInsets =  UIEdgeInsetsMake(10, -10, 10, self.shareButton.titleLabel.size.width);//上左下右
    [self.shareButton addTarget:self action:@selector(inivitFriends) forControlEvents:UIControlEventTouchUpInside];
    self.shareButton.layer.masksToBounds = YES;
    self.shareButton.layer.cornerRadius = 5;
    
    [shareView addSubview:self.shareButton];
    
    
   
    
}
- (void)createDataSource{
    self.data = [@[@[
                       @{@"title":locationString(@"partner_pro_title"),
                         @"sel":@"rewardRule",
                         @"detail":locationString(@"more")},
                       @{},
                       ],
                   
                   @[
                       @{@"title":locationString(@"partner_friend"),
                         @"sel":@"friendsAccount",
                         @"detail":locationString(@"more")},
                       @{},
                       ],
                   
                   @[
                       @{@"image":@"Code",
                         @"title":locationString(@"new_partner_qbcode"),
                         @"sel":@"productQRCode"},
                       
                       @{@"title":locationString(@"new_partner_persion"),
                         @"sel":@"supplyNo",
                         @"detail":locationString(@"have_no_partner")}
                       ]
                   
                   ]mutableCopy];

}

- (UIView *)accountHeaderView{
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kAccountHeaderHeight)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:headerView.frame];
    imageView.image = [UIImage imageNamed:@"PartnerBg"];
    [headerView addSubview:imageView];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 14, 44, 44)];
    [button setImage:[UIImage imageNamed:@"nav_return_white"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:button];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 14, kScreenWidth, 44)];
    lab.text = locationString(@"my_friends");
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor whiteColor];
    [headerView addSubview:lab];
    
    //合伙人等级
    UIView *leverView = [[UIView alloc]initWithFrame:CGRectMake(0, lab.bottom + 15, (kScreenWidth - kGeneralHeight)/2, 64)];
    [headerView addSubview:leverView];
    
    _leverLab = [Utility createLabel:[CustomerizedFont heiti:15] color:[UIColor colorWithHexString:@"#ffffff"]];
    _leverLab.frame = CGRectMake(0, 0, (kScreenWidth - kGeneralHeight)/2, 30);
    _leverLab.textAlignment = NSTextAlignmentCenter;
    _leverLab.textColor = [UIColor whiteColor];
    _leverLab.text = @"";
    [leverView addSubview:_leverLab];
    
    UILabel *leverLable = [Utility createLabel:[CustomerizedFont heiti:11] color:[UIColor colorWithHexString:@"#ffffff"]];
    leverLable.frame = CGRectMake(0, _leverLab.bottom -10, (kScreenWidth - kGeneralHeight)/2, 30);
    leverLable.text = locationString(@"new_partner_grade");
    leverLable.textAlignment = NSTextAlignmentCenter;
    [leverView addSubview:leverLable];
    
    //等级勋章图片
    _leverImg = [[UIImageView alloc]initWithFrame:CGRectMake(leverView.right + 3, lab.bottom + 10, kGeneralHeight, kGeneralHeight+20)];
    [headerView addSubview:_leverImg];
    
    //累计奖励
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake((kScreenWidth - kGeneralHeight)/2 + kGeneralHeight, lab.bottom + 15, (kScreenWidth - kGeneralHeight)/2,64)];
    _rewardLabel=[Utility createLabel:[CustomerizedFont boldHeiti:18] color:[UIColor colorWithHexString:@"#ffffff"]];
    _rewardLabel.frame=CGRectMake(0, 0, (kScreenWidth - kGeneralHeight)/2, 30);
    _rewardLabel.text = @"";
    _rewardLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:_rewardLabel];
    
    NSString * title = locationString(@"new_partner_yuan");
    UILabel *label = [Utility createLabel:[CustomerizedFont heiti:11] color:[UIColor colorWithHexString:@"#ffffff"]];
    label.frame = CGRectMake(0, _rewardLabel.bottom - 10, (kScreenWidth - kGeneralHeight)/2, 30);
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick)];
    [view addGestureRecognizer:tap];
    
    //用户名label
    _userNameLabel = [Utility createLabel:[CustomerizedFont heiti:15] color:[UIColor colorWithHexString:@"#ffffff"]];
    _userNameLabel.frame = CGRectMake(0, _leverImg.bottom+15, kScreenWidth, 30);
    _userNameLabel.text = [NSString stringWithFormat:locationString(@"hello"),self.ownName];
    _userNameLabel.textAlignment = NSTextAlignmentCenter;
    _userNameLabel.adjustsFontSizeToFitWidth = YES;
    [headerView addSubview:_userNameLabel];
    
    [headerView addSubview:view];
    
    return headerView;
}

#pragma mark - tabelview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.data[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        cell.textLabel.font = [CustomerizedFont heiti:16];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    cell.textLabel.text = self.data[indexPath.section][indexPath.row][@"title"];
    cell.imageView.image = [UIImage imageNamed:self.data[indexPath.section][indexPath.row][@"image"]];
    cell.detailTextLabel.text = self.data[indexPath.section][indexPath.row][@"detail"];
    cell.detailTextLabel.font = [CustomerizedFont heiti:12];
    cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    
    CGFloat width = kScreenWidth / 3.0;
    
    if (indexPath.section == 0 && indexPath.row ==1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        NSArray * titleArray = @[locationString(@"new_partner_award"),locationString(@"new_partner_income"), locationString(@"new_partner_badge")];
        NSArray * imageArray = @[@"icon_youjiang",@"Icon_ticheng",@"Icon_tequan"];
        for (int i =0; i<titleArray.count; i++) {
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(width * i, 0, width, 70)];
            [cell.contentView addSubview:view];
            view.tag = i+666;
            
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake((width-30)/2, 12, 25, 25)];
            img.image = [UIImage imageNamed:imageArray[i]];
            [view addSubview:img];
            
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, img.bottom + 10, width, 14)];
            lab.text = titleArray[i];
            lab.textColor = [UIColor colorWithHexString:@"#999999"];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.font = [CustomerizedFont heiti:12];
            [view addSubview:lab];
            
            UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickView1:)];
            [view addGestureRecognizer:tap];
            
        }

        
    }
    
    if (indexPath.section == 1 && indexPath.row ==1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        NSArray * titleArray2 = @[locationString(@"new_partner_num"),locationString(@"new_partner_bangka"), locationString(@"new_partner_man")];
        
        for (int i =0; i<titleArray2.count; i++) {
            
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(width * i, 0, width, 60)];
            [cell.contentView addSubview:view];
            view.tag = i + 333;
            
            UILabel *labs = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, width, 20)];
            if (i==0) {
                labs.text = self.num1;
            }
            if (i==1) {
                labs.text = self.num2;
            }
            if (i==2) {
                labs.text = self.num3;
            }
            labs.textColor = [UIColor colorWithHexString:@"#333333"];
            labs.textAlignment = NSTextAlignmentCenter;
            labs.font = [CustomerizedFont heiti:18];
            [view addSubview:labs];
            
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, labs.bottom, width, 20)];
            lab.text = titleArray2[i];
            lab.textColor = [UIColor colorWithHexString:@"#999999"];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.font = [CustomerizedFont heiti:12];
            [view addSubview:lab];
            
            UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickView2:)];
            [view addGestureRecognizer:tap];
            
        }
        
    }
    
    if (indexPath.section == 2 && indexPath.row == 1) {
        cell.detailTextLabel.font = [CustomerizedFont heiti:14];
        if ([self.model.isPartnerUp isEqualToString:@"1"]) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType=UITableViewCellAccessoryNone;
            
            NSString *userNum = self.model.mobile;
            if (userNum.length == 11) {
                userNum = [userNum stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            }
            cell.detailTextLabel.text = userNum;
        }
        
        if ([self.model.isStaff isEqualToString:@"1"]) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.detailTextLabel.text = locationString(@"my_employee");
            
        }else if ([self.model.isStaff isEqualToString:@"2"]) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.detailTextLabel.text = locationString(@"my_agent");
            
        }
        
    }
    
    return cell;
}

#pragma mark - tabelview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 40;
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        return 70;
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        return 40;
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        return 60;
    }
    return 50;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10/2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = self.data[indexPath.section][indexPath.row];
    NSString *selName = dic[@"sel"];
    SEL action = NSSelectorFromString(selName);
    if ([self respondsToSelector:action]) {
        [self performSelector:action withObject:nil afterDelay:0];
    }
}

//好友奖励规则页面
- (void)rewardRule{
    
    NSString * urlString = kH5PartnerUrl;
    
    BaseWebViewController * webController = [[BaseWebViewController alloc] initWithURL:urlString];
    
    [self.navigationController pushViewController:webController animated:YES];
}

//好友统计
- (void)friendsAccount{
    LTNFriendsViewController *friends =[[LTNFriendsViewController alloc]init];
    [self.navigationController pushViewController:friends animated:YES];
}

//邀请好友
- (void)inivitFriends{
    [ShareSnsUtils shareSnsOnViewController:self delegate:self];
}

//补充推荐人手机号
- (void)supplyNo{
    if ([self.model.isPartnerUp isEqualToString:@"1"] || [self.model.isStaff isEqualToString:@"1"]||
        [self.model.isStaff isEqualToString:@"2"]) {
        return;
    }else{
        ESWeakSelf;
        LTNAddPartnerViewController *addPartner= [LTNAddPartnerViewController addPartnerViewController:^(void){
            ESStrongSelf;
            [_self getServiceData:NO];
        }];
        [self.navigationController pushViewController:addPartner animated:YES];
    }
}

//生成二维码
- (void)productQRCode{
    QRCodeViewController *code = [[QRCodeViewController alloc]init];
    code.hidesBottomBarWhenPushed = YES;
    code.nameTitle = self.model.userLerver;
    [self.navigationController pushViewController:code animated:YES];
    
}
//累计奖励界面
- (void)onClick{
    LTNRewardsViewController *rewards=[[LTNRewardsViewController alloc]init];
    rewards.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:rewards animated:YES];
}

- (void)getServiceData:(BOOL)isGetMore {
    [super getServiceData:isGetMore];
    
    [self apiForPath:kPartnerUrl method:kGetMethod parameter:nil responseModelClass:[LTNPartnerModel class] onComplete:^(id response, id data, NSError *error) {
        
        if (!error) {
            LTNPartnerModel *tmpModel = (LTNPartnerModel *)data;
            NSString *userMobile = [[NSUserDefaults standardUserDefaults] valueForKey:kUserNameKey];
            tmpModel.myPhone = userMobile;
            self.model = tmpModel;
            [self createDataSource];
        }
        if (self.model) {
            [self updateContent];
        }
    }];
    
}

- (void)updateContent {
    self.expectedIncomeString = [self.model totalReward];
    _rewardLabel.text = [NSString stringWithFormat:@"%.2f", self.expectedIncomeString.floatValue];
   
    _num1 = self.model.registeredNum;
    _num2 = self.model.bkPersonNum;
    _num3 = self.model.investNum;
    
    _leverLab.text = esString(self.model.userLerver);
    
    if ([self.model.userLerver isEqualToString:locationString(@"new_partner_nomal")]) {
        self.img = [UIImage imageNamed:@"PuTongIcon"];
    }else if ([self.model.userLerver isEqualToString:locationString(@"new_partner_gold")]){
        self.img = [UIImage imageNamed:@"GoldIcon"];
    }else if ([self.model.userLerver isEqualToString:locationString(@"new_partner_diamond")]){
        self.img = [UIImage imageNamed:@"ZuanIcon"];
    }else{
        self.img = [UIImage imageNamed:@"yonghuicon"];
    }
    
    self.leverImg.image = self.img;
    self.leverImg.width = self.img.size.width;
    self.leverImg.height = self.img.size.height;
    
    [self.tableView reloadData];

}

-(void)clickView1:(UITapGestureRecognizer *)gesture{
    
    DLog(@"点击了———========———— 第 %ld view",gesture.self.view.tag - 666);
        
    NSInteger count= gesture.self.view.tag - 666;
    
    NSString * urlString = [NSString stringWithFormat:@"%@?tag=%ld",kH5PartnerUrl,count];
    
    BaseWebViewController * webController = [[BaseWebViewController alloc] initWithURL:urlString];
    
    [self.navigationController pushViewController:webController animated:YES];

    
}

-(void)clickView2:(UITapGestureRecognizer *)gesture{
    
    DLog(@"点击了———========———— 第 %ld view",gesture.self.view.tag - 333);
    
    NSInteger count = gesture.self.view.tag - 333;
    
    LTNFriendsViewController *friends =[[LTNFriendsViewController alloc]init];
    
    friends.selectNum = count;
    
    [self.navigationController pushViewController:friends animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
