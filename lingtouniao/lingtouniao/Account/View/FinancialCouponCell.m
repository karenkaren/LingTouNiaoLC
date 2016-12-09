//
//  FinancialCouponCell.m
//  lingtouniao
//
//  Created by 徐凯 on 15/12/19.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//




#import "FinancialCouponCell.h"
#import "StringUtil.h"

@interface FinancialCouponCell ()

//@property (weak, nonatomic) IBOutlet UILabel *couponLabel;//_ _金券
//@property (weak, nonatomic) IBOutlet UILabel *des1Label;//说明内容1
//@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//有效期时间说明
//@property (weak, nonatomic) IBOutlet UIImageView *accessview;//可使用的
//@property (weak, nonatomic) IBOutlet UILabel *Amountlabel;//优惠券价格
//@property (weak, nonatomic) IBOutlet UILabel *StatusLabel;//优惠券状态
//@property (weak, nonatomic) IBOutlet UIImageView *couponView;//更改背景图

@property (nonatomic) UILabel *couponLabel;//_ _金券
@property (nonatomic) UILabel *des1Label;//说明内容1
@property (nonatomic) UILabel *dateLabel;//有效期时间说明
@property (nonatomic) UIImageView *accessview;//可使用的
@property (nonatomic) UILabel *Amountlabel;//优惠券价格
@property (nonatomic) UILabel *StatusLabel;//优惠券状态
@property (nonatomic) UIImageView *couponView;//更改背景图

@property (nonatomic) CGSize descSize;

@end

@implementation FinancialCouponCell

- (void)awakeFromNib {
    // Initialization code
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#EFEFF4"];
        [self setupUI];
        
    }
    return self;
}
-(void)setupUI{
    
    //金券背景
    self.couponView = [[UIImageView alloc]init];
    self.couponView.frame = CGRectMake(10, 0, kScreenWidth - 20, 110);
    [self.contentView addSubview:self.couponView];
    
    //金券标题
    self.couponLabel = [Utility createLabel:[CustomerizedFont heiti:18] color:[UIColor blackColor]];
    self.couponLabel.frame = CGRectMake(15, 5, kScreenWidth - 170, 30);
    [self.couponView addSubview:self.couponLabel];
    
    //金券描述
    self.des1Label = [Utility createLabel:[CustomerizedFont heiti:10] color:[UIColor blackColor]];
  //  self.des1Label.frame = CGRectMake(15, self.couponLabel.bottom, kScreenWidth -170 , 50);
    self.des1Label.numberOfLines = 0;
    [self.couponView addSubview:self.des1Label];
    
    //有效时间
    self.dateLabel = [Utility createLabel:[CustomerizedFont heiti:10] color:[UIColor blackColor]];
   // self.dateLabel.frame = CGRectMake(15, self.des1Label.bottom, kScreenWidth - 170, 30);
    self.dateLabel.numberOfLines = 1;
    [self.couponView addSubview:self.dateLabel];
    
    //使用状态图片
    self.accessview = [[UIImageView alloc]init];
    self.accessview.frame = CGRectMake(kScreenWidth - DimensionBaseIphone6(210), 0, DimensionBaseIphone6(69), DimensionBaseIphone6(54));
    [self.couponView addSubview:self.accessview];
    
    //金券金额
    self.Amountlabel = [Utility createLabel:[CustomerizedFont heiti:26] color:[UIColor whiteColor]];
    self.Amountlabel.frame = CGRectMake(kScreenWidth - DimensionBaseIphone6(150), 20, DimensionBaseIphone6(130), 30);
    self.Amountlabel.textAlignment = NSTextAlignmentCenter;
    [self.couponView addSubview:self.Amountlabel];
    
    //金券类别
    self.StatusLabel = [Utility createLabel:[CustomerizedFont heiti:17] color:[UIColor whiteColor]];
    self.StatusLabel.frame = CGRectMake(kScreenWidth - DimensionBaseIphone6(150), self.Amountlabel.bottom, DimensionBaseIphone6(130), 30);
    self.StatusLabel.textAlignment = NSTextAlignmentCenter;
    [self.couponView addSubview:self.StatusLabel];
    
}



-(void)setFinancialCouponModel:(FinanciaCouponModel *)financialCouponModel
{
    _financialCouponModel = financialCouponModel;
    _couponLabel.text = financialCouponModel.couponName;
    _des1Label.text = financialCouponModel.desc;
    
    _dateLabel.text =[NSString stringWithFormat:locationString(@"choose_coupon_title"),financialCouponModel.couponDate];
    _Amountlabel.text = [NSString stringWithFormat:@"¥%@",financialCouponModel.amount];
   
    if ([financialCouponModel.activityType isEqualToString:locationString(@"coupon_jiaxi")]) {
        _Amountlabel.text = [NSString stringWithFormat:@"%@%@",financialCouponModel.amount,@"%"];
        DLog(@"%@",_Amountlabel.text);
    }

    
    _StatusLabel.text = financialCouponModel.activityType;
    

    [self getCouponViewBackground:financialCouponModel.activityType];
    [self getCouponStatus:financialCouponModel.status];
    
    CGSize maxSize = CGSizeMake(kScreenWidth - 170, MAXFLOAT);
    CGSize fitSize = [self.des1Label sizeThatFits:maxSize];
    self.des1Label.frame = CGRectMake(15, self.couponLabel.bottom, kScreenWidth- DimensionBaseIphone6(170), MIN(fitSize.height, 50.0));
    
    _dateLabel.frame = CGRectMake(15, _des1Label.bottom, kScreenWidth - DimensionBaseIphone6(170), 30);
    

}

//获得背景图
-(void)getCouponViewBackground:(NSString *)activityType
{
    if ([activityType isEqualToString:locationString(@"coupon_usage")]) {
        _couponView.image = [UIImage imageNamed:@"icon_coupon_xj"];
    }
    else if([activityType isEqualToString:locationString(@"coupon_tiyan")])
    {
        _couponView.image = [UIImage imageNamed:@"icon_coupon_ty"];
    }
    else if ([activityType isEqualToString:locationString(@"coupon_jiaxi")])
    {
        _couponView.image = [UIImage imageNamed:@"icon_coupon_jx"];
    }
    
}


/**
 *  获取是投资返现还是体验金券
 */
-(void)getCouponStatus:(NSString *)couponStatus
{
    if ([couponStatus isEqualToString:@"YX"]) {
        _accessview.hidden =YES;
    }else if ([couponStatus isEqualToString:@"GQ"]){
        _accessview.image = [UIImage imageNamed:@"watermark_invalid"];
        _couponView.image = [UIImage imageNamed:@"icon_coupon_sx"];
        _accessview.hidden =NO;
    }else if ([couponStatus isEqualToString:@"ZF"]){
        _accessview.hidden =YES;
    }else if ([couponStatus isEqualToString:@"SYZ"]){
        _accessview.image = [UIImage imageNamed:@"watermark_complete"];
        _couponView.image = [UIImage imageNamed:@"icon_coupon_sx"];
        _accessview.hidden =NO;
    }

}

@end
