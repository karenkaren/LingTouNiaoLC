//
//  VerifyRealNameViewController.m
//  lingtouniao
//
//  Created by 徐凯 on 15/12/23.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "VerifyRealNameViewController.h"
#import "LoginPaddingUITextField.h"
#import "VerifyRealNameViewModel.h"
#import "TableViewDevider.h"
#import "CheckBox.h"
#import "FondTrustModel.h"
#import "LTNServerConstant.h"
#import "BoundBankCardViewController.h"
#import "BaseWebViewController.h"
#import "GesturePasswordController.h"
#import "CustomizedBackWebViewController.h"
#import "CustomAlertViews.h"
#import "CustomAlertView2.h"
#import "TaskCheckModel.h"

#define kTimeLength 60
static int timeCount = kTimeLength;

@interface VerifyRealNameViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    UITableView * _tableView;
    UITextField * _txtNameField;
    UITextField * _txtIdField;
    VerifyRealNameViewModel *_viewModel;
    UIView * _sheetWindows ;
    TaskCheckModel * _taskCheck;
}
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet CheckBox *submitBox;
@property (weak, nonatomic) IBOutlet UIButton *manageDelegateButton;//资金管理协议
@property (weak, nonatomic) IBOutlet UILabel *des1Label;//我已阅读并同意
@property (weak, nonatomic) IBOutlet UIButton *submitButton;//确认按钮
@property (nonatomic, strong) NSTimer * timer;//倒计时计时器

@end

@implementation VerifyRealNameViewController


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self stopTimer];
}

+(instancetype)verifyRealNameControllerWithFinishBlock:(VoidBlock)finishVerifyRealNameBlock{
    VerifyRealNameViewController *controller= [[VerifyRealNameViewController alloc] init];
    controller.finishVerifyRealNameBlock=finishVerifyRealNameBlock;
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _des1Label.text = locationString(@"read_agreement");
    [_manageDelegateButton setTitle:locationString(@"current_account_title4") forState:UIControlStateNormal];
    
    [_submitButton setDisenableBackgroundColor:HexRGB(0xcccccc) enableBackgroundColor:HexRGB(0xea5504)];
    _submitButton.layer.cornerRadius = 5;
    _submitButton.layer.masksToBounds = YES;
    [_submitButton setTitle:locationString(@"immediately_opened_2") forState:UIControlStateNormal];
}

-(void)initViewModelBinding
{
    _viewModel = [[VerifyRealNameViewModel alloc]init];
}

-(void)initUIView
{
    self.navigationItem.title = locationString(@"fund_account");
     _submitBox.isSelected = YES;
    [_submitBox addObserver:self forKeyPath:@"isSelected" options: NSKeyValueObservingOptionNew |
    NSKeyValueObservingOptionOld
     context:NULL];
    
    [self setUpField];
    [self setUpTableView];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    if(self.navigationController.finishBlock)
        self.navigationController.finishBlock();
    
    [super back];
}

-(void)setUpField
{
    
    _txtNameField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth / 2 * 1.4, kGeneralHeight)];
    _txtNameField.delegate=self;
    _txtNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _txtNameField.autocorrectionType = UITextAutocorrectionTypeNo;
    _txtNameField.placeholder = locationString(@"input_your_name");
    
    _txtIdField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth / 2 * 1.4, kGeneralHeight)];
    _txtIdField.placeholder = locationString(@"load_details_idcard_hint");
    _txtIdField.keyboardType = UIKeyboardTypeASCIICapable;
    _txtIdField.autocorrectionType = UITextAutocorrectionTypeNo;
    _txtIdField.delegate = self;
}


