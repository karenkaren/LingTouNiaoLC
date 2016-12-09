//
//  LTNProductDetailController.m
//  lingtouniao
//
//  Created by LiuFeifei on 15/12/11.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNProductDetailController.h"
#import "LTNProductDetailCell.h"
#import "ConfirmInvestViewController.h"
#import "LTNLoginController.h"
#import "LTNRegisterController.h"
#import "BaseWebViewController.h"
#import "LTNPurchaseRecordController.h"
#import "HandeUrlUtil.h"
#import "VerifyRealNameViewController.h"
#import "BoundBankCardViewController.h"
#import "PopupView.h"
#import "ProductDetailFooterView.h"

@interface LTNProductDetailController ()<UITextFieldDelegate, ProductDetailFooterViewDelegate>

@property (nonatomic, strong) UIButton * closeButton;
@property (nonatomic, strong) UIImageView * navBarHairlineImageView;
@property (nonatomic, strong) NSArray * productDetails;
@property (nonatomic, strong) ProductDetailFooterView * footerView;
@property (nonatomic, strong) UILabel * accountLabel;
@property (nonatomic, assign) double startAmount;
@property (nonatomic, strong) PopupView * popupView;
@property (nonatomic, assign) double purchaseOnceAmount;
@property (nonatomic, assign) FooterType footerType;

@end

@implementation LTNProductDetailController

-(NSMutableArray *)coupounArray{
    if(!_coupounArray)
        _coupounArray=[NSMutableArray array];
    return _coupounArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //去除导航栏下方的横线
    if ([self.product.productType isEqualToString:@"TYB"]) {
        self.navBarHairlineImageView.hidden = YES;
        UIImage *image = [Utility createImageFromColor:kRGBColor(62, 150, 250) withSize:CGSizeMake(1, 1)];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    
    // 键盘管理
    [[IQKeyboardManager sharedManager] setEnable:YES];
    if (self.product) {
        self.footerView.hidden = NO;
    }
    // 刷新账户信息
    //    [self refreshFooterView];
    // 获取账户信息
    if ([[CurrentUser mine] sessionKey] && ![[[CurrentUser mine] sessionKey] isEqualToString:@""]) {
        [self getAccountInfo];
    }
    
    //TODO:是否有判断单人最多投资额的情况
    [self pullReload];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    self.navBarHairlineImageView.hidden = NO;
    UIImage *image = [Utility createImageFromColor:[UIColor whiteColor] withSize:CGSizeMake(1, 1)];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];

    // 取消键盘管理
    [[IQKeyboardManager sharedManager] setEnable:NO];
    self.footerView.hidden = YES;
}

- (void)viewDidLoad {
    
    self.isTableViewStyleGrouped = YES;
    [super viewDidLoad];
    self.tableView.top -= 11;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = DEVIDE_LINE_COLOR;
    self.title = locationString(@"product_detail_title");
    
    
    UIImage * image = [UIImage imageNamed:@"nav_return"];
    if ([self.product.productType isEqualToString:@"TYB"]) {
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        self.navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
        self.navigationController.navigationBar.translucent = NO;
        self.tableView.backgroundColor = HexRGB(0xf9f9f9);
        image = [UIImage imageNamed:@"nav_return_white"];
    }
    
    // navigationBar left button
    UIButton * closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, kGeneralHeight)];
    [closeButton setImage:image forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.closeButton = closeButton;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    
    // 添加tableview footerView
    [self addFooterView];
    
    self.productDetails = @[@{@"title" : locationString(@"product_details_detail"),
                              @"sel" : @"showProductDetail"},
                            @{@"title" : locationString(@"product_details_record"),
                              @"sel" : @"showPurchaseRecord"}];
    if (!self.product) {
        self.tableView.hidden = YES;
        self.footerView.hidden = YES;
    }
}

