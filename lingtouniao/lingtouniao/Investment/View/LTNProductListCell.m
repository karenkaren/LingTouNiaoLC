//
//  LTNProductListCell.m
//  lingtouniao
//
//  Created by LiuFeifei on 15/12/11.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNProductListCell.h"
//#import "LTNBarProgressView.h"


//#define kSide DimensionBaseIphone6(24)
//#define kMargin DimensionBaseIphone6(15)

//#define kGeneral DimensionBaseIphone6(kGeneralHeight)

@interface LTNProductListCell ()

//@property (nonatomic, strong) UILabel * productNameLabel;
@property (nonatomic, strong) UILabel * staInvestAmountLable;
//@property (nonatomic, strong) NSArray * dataLabels;
//@property (nonatomic, strong) LTNBarProgressView *progressView;
//@property (nonatomic,strong)UIView *backView;

@end

@implementation LTNProductListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backView.height = kProductListCellHeight;
    }
    return self;
}

- (void)addAllSubviews
{
    [super addAllSubviews];
    BOOL repaymenting = self.product.productStatus >= 2 && ![self.product.productType isEqualToString:@"TYB"];
    
    // 8.起投金额
    UILabel * staInvestAmountLable = [[UILabel alloc] init];
    staInvestAmountLable.font = kFont(12);
    staInvestAmountLable.text = [NSString stringWithFormat:locationString(@"product_start_amount2"), @(self.product.staInvestAmount)];
    [staInvestAmountLable sizeToFit];
    staInvestAmountLable.left = kSide;
    staInvestAmountLable.centerY = kProductListCellHeight - (kProductListCellHeight - self.progressView.bottom) * 0.5;
    staInvestAmountLable.textColor = repaymenting ? HexRGB(0xcccccc) : HexRGB(0x6a6a6a);
    staInvestAmountLable.adjustsFontSizeToFitWidth = YES;
    [self.backView addSubview:staInvestAmountLable];
    self.staInvestAmountLable = staInvestAmountLable;
    
    //产品标签
    BOOL isXSB = [self.product.productType isEqualToString:@"XSB"];
    if (![self.product.productTag isEqualToString:@""] || isXSB) {
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(staInvestAmountLable.frame) + 5, self.progressView.bottom + 2, 0.5, kGeneralHeight - 12)];
        line.backgroundColor = kHexColor(@"e2e2e2");
        [self.backView addSubview:line];
        
        NSArray * tags = isXSB ? @[locationString(@"product_purchase_limit")] : [self.product.productTag componentsSeparatedByString:@";"];
        for (int i = 0; i < tags.count; i++) {
            CGSize tagSize = kStringSize(tags[i], 12);
            UILabel * tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(staInvestAmountLable.frame) + 10 + (tagSize.width + kMargin) * i, self.progressView.bottom, tagSize.width, tagSize.height)];
            tagLabel.center = CGPointMake(tagLabel.center.x, staInvestAmountLable.center.y );
            UIColor * tagColor = repaymenting ? HexRGB(0xcccccc) : HexRGB(0x6a6a6a);
            tagLabel.font = kFont(12);
            tagLabel.text = tags[i];
            tagLabel.textAlignment = NSTextAlignmentCenter;
            tagLabel.textColor = tagColor;
            [self.backView addSubview:tagLabel];
        }
    }

    // 9.购买按钮
    CGFloat purchaseButtonHeight = 28;
    NSString * purchaseTitle = [self.product.productType isEqualToString:@"TYB"] ? locationString(@"product_item_buy") : nil;
    UIColor * purchaseButtonColor = nil;
    BOOL enabled = NO;
    if ([self.product.productType isEqualToString:@"TYB"]) {
        purchaseTitle = locationString(@"product_item_buy");
        purchaseButtonColor = HexRGB(0xea5504);
        enabled = YES;
    }
    else if (repaymenting) {
        purchaseTitle = locationString(@"product_stop_invest");
        purchaseButtonColor = HexRGB(0xcccccc);
        enabled = NO;
    } else {
        purchaseTitle = locationString(@"product_ty_buy_btn");
        purchaseButtonColor = HexRGB(0xea5504);
        enabled = YES;
    }
    
    if ([self.product.isArrange isEqualToString:@"1"] && !repaymenting) {
        purchaseTitle = locationString(@"product_reservation");
        purchaseButtonColor = HexRGB(0x4ca9f8);
        enabled = YES;
    }
    CGSize purchaseTitleSize = kStringSize(purchaseTitle, 15);
    CGFloat purchaseButtonWidth = purchaseTitleSize.width + 2 * 12;
    UIButton * purchaseButton = [[UIButton alloc] initWithFrame:CGRectMake(kProductListCellWidth - kGeneralHeight * 0.5 - purchaseButtonWidth, 0, purchaseButtonWidth, purchaseButtonHeight)];
    purchaseButton.center = CGPointMake(purchaseButton.center.x, staInvestAmountLable.center.y );
    [purchaseButton setTitle:purchaseTitle forState:UIControlStateNormal];
    purchaseButton.titleLabel.font = kFont(15);
    purchaseButton.enabled = enabled;
    [purchaseButton setDisenableBackgroundColor:HexRGB(0xcccccc) enableBackgroundColor:purchaseButtonColor];
    purchaseButton.layer.cornerRadius = 3;
    purchaseButton.layer.masksToBounds = YES;
    purchaseButton.userInteractionEnabled = NO;
    [self.backView addSubview:purchaseButton];
    self.purchaseButton = purchaseButton;
    
    self.footerLineView.top = kProductListCellHeight - 0.5;
}

//- (void)setProduct:(LTNProduct *)product
//{
//    _product = product;
//    for (UIView * view in self.backView.subviews) {
//        [view removeFromSuperview];
//    }
//    [self addAllSubviews];
//}

@end