-(void)setUpTableView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.backgroundColor = BACKGROUND_COLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.separatorColor = HexRGB(0xe2e2e2);
    [self.view addSubview:_tableView];
    
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    if (_viewModel.certification) {
    _tableView.tableFooterView = [[UIView alloc]init];
    }
    else{
     _tableView.tableFooterView = _footerView;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self dissmissWithBackButton];
    if ([_viewModel.certification isEqualToString:@"1"])
    {
        _tableView.tableFooterView = [[UIView alloc]init];
        _txtNameField.userInteractionEnabled = NO;
        _txtIdField.userInteractionEnabled = NO;
        NSString * userName = self.isCompleteAction ? _txtNameField.text : _viewModel.userName;
        _txtNameField.text =  [StringUtil starsReplacedOfString:userName withinRange:NSMakeRange(1, 1)] ;
        NSString * cardId = self.isCompleteAction ? _txtIdField.text : _viewModel.cardId;
        _txtIdField.text = [StringUtil starsReplacedOfString:cardId withinRange:NSMakeRange(3,12)];
        if (self.isCompleteAction) {
            self.isCompleteAction = NO;
            [self completeVerifyRealName];
        }
    }
    else{
       _tableView.tableFooterView = _footerView;
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970] * 1000;
        // 倒计时不到1分钟，需要重新开启计时
        NSTimeInterval startTime = [[NSUserDefaults standardUserDefaults] doubleForKey:@"verifyRealNameStart"];
        if (startTime && now - startTime < kTimeLength * 1000) {
            timeCount = ceil((kTimeLength * 1000 - (now - startTime)) / 1000);
            [self startTimer];
        } else {
            [[NSUserDefaults standardUserDefaults] setDouble:0 forKey:@"verifyRealNameStart"];
        }
    }
}

#pragma mark 实名成功后的操作
- (void)completeVerifyRealName
{
    [LTNUtilsHelper boxShowLoadWithMessage:locationString(@"wait_please")];
    NSMutableDictionary * dicM = [NSMutableDictionary dictionaryWithObject:@"SM" forKey:@"taskEndCondtion"];
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
                            [weakSelf startNextTaskWithPrize:_taskCheck.taskPrize. prizeDesc];
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
    //            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"开通成功！" message:@"您已成功开通资金托管账户！绑定银行卡后将获得一张20元返现券，马上就去绑定银行卡开始投资吧！" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:@"马上绑卡", nil];
    //            [alertView show];
}

#pragma mark 领取奖励并开始下一个任务
- (void)startNextTaskWithPrize:(NSString *)prizeDesc
{
    NSString * message = locationString(@"check_task_status");
    if (prizeDesc && ![prizeDesc isEqualToString:@""]) {
        message = [NSString stringWithFormat:@"%@", prizeDesc];
    }
    _sheetWindows = [CustomAlertView2 showAlertViewWithImage:@"icon_tanchu1" detail:message canleButtonTitle:@"icon_close1" okButtonTitle:locationString(@"next_task") onViewController:self callBlock:^(MyWindowClick2 buttonIndex) {
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
            BoundBankCardViewController *boundBankCardViewController = [[BoundBankCardViewController alloc]init];
            if(_finishVerifyRealNameBlock){
                boundBankCardViewController.finishBlock=_finishVerifyRealNameBlock;
            }
            [self.navigationController pushViewController:boundBankCardViewController animated:YES];
        }
    }];
}

/**
 *  确认点击
 *
 *  @param sender <#sender description#>
 */
- (IBAction)submitClick:(id)sender {
  
    [self.view endEditing:YES];
    NSString *nameString = [_txtNameField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (nameString.length == 0) {
        [LTNUtilsHelper boxShowWithMessage:locationString(@"write_name")];
        return;
    }
    
    if(![StringUtil validateName:_txtNameField.text]) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:nil message:locationString(@"input_hanzi") delegate:nil cancelButtonTitle:nil otherButtonTitles:locationString(@"btn_confirm"), nil];
        [alertView show];
        [_txtNameField becomeFirstResponder];
        return;
    }
    
    if (_txtIdField.text.length == 0) {
        [LTNUtilsHelper boxShowWithMessage:locationString(@"write_identy")];
        return;
    }
    
    if (![_txtIdField isValidateIDCardNumber]) {
        [LTNUtilsHelper boxShowWithMessage:locationString(@"write_error_identy")];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:nameString forKey:@"userName"];
    [dict setValue:_txtIdField.text forKey:@"identityCode"];
    // 开始倒计时60s
    [self startTimer];
//    MBProgressHUD * progressHUD = [MBProgressHUD bwm_showHUDAddedToController:self title:nil animated:YES];
    kWeakSelf
    [self apiForPath:kUserAuthUrl method:kPostMethod parameter:dict responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
//        [progressHUD hide:YES];
        if (error) {
            
            //实名失败
            NSArray *piwikArr=@[
                                @[@"user_id",esString([CurrentUser mine].userInfo.mobile)],
                                @[@"result",@"0"],
                                @[@"reason",esString(error.description)]
                                ];
            
            piwikEvent(@"auth_name",piwikArr);
            
            return;
        }
        CustomizedBackWebViewController * webViewController = [[CustomizedBackWebViewController alloc]initWithURL:data[@"url"]];
        [weakSelf.navigationController pushViewController:webViewController animated:YES];
    }];

}