- (void)getServiceData:(BOOL)isGetMore
{
    [super getServiceData:isGetMore];
    
    NSInteger productId = self.product ? self.product.productId : self.productId;
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:@{@"id" : @(productId)}];
    kWeakSelf
    [self apiForPath:kProductsDetailUrl method:kGetMethod parameter:dic responseModelClass:[LTNProduct class] onComplete:^(id response, id data, NSError *error) {
        if (!error) {
            self.tableView.hidden = NO;
            self.footerView.hidden = NO;
            LTNProduct * product = (LTNProduct *)data;
            [weakSelf.data addObject:product];
            self.product = product;
            [self.tableView reloadData];
            [self refreshFooterView];
            [self showPopupView];
            if (product.productRemainAmount == 0) {
                [self.footerView removeFromSuperview];
            }
        }
        if (self.product) {
            [weakSelf.data removeAllObjects];
            [weakSelf.data addObject:self.product];
        }
    }];
}

- (void)showPopupView
{
    if ([self.product.productType isEqualToString:@"TYB"] || [self.product.productType isEqualToString:@"XSB"]) {
        return;
    }
    if ([[CurrentUser mine] hasLogged] && !self.popupView){
        NSDictionary * attributes = @{NSFontAttributeName : kFont(12), NSForegroundColorAttributeName : HexRGB(0x3a3a3a)};
        if ([self.product.lastBuyer isEqualToString:@""] && self.product.productRemainAmount == self.product.productTotalAmount) {
            // 首单
            self.popupView = [[PopupView alloc] initWithPrompt:locationString(@"product_detail_dialog1") attributes:attributes inView:self.view fromRect:self.footerView.frame];
        } else if (self.product.productRemainAmount && self.product.productRemainAmount <= 10 * self.product.staInvestAmount) {
            // 尾单
            self.popupView = [[PopupView alloc] initWithPrompt:locationString(@"product_detail_dialog2") attributes:attributes inView:self.view fromRect:self.footerView.frame];
        }
    }
}

#pragma mark 查找navigationbar底部线条
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

#pragma mark 返回
- (void)back
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(needsRefreshWithProduct:)]) {
        [self.delegate needsRefreshWithProduct:self.product];
    }
    [self.navigationController popViewControllerAnimated:YES];
    [self.footerView removeFromSuperview];
}

- (void)addFooterView
{
    [self refreshFooterType];
    self.footerView = [[ProductDetailFooterView alloc] initWithType:self.footerType delegate:self];
    self.tableView.height = self.view.height - self.footerView.height + 11;
    [self.view addSubview:self.footerView];
}

- (void)refreshFooterType
{
    if (![[CurrentUser mine] hasLogged]) {
        self.footerType = FooterTypeOfLogin;
    } else {
        // 还款中，已结标
        BOOL repaymenting = self.product.productStatus >= 2 && ![self.product.productType isEqualToString:@"TYB"];
        if (repaymenting) {
            self.footerType = FooterTypeOfUnknow;
        } else if ([self.product.productType isEqualToString:@"TYB"]) {
            self.footerType = FooterTypeOfTYB;
        } else if ([self.product.productType isEqualToString:@"XSB"]) {
            self.footerType = FooterTypeOfXSB;
        } else {
            self.footerType = FooterTypeOfNormal;
        }
    }
}

#pragma mark 根据登录及标的状态更新底部视图
- (void)refreshFooterView
{
    [self refreshFooterType];
    [self.footerView refreshWithFooterType:self.footerType];
    
    self.startAmount = [self.product startAmount];
    NSString * placeholder = nil;
    
    //新手标 投资期限小于10天，剩余金额大于100
    // todo:新手标是否可能为浮动标？
    if (self.footerType == FooterTypeOfXSB && self.product.productDeadline <= 10 && self.product.productRemainAmount > 100) {
        
            //剩余金额小于10000，，100到剩余金额   否则100到10000
        
        placeholder = self.product.productRemainAmount < 10000 ? [NSString stringWithFormat:locationString(@"product_detail_hint"), @(self.startAmount), @(self.product.productRemainAmount)] : [NSString stringWithFormat:locationString(@"product_detail_hint1"), @(self.startAmount)];
        
        
    } else {
        placeholder = [NSString stringWithFormat:locationString(@"product_start_amount"), @(self.startAmount)];
    }
    self.footerView.amountTextField.placeholder = placeholder;
}

