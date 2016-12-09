//
//  InvestSummaryViewController.h
//  lingtouniao
//
//  Created by 徐凯 on 16/2/22.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "BaseViewController.h"

@interface InvestSummaryViewController : BaseViewController

{
    NSArray *_titleArray;
    UITableView *_tableView;
    UIButton *_confirmButton;//确认
    UIView *_footView;
    NSInteger _productId;//产品id
    NSString *_productExpireDate;//产品到期时间
    float _investAmount;//投资金额
    NSString *_waitProfit;//待收收益
    double _birdCoin;//鸟币
    NSString *_couponDes;//优惠券描述
    double _realPayAmout;//实付金额
    long _userCouponId;
}

-(id)initOrderDataProductId:(NSInteger)productId ProductExpireDate:(NSString *)productExpireDate InvestAmount:(float)investAmount waitProfit:(NSString *)waitProfit birdCoin:(double)birdCoin couponDes:(NSString *)couponDes realPayAmout:(double)realPayAmout userCouponId:(long)userCouponId;
- (void)buyProducCompleteWithResponse:(id)response data:(id)data error:(NSError *)error;
- (UITableViewCell *)buildCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface InvestSuccessViewController : BaseViewController

@property (nonatomic,assign)double investment;
@property (nonatomic,assign) BOOL hasGoldenEgg;

@end