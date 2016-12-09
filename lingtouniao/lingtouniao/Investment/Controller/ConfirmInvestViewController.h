//
//  ConfirmInvestViewController.h
//  lingtouniao
//
//  Created by 徐凯 on 15/12/17.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "BaseViewController.h"
#import "PayButtonView.h"
#import "SubmitOrderModel.h"
#import "TableViewDevider.h"
#import "CustomizedBackWebViewController.h"
#import "CouponTableViewCell.h"

#define kUserProductId            @"kUserProductId"
#define kUserProductExpireDate    @"kUserProductExpireDate"
#define kUserInvestAmount         @"kUserInvestAmount"
#define kUserWaitProfit           @"kUserWaitProfit"
#define kUserBirdCoin             @"kUserBirdCoin"
#define kUserCouponDes            @"kUserCouponDes"
#define kUserRealPayAmout         @"kUserRealPayAmout"

@interface ConfirmInvestViewController : BaseViewController
{
    UITableView *_tableView;
    BOOL _selectFirstItem;
    BOOL _selectSecondItem;
    UIView *_footerView;//底部视图
    PayButtonView *_payButtonView;
    SubmitOrderModel *_submitOrderModel;
    double _coin;//鸟币
    NSInteger _index;//理财金券默认数组第一个数值
    NSInteger _otherCouponIdSelectedIndex;//理财金券选择cell
    long userCouponId;
    NSString *couponDes;
}
@property(nonatomic,assign)NSInteger productId;//产品的id
@property(nonatomic,copy)NSString * investAmount;//购买金额
@property (nonatomic, assign) BOOL isPurchaseOnce;//一次性全投
@property (nonatomic,assign)  BOOL isSwitch;//是否开着
@property (nonatomic, strong) UITableView * tableView;
@property (weak, nonatomic) IBOutlet UILabel *current_account_title2Label;

@property (weak, nonatomic) IBOutlet UIButton *invest_agreement_Button;
@property (nonatomic) double realPayAmout;

/**
 *  是否使用鸟币按钮
 */
- (void)updateSwitchAtIndexPath:(id)sender;
/**
 *
 *  @return 传到确认投资界面的最终字符串的样子
 */
- (NSString *)getWaitProfit;
/**
 *  构建cell
 */
- (UITableViewCell *)buildCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
/**
 *
 *  @return 收益应该有多少
 */
- (double)revenueAndAdditional;

@end