#pragma mark footer view delegate
#pragma mark 购买产品
- (void)purchseProduct:(UIButton *)button
{
    [self.view endEditing:YES];
    
    double purchaseAmount = [self.footerView.amountTextField.text doubleValue];
    
    
    //判断起投金额
    if(purchaseAmount <= self.startAmount - 0.001){
        NSString * text = [NSString stringWithFormat:locationString(@"product_detail_toast6"), self.startAmount];
        [LTNUtilsHelper boxShowWithMessage:text];
        return;
    }
    

    
    //新手标上限 10000
    if ([self.product.productType isEqualToString:@"XSB"] && self.product.productDeadline <= 10) {
        if (purchaseAmount > 10000) {
            [LTNUtilsHelper boxShowWithMessage:locationString(@"amount_upper_limit_error")];
            return;
        }
    }
    
    //        if (![self.footerView.amountTextField validDecimal]) {
    //            [LTNUtilsHelper boxShowWithMessage:locationString(@"amount_digits_error")];
    //            return;
    //        }
    
    // 购买金额需要小于剩余金额
    if (purchaseAmount > self.product.productRemainAmount) {
        [LTNUtilsHelper boxShowWithMessage:locationString(@"product_detail_toast5")];
        return;
    }
    
    // 倍投 ?????
    if (self.product.multipleTequire > 0) {
        // 有起投倍数限制
        NSInteger amount = purchaseAmount * 100 - self.startAmount * 100;
        NSInteger multipleTequire = self.product.multipleTequire * 100;
        if (amount % multipleTequire != 0) {
            [LTNUtilsHelper boxShowWithMessage:[NSString stringWithFormat:locationString(@"amount_multiple_tequire_error"), self.product.multipleTequire]];
            return;
        }
    }
    
    if([self.product hasSingleLimitAmount]){
        if(purchaseAmount>self.product.singleLimitAmount) {
            [LTNUtilsHelper boxShowWithMessage:locationString(@"outnumber_single_limit_amount")];
            return;
        }
    }
    
    if([self.product hasTotalLimitAmount]){
        if(purchaseAmount>self.product.lastAmount) {
            [LTNUtilsHelper boxShowWithMessage:locationString(@"outnumber_total_limit_amount")];
            return;
        }
    }

    
    
    
    ConfirmInvestViewController *confirmInvestViewController = [[ConfirmInvestViewController alloc]init];
    confirmInvestViewController.hidesBottomBarWhenPushed = YES;
    confirmInvestViewController.productId = self.product.productId;
    confirmInvestViewController.useBirdCoinTag = self.product.useBirdCoinTag;
    confirmInvestViewController.useCouponTag=self.product.useCouponTag;
//    confirmInvestViewController.investAmount = [self.product.productType isEqualToString:@"TYB"] ? @"0" : [NSString stringWithFormat:@"%.2f", [self.footerView.amountTextField.text doubleValue]];
    
    double investAmount = [self.product.productType isEqualToString:@"TYB"] ? self.product.productTotalAmount : [self.footerView.amountTextField.text doubleValue];
    
    confirmInvestViewController.investAmount = [NSString stringWithFormat:@"%.2f", investAmount];
    
    if ([self.footerView.amountTextField.text doubleValue] == self.purchaseOnceAmount) {
        // 如果是一次性全投
        confirmInvestViewController.isPurchaseOnce = YES;
    }
    
    confirmInvestViewController.coupounsBefore = self.coupounArray;
    
//    ESWeakSelf
//    confirmInvestViewController.addCoupounBlock=^(id sender){
//        ESStrongSelf
//        if(_self){
//            [_self.coupounArray addObject:sender];
//        }
//    };
    [self.navigationController pushViewController:confirmInvestViewController animated:YES];
}

