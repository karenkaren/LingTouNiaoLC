//
//  SecondBoundBandCardViewController.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/5/3.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "SecondBoundBandCardViewController.h"
#import "BoundBankCell.h"
#import "ZHPickView.h"
#import "BoundBankCardModel.h"
#import "WPAttributedStyleAction.h"
#import "WPHotspotLabel.h"
#import "NSString+WPAttributedMarkup.h"
#import "CustomizedBackWebViewController.h"
#import "RechargeViewController.h"
#import "LTNPromptView.h"
#import "CustomAlertViews.h"
#import "CustomAlertView2.h"
#import "TaskCheckModel.h"

#define kHeaderOfSectionHeight 58
#define kMarViewHeight 25

@interface SecondBoundBandCardViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UIAlertViewDelegate,ZHPickViewDelegate>
{
    BoundBankCardModel *_viewModel;
    UIPickerView *_pickView;
    NSMutableArray *_bankArray;
    NSMutableArray *_desArray;
    NSArray *bankDicList;
    UIView * _sheetWindows;
    TaskCheckModel * _taskCheck;
}

@property (strong, nonatomic) UIButton * confirmButton;
@property (strong, nonatomic) UIView * bankDescView;
@property (strong, nonatomic) WPHotspotLabel * bankDescLabel;//银行卡邦卡说明
@property (strong, nonatomic) UIView * footerView;
@property (strong, nonatomic) UIView * bankMessageView;
@property (strong, nonatomic) UILabel * bankMessageLabel;
@property (strong, nonatomic) UILabel * cardholderLabel;//持卡人
@property (nonatomic) NSString * bankId;
@property(nonatomic,strong) ZHPickView * pickview;
@property (nonatomic,strong) SXMarquee * marView;
@property (nonatomic,strong) NSString * bankNotice;
@property (strong, nonatomic) UIView * headerViewOfSection;

@end

@implementation SecondBoundBandCardViewController

#pragma mark - regular methods
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self customizeInit];
    [self loadBankNotice];
}

- (void)viewDidLoad
{
    self.hideRefreshHeader = YES;
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    // tableview相关设置
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = DEVIDE_LINE_COLOR;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    // 通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    // 初始化数据
    [self initData];
    
    // tableview footer
    [self initFooterView];
    
    //请求银行卡列表
    [self loadData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [_pickview remove];
    if(_marView){
        [_marView removeFromSuperview];
        _marView =nil;
    }
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    if(self.navigationController.finishBlock)
        self.navigationController.finishBlock();
    [super back];
}

-(void)initUIView
{
    self.title = locationString(@"bank_card_setting");
}

#pragma mark - privately methods
- (void)initFooterView
{
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kHeaderOfSectionHeight - kMarViewHeight - self.data.count * kBoundBankCellHeight - NavigationBarHeight - StatusBarHeight)];
    // line view
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1.0 / [UIScreen mainScreen].scale)];
    lineView.backgroundColor = DEVIDE_LINE_COLOR;
    [footerView addSubview:lineView];
    
    // next step button
    self.confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, footerView.width - 20 * 2, kGeneralHeight)];
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.confirmButton.layer.cornerRadius = 5;
    self.confirmButton.layer.masksToBounds = YES;
    [self.confirmButton setTitle:locationString(@"next") forState:UIControlStateNormal];
    [self.confirmButton setDisenableBackgroundColor:kDisabledColor enableBackgroundColor:HexRGB(kMainColor)];
    [self.confirmButton addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:self.confirmButton];
    
    self.tableView.tableFooterView = footerView;
    self.footerView = footerView;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self showMarqueeView];
}

-(void)initViewModelBinding
{
    _viewModel = [[BoundBankCardModel alloc]init];
    _bankArray = [[NSMutableArray alloc]init];
    _desArray = [[NSMutableArray alloc]init];
}

/**
 *  请求银行卡列表
 */
-(void)loadData
{
    NSDictionary * dic = [[NSUserDefaults standardUserDefaults] valueForKey:kBankListAndBankIntroduction];
    if (dic) {
        [self handleResultWithDictionary:dic];
    } else {
        [LTNServerHelper retrieveBankListWithFinishBlock:^(id sender) {
            if (isDictionary(sender)) {
                [self handleResultWithDictionary:(NSDictionary *)sender];
            }
        }];
    }
}