/**
 *  资金管理协议
 *
 */
- (IBAction)delegatebutton:(id)sender {
    
    BaseWebViewController *baseWebViewController = [[BaseWebViewController alloc] initWithURL:kH5Accept_IDUrl];
    [self.navigationController pushViewController:baseWebViewController animated:YES];
}

#pragma atableView代理方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
            return 2;
            break;
        default:
            return 0;
            break;
           
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = [NSString stringWithFormat:@"section%ld",indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#8a8a8a"];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = locationString(@"load_details_realname_tv");
            cell.accessoryView = _txtNameField;
        }
        else if (indexPath.row == 1)
        {
            cell.textLabel.text = locationString(@"load_details_idcard_tv");
            cell.accessoryView = _txtIdField;
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32.5f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, kScreenWidth, 32.5);
    view.backgroundColor = COLORWITHRGB(247, 247, 247);
    UILabel *lblTitle = [[UILabel alloc] init];
    [view addSubview:lblTitle];
    lblTitle.frame = view.frame;
    lblTitle.font = [UIFont systemFontOfSize:12];
    lblTitle.textColor = [UIColor colorWithHexString:@"#8a8a8a"];
    lblTitle.text = locationString(@"user_auth_tip");
    lblTitle.textAlignment = NSTextAlignmentCenter;
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, view.height - 0.5, kScreenWidth, 0.5)];
    lineView.backgroundColor = HexRGB(0xe2e2e2);
    [view addSubview:lineView];
    return view;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


//#pragma KVO 响应
///**
// *  监听Checkbox的选中状态
// */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isSelected"]) {
        if (_submitBox.isSelected) {
            _submitButton.enabled = YES;
            if (timeCount > 0 && timeCount < kTimeLength) {
                _submitButton.enabled = NO;
            }
        }
        else {
            _submitButton.enabled = NO;
        }
    }
}



/**
 *   移除对checkbox的状态的监听
 */
- (void)dealloc {
    [_submitBox removeObserver:self forKeyPath:@"isSelected"];
}
#pragma - mark 输入框限制

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _txtIdField)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:IDCARDONLY] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered]) && (newLength <= IDENTITY_LIMIT));
    }
    return true;
}

#pragma alertView的代理方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if(buttonIndex == 1)
        {
            BoundBankCardViewController *boundBankCardViewController = [[BoundBankCardViewController alloc]init];
            if(_finishVerifyRealNameBlock){
                
                boundBankCardViewController.finishBlock=_finishVerifyRealNameBlock;
                
                //            [self dismissViewControllerAnimated:YES completion:^{
                //
                //            }];
            }

            [self.navigationController pushViewController:boundBankCardViewController animated:YES];
        }
       else if (buttonIndex == 0)
       {
           //TODO:实名认证成功 ,如果有回调，需要调用回调继续业务
           [self dismissViewControllerAnimated:YES completion:^{
               
           }];
           if(self.navigationController.finishBlock)
               self.navigationController.finishBlock();
           
//           if(_finishVerifyRealNameBlock){
//               
//               _finishVerifyRealNameBlock();
//               //            [self dismissViewControllerAnimated:YES completion:^{
//               //
//               //            }];
//           }

       }

}

#pragma mark 发送验证码时间相关
- (void)startTimer
{
    self.submitButton.enabled = NO;
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970] * 1000;
    NSTimeInterval startTime = [[NSUserDefaults standardUserDefaults] doubleForKey:@"verifyRealNameStart"];
    if (now - startTime >= kTimeLength * 1000) {
        [[NSUserDefaults standardUserDefaults] setDouble:[[NSDate date] timeIntervalSince1970] * 1000 forKey:@"verifyRealNameStart"];
    }
    
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(upateTime) userInfo:nil repeats:YES];
    }
    [self.timer fire];
}

- (void)stopTimer
{
    if(self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if(_submitButton){
        _submitButton.enabled = YES;
        [_submitButton setTitle:locationString(@"immediately_opened_2") forState:UIControlStateNormal];
        [_submitButton setTitle:locationString(@"immediately_opened_2") forState:UIControlStateDisabled];
        timeCount = kTimeLength;
    }
}
- (void)upateTime
{
    NSString * timeString = [NSString stringWithFormat:locationString(@"abnew_submmit"), timeCount--];
    [_submitButton setTitle:timeString forState:UIControlStateDisabled];
    if (timeCount == 0) {
        [self stopTimer];
    }
}

@end