#pragma mark 一次性全投
- (void)purchaseOnce:(UIButton *)button
{
    double purchaseOnceAmount = [self.product getOnceMaxAccount];
    self.footerView.amountTextField.text = [NSString stringWithFormat:@"%.f", purchaseOnceAmount];
    self.purchaseOnceAmount = purchaseOnceAmount;
}

#pragma mark 点击登陆、注册
- (void)enterPlatformWithFooterEnterType:(FooterEnterType)footerEnterType
{
    switch (footerEnterType) {
        case FooterEnterTypeOfLogin:
            [self userLogin];
            break;
        case FooterEnterTypeOfRegister:
            [self userRegister];
            break;
        default:
            break;
    }
}

#pragma mark 用户登陆
- (void)userLogin
{
    DLog(@"login");
    [[LTNCore globleCore] loginController:^(void){
        //        [self.navigationController popViewControllerAnimated:NO];
        [self refreshFooterView];
    }];
}

#pragma mark 用户注册
- (void)userRegister
{
    DLog(@"register");
    [[LTNCore globleCore] registerController:^(void){
        [self refreshFooterView];
    }];
}

#pragma mark 更新账户信息
- (void)getAccountInfo
{
    [LTNServerHelper getAccountInfoSuccess:^(id response) {
        DLog(@"%@", response);
        [CurrentUser setAccountInfoWithDic:response];
        [self refreshFooterView];
    } failure:^(NSError *error) {
        DLog(@"%@", error.localizedDescription);
    }];
}

#pragma mark - tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.product.productType isEqualToString:@"TYB"] ? 1 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section ? 2 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        LTNProductDetailCell * cell = [[LTNProductDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.product = self.product;
        return cell;
    } else {
        static NSString * CellIdentifier = @"ProduceDetailCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textColor = HexRGB(0x3a3a3a);
            cell.textLabel.font = kFont(16);
            cell.detailTextLabel.textColor = HexRGB(0x8a8a8a);
            cell.detailTextLabel.font = kFont(14);
        }
        cell.textLabel.text = self.productDetails[indexPath.row][@"title"];
        if (indexPath.row && self.product && ![self.product.lastBuyer isEqualToString:@""]) {
            cell.detailTextLabel.text = [NSString stringWithFormat:locationString(@"product_last_buyer"), self.product.lastBuyer];
        }
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = [NSString stringWithFormat:locationString(@"product_raise_end_date"), [self.product.raiseEndDate componentsSeparatedByString:@" "].firstObject];
        }
        return cell;
    }
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return;
    }
    NSDictionary * dic = self.productDetails[indexPath.row];
    NSString * selName = dic[@"sel"];
    SEL action = NSSelectorFromString(selName);
    if([self respondsToSelector:action])
        [self performSelector:action withObject:nil afterDelay:0.0f];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return indexPath.section ? kGeneralHeight : ([self.product.productType isEqualToString:@"TYB"] ? kProductDetailVirtualHeight : kProductDetailCellHeight);
    
    if(indexPath.section==0){
        if([self.product.productType isEqualToString:@"TYB"]){
            return kProductDetailVirtualHeight;
        }else{
            if(self.product){
                if([self.product hasTotalLimitAmount]||[self.product hasSingleLimitAmount]){
                    return kProductDetailCellHeight+kGeneralHeight+0.5; //0.5分割线高度
                }else{
                    return kProductDetailCellHeight;
                }
            }
        }
    }
    return kGeneralHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    headerView.backgroundColor = BACKGROUND_COLOR;
    return headerView;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark 项目详情
- (void)showProductDetail
{
    [HandeUrlUtil receiveOpenUrlString:self.product.detailsUrl fromNavViewController:self.navigationController andHaveNav:YES andHaveBtn:NO andShareName:nil andShareIcon:nil andShareUrl:nil andShareContent:nil];
}

#pragma mark 购买记录
- (void)showPurchaseRecord
{
    LTNPurchaseRecordController * recordController = [[LTNPurchaseRecordController alloc] init];
    recordController.productId = self.product.productId;
    [self.navigationController pushViewController:recordController animated:YES];
}

@end