// 处理银行列表数据
- (void)handleResultWithDictionary:(NSDictionary *)dic
{
    ESDispatchOnDefaultQueue(^{
        bankDicList = dic[@"list"];
        if(bankDicList&& isArray(bankDicList)){
            
            NSArray * bankList= [BankListModel mj_objectArrayWithKeyValuesArray:bankDicList];
            [_bankArray addObjectsFromArray:[BankListModel getBankNameList:bankList]];
            [_desArray addObjectsFromArray:[BankListModel getBankLimit:bankList]];
        }
        NSString *bankIntroduction=esString(dic[@"bankIntroduction"]);
        
        ESDispatchSyncOnMainThread(^{
            [self showBankIntroduction:bankIntroduction];
        });
    });
}

-(void)showBankIntroduction:(NSString *)bankIntroduction{

    LTNPromptView * promptView = [LTNPromptView promptWithIcon:@"icon_help_small" iconSpace:0 Text:bankIntroduction font:[UIFont systemFontOfSize:12.0] textWidth:self.confirmButton.width + 5];
    promptView.allowUserInteraction = YES;
    promptView.left = self.confirmButton.left;
    promptView.top = self.confirmButton.bottom + 10;
    [self.footerView addSubview:promptView];
}

-(void)showMarqueeView{
    
    NSString *msg = self.bankNotice;
    
    if(_marView){
        [_marView removeFromSuperview];
        _marView =nil;
    }
    
    
    if([msg length]>0){//显示
        _marView = [[SXMarquee alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kMarViewHeight) speed:4 Msg:msg bgColor:[UIColor colorWithRed:255.0/255 green:254.0/255 blue:223.0/255 alpha:1.0] txtColor:[UIColor colorWithHexString:@"#EA5504"]];
        [_marView changeMarqueeLabelFont:[UIFont systemFontOfSize:12]];
        [_marView start];
        self.tableView.tableHeaderView = _marView;
    }
    
    [self.tableView reloadData];
}

