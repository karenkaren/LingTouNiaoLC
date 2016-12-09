 //
//  CouponTableViewCell.m
//  lingtouniao
//
//  Created by 徐凯 on 15/12/30.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "CouponTableViewCell.h"

@interface CouponTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *couponLabel;//返现金券
@property (weak, nonatomic) IBOutlet UILabel *couponDescLabel;//优惠金券描述
@property (weak, nonatomic) IBOutlet UILabel *productDueDayLabel;//到期时间



@end


@implementation CouponTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setFinanciaCouponModel:(FinanciaCouponModel *)financiaCouponModel
{
    _financiaCouponModel = financiaCouponModel;
    if (financiaCouponModel) {
          _couponLabel.text = financiaCouponModel.couponName;
        _couponDescLabel.text = financiaCouponModel.desc;
        _productDueDayLabel.text = [NSString stringWithFormat:locationString(@"choose_coupon_title"),financiaCouponModel.couponDate];
    }
  
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
