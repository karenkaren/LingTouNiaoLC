//
//  ShowBankInfoController.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/5/4.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "ShowBankInfoController.h"
#import "BankInfoCell.h"
#import "RepalceSuccessViewController.h"
#import "ReplaceBankCardViewController.h"
#import "ReplceFailureViewController.h"
#import "ShowSupplyViewController.h"
#import "ShowBankInfoController.h"
#import "TableViewDevider.h"

@interface ShowBankInfoController ()

@property (nonatomic,strong) SXMarquee * marView;
@property (nonatomic,strong) NSString * bankNotice;

@property (nonatomic, strong) UIButton * changeBtn;
@property (nonatomic, assign) NSInteger scheduleStatusType;//cheduleStatusType:STATUS_1("1", "使用中"),//换卡成功 STATUS_3("3", "换卡中"),//换卡申请成功STATUS_5("5", "换卡失败"),STATUS_6("6", "处理中（涉及资料上传，人工审核）"),STATUS_8("8", "不明（需要人工查询）"),STATUS_9("9", "其他（需要人工查询）")
@property (nonatomic, assign) NSInteger check;//0更换银行卡，1查询换卡进度
@property (nonatomic, copy) NSString * reasonString;//换卡失败的原因
@property (nonatomic, copy) NSString * bankId;

@end

@implementation ShowBankInfoController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self dissmissWithBackButton];
    [self loadBankNotice];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    if(_marView){
        [_marView removeFromSuperview];
        _marView =nil;
    }
}

- (void)viewDidLoad
{
    self.hideRefreshHeader = YES;
    [super viewDidLoad];
    self.title = locationString(@"bank_card_setting");
    
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = DEVIDE_LINE_COLOR;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    [self initData];
    [self loadBankNotice];
    _scheduleStatusType = 0;
    [self loadScheduleStatusType];//请求换卡的类型
    [self initFooterView];
}

- (void)back {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

- (void)initFooterView
{
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1.0 / [UIScreen mainScreen].scale)];
    lineView.backgroundColor = DEVIDE_LINE_COLOR;
    [footerView addSubview:lineView];
    
    if (!_changeBtn) {
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeBtn.frame = CGRectMake(100, 200, 100, 34);
        _changeBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [_changeBtn setTitleColor:COLOR_MAIN forState:UIControlStateNormal];
        _changeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _changeBtn.right = footerView.width - 15;
        _changeBtn.top = 10;
        [footerView addSubview:_changeBtn];
        [_changeBtn addTarget:self action:@selector(changeBtnClcik:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.tableView.tableFooterView = footerView;
}

- (void)loadScheduleStatusType
{
    [BaseDataEngine apiForPath:kScheduleStatus method:kPostMethod parameter:nil responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        if(data&&isDictionary(data)){
            _scheduleStatusType = [data[@"tag"] integerValue];
            _bankId = data[@"id"];
            _check = [data[@"check"] integerValue];;
            if (_scheduleStatusType == 5)
                _reasonString = data[@"remark"];
            [_changeBtn setTitle:_check ? locationString(@"check_change_card") :locationString(@"change_bank_card_title") forState:UIControlStateNormal];
        }
    }];
}

- (void)loadBankNotice
{
    [LTNServerHelper bankNotice:^(id response) {
        if(response&&isDictionary(response)){
            NSDictionary *data=response[@"data"];
            if(data&&isDictionary(data)){
                NSString *notice=esString(data[@"notice"]);
                self.bankNotice=notice;
                [self showMarqueeView];
                
            }
        }
    } failure:nil];
}

- (void)changeBtnClcik:(UIButton *)sender
{
    self.changeBtn.hidden = NO;
    if (!_check) {
        ReplaceBankCardViewController *viewController = [[ReplaceBankCardViewController alloc]init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else{
        switch (_scheduleStatusType) {
            case 0:
                self.changeBtn.hidden = YES;
                break;
                
            case 1:
            {
                [self loadIsRead];
                RepalceSuccessViewController *viewController = [[RepalceSuccessViewController alloc]init];
                viewController.titleString = locationString(@"change_card_success");
                viewController.statusString = locationString(@"change_bank_ok");
                viewController.desString =locationString(@"apply_ok_tag");
                [self.navigationController pushViewController:viewController animated:YES];
            }
                break;
                
            case 3:
            {
                RepalceSuccessViewController *viewController = [[RepalceSuccessViewController alloc]init];
                viewController.titleString = locationString(@"submit_success");
                viewController.statusString = locationString(@"submit_success");
                viewController.desString = locationString(@"change_bank_wait_check");
                [self.navigationController pushViewController:viewController animated:YES];
            }
                break;
                
            case 5:
            {
                [self loadIsRead];
                ReplceFailureViewController *viewController = [[ReplceFailureViewController alloc]init];
                viewController.buttonTitle = locationString(@"btn_resubmit");
                viewController.reasonString = _reasonString;
                viewController.type = 5;
                [self.navigationController pushViewController:viewController animated:YES];
            }
                break;
                
            case 6:
            {
                ShowSupplyViewController *viewController = [[ShowSupplyViewController alloc]init];
                [self.navigationController pushViewController:viewController animated:YES];
            }
                break;
            case 8:
            case 9:
            {
                ReplceFailureViewController *viewController = [[ReplceFailureViewController alloc]init];
                viewController.buttonTitle = locationString(@"connect_service");
                viewController.reasonString = locationString(@"change_bank_error");
                viewController.type = 8;
                [self.navigationController pushViewController:viewController animated:YES];
            }
                break;
                
            default:
                break;
        }
        
    }
}
- (void)loadIsRead
{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc]init];
    [parameter setValue:_bankId forKey:@"id"];
    kWeakSelf
    [BaseDataEngine apiForPath:kHasReadDesStatus method:kPostMethod parameter:parameter responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
        if (!error) {
            [weakSelf  loadScheduleStatusType];
        }
    }];
}

-(void)showMarqueeView{
    
    NSString *msg = self.bankNotice;
    
    if(_marView){
        [_marView removeFromSuperview];
        _marView =nil;
    }
    
    
    if([msg length]>0){//显示
        _marView = [[SXMarquee alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 25) speed:4 Msg:msg bgColor:[UIColor colorWithRed:255.0/255 green:254.0/255 blue:223.0/255 alpha:1.0] txtColor:[UIColor colorWithHexString:@"#EA5504"]];
        [_marView changeMarqueeLabelFont:[UIFont systemFontOfSize:12]];
        [_marView start];
        self.tableView.tableHeaderView = _marView;
    }
    
    [self.tableView reloadData];
}

-(void)initData{
    NSArray * array = @[
                      @{@"title" : locationString(@"bankcard_owner"),
                       @"value" : [StringUtil starsReplacedOfString:[CurrentUser mine].userInfo.userName withinRange:NSMakeRange(1, 1)]
                       },
                      @{@"title" : locationString(@"support_card_own"),
                       @"value" : [CurrentUser mine].userInfo.belongBank
                       },
                      @{@"title" : locationString(@"card_id"),
                       @"value" : [StringUtil starsReplacedOfString:[CurrentUser mine].userInfo.bankNo withinRange:NSMakeRange(4,[CurrentUser mine].userInfo.bankNo.length-8)]
                       }
                       ];
    [self.data addObjectsFromArray:array];
}

#pragma mark - tableview datasource
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
    static NSString * CellIdentifier = @"BankInfoCell";
    BankInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[BankInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.cellDic = self.data[indexPath.row];
    
    return cell;
}

#pragma mark - tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0 / [UIScreen mainScreen].scale;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [TableViewDevider getHeaderView];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