-(void)loadBankNotice{
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

-(void)initData{
    NSArray * array=@[
                     @{@"placeholder" : locationString(@"support_card_1"),
                       @"placeholderColor" : HexRGB(0x6a6a6a),
                       @"canEdit" : @(NO),
                       @"hideAccess" : @(NO),
                       @"sel" : @"selectBank:"
                       },
                     @{@"placeholder" : locationString(@"input_bankcard_id"),
                       @"placeholderColor" : HexRGB(0xadadad),
                       @"canEdit" : @(YES),
                       @"hideAccess" : @(YES),
                       @"sel" : @""
                       },
                    ];
    
    [self.data addObjectsFromArray:array];
}

- (void)customizeInit {
    [self dissmissWithBackButton];
    if (_isCompleteAction) {
        [LTNServerHelper retrieveAccountInfoWithFinishBlock:nil];
        [LTNServerHelper retrieveUserInfoWithFinishBlock:^{
            if([[CurrentUser mine].userInfo.bankAuthStatus isEqualToString:@"1"])
            {
                [self adjustUI];
            }
            [self completeBoundBank];
//                UIAlertView * alertVeiw = [[UIAlertView alloc]initWithTitle:@"恭喜您绑卡成功" message:@"现在就可以通过银行卡充值，开启财富增值之旅" delegate:self cancelButtonTitle:@"看看再说" otherButtonTitles:@"立即充值", nil];
//                [alertVeiw show];
        }];
        
    }
    if([[CurrentUser mine].userInfo.bankAuthStatus isEqualToString:@"1"])
    {
        [self adjustUI];
    }
}

#pragma mark 绑卡成功后的操作
- (void)completeBoundBank
{
    self.confirmButton.enabled = NO;
    [LTNUtilsHelper boxShowLoadWithMessage:locationString(@"wait_please")];
    NSMutableDictionary * dicM = [NSMutableDictionary dictionaryWithObject:@"BK" forKey:@"taskEndCondtion"];
    [BaseDataEngine apiForPath:kTaskCheck method:kGetMethod parameter:dicM responseModelClass:[TaskCheckModel class] onComplete:^(id response, id data, NSError *error) {
        [LTNUtilsHelper removeLoadMessageBox];
        // 服务器访问成功
        if (!error) {
            _taskCheck = (TaskCheckModel *)data;
            if ([_taskCheck.taskPrize.ID isEqualToString:@""]) {
                [self startNextTaskWithPrize:nil];
                return;
            }
            kWeakSelf
            _sheetWindows = [CustomAlertViews showAlertViewWithImage:@"icon_wancheng" title:locationString(@"task_success") detail:_taskCheck.taskPrize.prizeDesc closeButtonImage:@"icon_close2" sureButtonTitle:locationString(@"task_get_award") onViewController:self callBlock:^(MyWindowClicks buttonIndex) {
                // 关闭按钮
                if (buttonIndex == 1) {
                    _sheetWindows.hidden = YES;
                    _sheetWindows = nil;
                    [weakSelf dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                    if(weakSelf.navigationController.finishBlock)
                        weakSelf.navigationController.finishBlock();
                }
                // 领奖按钮
                if (buttonIndex == 0) {
                    //TODO: 根据返回的数据来确定跳转到哪个界面
                    [LTNUtilsHelper boxShowLoadWithMessage:locationString(@"wait_please")];
                    NSMutableDictionary * dicM = [NSMutableDictionary dictionaryWithObject:_taskCheck.taskPrize.ID forKey:@"taskId"];
                    [BaseDataEngine apiForPath:kTaskSubmitUrl method:kPostMethod parameter:dicM responseModelClass:[TaskCheckModel class] onComplete:^(id response, id data, NSError *error) {
                        [LTNUtilsHelper removeLoadMessageBox];
                        _sheetWindows.hidden = YES;
                        _sheetWindows = nil;
                        if (!error) {
                            _taskCheck = (TaskCheckModel *)data;
                            [weakSelf startNextTaskWithPrize:_taskCheck.taskPrize.prizeDesc];
                            [[NSNotificationCenter defaultCenter] postNotificationName:kNewHandTaskChanged object:nil];
                        } else {
                            [weakSelf startNextTaskWithPrize:nil];
                        }
                    }];
                }
            }];
        } else {
            // 服务器接口访问失败
            [self startNextTaskWithPrize:nil];
        }
    }];
}

#pragma mark 领取奖励并开始下一个任务
- (void)startNextTaskWithPrize:(NSString *)prizeDesc
{
    NSString * message = locationString(@"check_task_status");
    if (prizeDesc && ![prizeDesc isEqualToString:@""]) {
        message = [NSString stringWithFormat:@"%@", prizeDesc];
    }
    _sheetWindows = [CustomAlertView2 showAlertViewWithImage:@"icon_tanchu1" detail:message canleButtonTitle:@"icon_close1" okButtonTitle:locationString(@"task_new_region") onViewController:self callBlock:^(MyWindowClick2 buttonIndex) {
        _sheetWindows.hidden = YES;
        _sheetWindows = nil;
        // 取消
        if (buttonIndex == 1) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            if(self.navigationController.finishBlock)
                self.navigationController.finishBlock();
        }
        // 继续下一个任务
        if (buttonIndex == 0) {
            [[LTNCore globleCore] backToInvestmentListController];
        }
    }];
}

- (void)adjustUI {
    _selectBankField.text = [CurrentUser mine].userInfo.belongBank;
    _cardIdTextField.text = [StringUtil starsReplacedOfString:[CurrentUser mine].userInfo.bankNo withinRange:NSMakeRange(4,[CurrentUser mine].userInfo.bankNo.length-8)];
}

#pragma mark - Monitoring methods
- (void)selectBank:(BoundBankCell *)cell
{
    [_pickview remove];
    if(kScreenHeight == 480)
    {
        [UIView animateWithDuration:0. animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = -40;
            self.view.frame = frame;
        }];
        
    }
    _pickview = [[ZHPickView alloc] initPickviewWithArray:_bankArray isHaveNavControler:NO andDesArray:_desArray andTextField:cell.textField];
    _pickview.delegate=self;
    [_pickview show];
}

/**
 *  绑卡成功
 *
 *  @param sender <#sender description#>
 */
- (void)confirmClick:(UIButton *)sender {
    [TrackingUtility event:kBKClicked];
    [self.view endEditing:YES];
    
    [self showWaitingIcon];
    __weak typeof(self) weakself = self;
    NSString *textString = [self.cardIdTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    sender.enabled = NO;
    [_viewModel GET_BindBankCardWithCardId:textString andBelongBank:_selectBankField.text success:^(BOOL success) {
        [weakself dismissWaitingIcon];
        sender.enabled = YES;
        CustomizedBackWebViewController * baseWebViewController = [[CustomizedBackWebViewController alloc]initWithURL:_viewModel.bindBankCardModel.url];
        [weakself.navigationController pushViewController:baseWebViewController animated:YES];
    } failure:^(NSString *error) {
        [weakself dismissWaitingIcon];
        sender.enabled = YES;
        [LTNUtilsHelper boxShowWithMessage:error];
    }];
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [_pickview remove];
    if (textField == _cardIdTextField) {
        return YES;
    }
    return NO;
}

/**
 * 限制银行卡号位数（每四位后空格）
 */
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.cardIdTextField) {
        if (![string length]) {
            return YES;
        }

        NSString *text = textField.text;
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];

        text = [text stringByReplacingCharactersInRange:range withString:string];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];

        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }

        if (newString.length >= 24) {
            return NO;
        }
        NSInteger adjustLen = 1;
        NSInteger pos = range.location;
        NSInteger subPos = pos % (4 + 1);
        if (subPos == 4) {
            adjustLen = 2;
        }
        [textField setText:newString];

        [Utility selectTextForInput:textField atRange:NSMakeRange(range.location + adjustLen, 0)];
    }

    return NO;
}

#pragma mark - alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        RechargeViewController *rechargeViewController = [[RechargeViewController alloc]init];
        [self.navigationController pushViewController:rechargeViewController animated:YES];
    }else{
        [self back];
    }
}

#pragma mark - ZHPickView delegate
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    _selectBankField.text = resultString;
    
    for (NSString * bankName in _bankArray) {
        if ([bankName isEqualToString:resultString]) {
            NSInteger index = [_bankArray indexOfObject:bankName];
            
            NSString * bankMessage = bankDicList[index][@"bankMessage"];
            if (bankMessage && ![bankMessage isEqualToString:@""]) {
                _bankMessageLabel.text = bankDicList[index][@"bankMessage"];
                _bankMessageView.hidden = NO;
            } else {
                _bankMessageView.hidden = YES;
            }
            _selectBankField.text = resultString;
            break;
        }
    }
}

// 用于解决4s上UI的bug
-(void)changeViewFrame
{
    if(kScreenHeight == 480)
        [UIView animateWithDuration:0. animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = 64.0;
            self.view.frame =frame;
        }];
}

#pragma mark - tableView dataSource
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
    static NSString * CellIdentifier = @"BoundBankCell";
    BoundBankCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[BoundBankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [CustomerizedFont heiti:14];
    }
    
    cell.cellDic = self.data[indexPath.row];
    if (indexPath.row == 0) {
        _selectBankField = cell.textField;
    } else if (indexPath.row == 1) {
        _cardIdTextField = cell.textField;
        _cardIdTextField.delegate = self;
    }
    
    return cell;
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kBoundBankCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kHeaderOfSectionHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerViewOfSection;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = self.data[indexPath.row];
    NSString * selName = dic[@"sel"];
    SEL action = NSSelectorFromString(selName);
    if ([self respondsToSelector:action]) {
        [self performSelector:action withObject:[tableView cellForRowAtIndexPath:indexPath] afterDelay:0];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - getter methods
- (UIView *)headerViewOfSection
{
    if (!_headerViewOfSection) {
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 58)];
        headerView.backgroundColor = BACKGROUND_COLOR;
        
        // 持卡人
        self.cardholderLabel = [Utility createLabel:[CustomerizedFont heiti:14] color:HexRGB(0x6a6a6a)];
        [headerView addSubview:self.cardholderLabel];
        self.cardholderLabel.text = [NSString stringWithFormat:locationString(@"card_self_name"), [StringUtil starsReplacedOfString:[CurrentUser mine].userInfo.userName withinRange:NSMakeRange(1, 1)]];
        [self.cardholderLabel sizeToFit];
        self.cardholderLabel.left = 22;
        self.cardholderLabel.centerY = headerView.height * 0.5;
        
        // 银行信息提示
        UIView * bankMessageView = [[UIView alloc] initWithFrame:CGRectMake(0, self.cardholderLabel.bottom, headerView.width, headerView.height - self.cardholderLabel.bottom)];
        bankMessageView.hidden = YES;
        [headerView addSubview:bankMessageView];
        self.bankMessageView = bankMessageView;
        
        // icon
        UIImageView * icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tishi3"]];
        icon.centerY = bankMessageView.height * 0.5;
        icon.left = self.cardholderLabel.left;
        [bankMessageView addSubview:icon];
        
        // label
        self.bankMessageLabel = [Utility createLabel:[CustomerizedFont heiti:11] color:HexRGB(0xf35833)];
        [bankMessageView addSubview:self.bankMessageLabel];
        [self.bankMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(icon.mas_right);
            make.centerY.equalTo(icon.mas_centerY);
        }];
        
        for (int i = 0; i < 2; i++) {
            UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, i * (headerView.height - 1.0 / [UIScreen mainScreen].scale), kScreenWidth, 1.0 / [UIScreen mainScreen].scale)];
            lineView.backgroundColor = DEVIDE_LINE_COLOR;
            [headerView addSubview:lineView];
        }
        _headerViewOfSection = headerView;
    }
    return _headerViewOfSection;
}

@end
