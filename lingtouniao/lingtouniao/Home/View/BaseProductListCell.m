//
//  BaseProductListCell.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/5/26.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "BaseProductListCell.h"

@interface BaseProductListCell ()

@property (nonatomic, strong) UILabel * productNameLabel;
@property (nonatomic, strong) NSArray * dataLabels;

@end

@implementation BaseProductListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor colorWithHexString:@"#f3f5f7"];
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBaseProductListCellHeight)];
        [self.contentView addSubview:self.backView];
        self.backView.backgroundColor=[UIColor whiteColor];
    }
    return self;
}

- (void)addAllSubviews
{
    BOOL repaymenting = self.product.productStatus >= 2 && ![self.product.productType isEqualToString:@"TYB"];
    // 0.头部线条
    UIView * headerLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kProductListCellWidth, 0.5)];
    headerLineView.backgroundColor = HexRGB(0xe2e2e2);
    [self.backView addSubview:headerLineView];
    
    // 1.产品名称
    NSString * productName = [NSString stringWithFormat:@"%@", self.product.productName];
    CGSize productNameSize = kStringSize(productName, 16);
    UILabel * productNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSide, kMargin, productNameSize.width, productNameSize.height)];
    //    productNameLabel.backgroundColor = kRGBAColor(100, 30, 200, 0.3);
    productNameLabel.text = productName;
    productNameLabel.textColor = repaymenting ? HexRGB(0xcccccc) : HexRGB(0x6a6a6a);
    productNameLabel.font = kFont(16);
    [self.backView addSubview:productNameLabel];
    self.productNameLabel = productNameLabel;
    
    // 2.产品标签
    //    if (![self.product.productTag isEqualToString:@""]) {
    //        NSArray * tags = [self.product.productTag componentsSeparatedByString:@";"];
    //        for (int i = 0; i < tags.count; i++) {
    //            CGSize tagSize = kStringSize(tags[i], 12);
    //            tagSize.width += 15;
    //            tagSize.height += 5;
    //            UILabel * tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(productNameLabel.frame) + kSide * 0.5 + (tagSize.width + kMargin) * i, 0, tagSize.width, tagSize.height)];
    //            tagLabel.center = CGPointMake(tagLabel.center.x, productNameLabel.center.y);
    //            UIColor * tagColor = repaymenting ? HexRGB(0xcccccc) : self.tagColors[tags[i]];
    //            tagLabel.font = kFont(12);
    //            tagLabel.text = tags[i];
    //            tagLabel.textAlignment = NSTextAlignmentCenter;
    //            tagLabel.backgroundColor  =[UIColor redColor];
    //            tagLabel.textColor = tagColor;
    //            tagLabel.layer.borderColor = tagColor.CGColor;
    //            tagLabel.layer.borderWidth = 1;
    //            tagLabel.layer.cornerRadius = 10;
    //            tagLabel.layer.masksToBounds = YES;
    //            [self.contentView addSubview:tagLabel];
    //        }
    //    }
    
    // 3.1 产品角标
    //    UIImage * image = [self.product.productType isEqualToString:@"TYB"] ? [UIImage imageNamed:@"icon_label_ty"] : nil;
    //    UIImageView * cornerMarkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kProductListCellWidth - image.size.width, 0, image.size.width, image.size.height)];
    //    cornerMarkImageView.image = image;
    //    [self.contentView addSubview:cornerMarkImageView];
    
    UIImage * image = nil;
    if ([self.product.productType isEqualToString:@"TYB"]) {
        image = [UIImage imageNamed:@"icon_label_ty"];
    } else if ([self.product.productType isEqualToString:@"SXT"]) {
        image = [UIImage imageNamed:@"icon_label_sxt"];
    }
    UIImageView * cornerMarkImageView = [[UIImageView alloc] initWithImage:image];
    cornerMarkImageView.right = kProductListCellWidth;
    cornerMarkImageView.image = image;
    [self.backView addSubview:cornerMarkImageView];
    
    if ([self.product.productType isEqualToString:@"XSB"]) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_label_xsb"]];
        imageView.left = productNameLabel.width+30;
        imageView.top = productNameLabel.top+2.5;
        
        [self.backView addSubview:imageView];
    }
    
    // 3.2 产品状态图标
    UIImage * watermarkImage = repaymenting ? [UIImage imageNamed:@"watermark_over"] : nil;
    UIImageView * watermarkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kProductListCellWidth - 24 - watermarkImage.size.width, 0, watermarkImage.size.width, watermarkImage.size.height)];
    watermarkImageView.image = watermarkImage;
    [self.backView addSubview:watermarkImageView];
    
    // 4.分割线
    //    CGFloat lineHeight = 0.5;
    //    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(kSide * 0.5, kProductListCellHeight - kGeneralHeight - lineHeight, kProductListCellWidth - kSide, lineHeight)];
    //    lineView.backgroundColor = kHexColor(@"e2e2e2");
    //    [self.contentView addSubview:lineView];
    //    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(kSide * 0.5, kProductListCellHeight - kGeneralHeight - lineHeight, kProductListCellWidth - kSide, lineHeight)];
    //    lineView.backgroundColor = kHexColor(@"e2e2e2");
    //    [self.backView addSubview:lineView];
    
    // 5.年化收益率
    // 6.投资期限
    // 7.投资金额
    CGFloat dataViewWidth = kProductListCellWidth / 3.0;
    CGFloat dataViewHeight = 70;
    NSArray * dataTitles = @[locationString(@"annual_income"), locationString(@"invest_date"), locationString(@"remaining_amount")];
    NSString * deadlineUnit = [self.product.deadlineUnit isEqualToString:@"Y"] ? locationString(@"deadline_unit_year") : ([self.product.deadlineUnit isEqualToString:@"M"] ? locationString(@"deadline_unit_month") : locationString(@"deadline_unit_day"));
    NSString * remainAmount = self.product.productRemainAmount >= 10000 ? [NSString stringWithFormat:locationString(@"amount_wan_decimal"), self.product.productRemainAmount / 10000.0] : [NSString stringWithFormat:locationString(@"amount_yuan_decimal"), self.product.productRemainAmount];
    
    NSString * productDeadline;
    /*if ([self.product.productType isEqualToString:@"TYB"]) {
        productDeadline = locationString(@"product_tyb_deadline");
    } else */if ([self.product.productType isEqualToString:@"SXT"]) {
        productDeadline = locationString(@"tab_detail_take");
    } else {
        productDeadline = [NSString stringWithFormat:@"%@%@", [self.product deadlineString], deadlineUnit];
    }
    
    NSArray * datas = @[[NSString stringWithFormat:@"%@", self.product.annualIncomeText], productDeadline, remainAmount];
    
    NSMutableArray * dataLabels = [NSMutableArray arrayWithCapacity:datas.count];
    UIColor * dataTitleColor = repaymenting ? HexRGB(0xcccccc) : HexRGB(0x8a8a8a);
    for (int i = 0; i < datas.count; i++) {
        
        if ([self.product.productType isEqualToString:@"TYB"] && i == 2) {
            break;
        }
        UIView * dataView = [[UIView alloc] initWithFrame:CGRectMake(dataViewWidth * i, productNameLabel.bottom, dataViewWidth, dataViewHeight)];
        [self.backView addSubview:dataView];
        
        UILabel * dataTitleLabel = [Utility createLabel:[CustomerizedFont systemFontOfSize:12] color:dataTitleColor];
        dataTitleLabel.text = dataTitles[i];
        [dataTitleLabel sizeToFit];
        dataTitleLabel.left = i ? (i == 1 ? kSide * 1.5 : kSide * 0.5) : kSide;
        dataTitleLabel.centerY = dataView.height * 0.75;
        [dataView addSubview:dataTitleLabel];
        
        UIFont * font = i ? (i == 1 ? kFont(24) : kFont(16)) : kFont(30);
        UIColor * dataColor = repaymenting ? HexRGB(0xcccccc) : (i ? HexRGB(0x3a3a3a) : [UIColor colorWithHexString:@"#ea5504"]);
        UILabel * dataLabel = [Utility createLabel:font color:dataColor];
        dataLabel.text = datas[i];
        
        if ([self.product.productType isEqualToString:@"SXT"] || [self.product.productType isEqualToString:@"TYB"]) {
            if (i == 1) {
                dataLabel.font = [CustomerizedFont heiti:16];
            }
        }
        
        [dataLabel sizeToFit];
        dataLabel.left = dataTitleLabel.left;
        dataLabel.bottom = dataTitleLabel.top;
        NSString * attributeString = i ? (i == 1 ? deadlineUnit : remainAmount) : @"%";
        [dataLabel addAttributesWithFontSize:16 forString:attributeString];
        
        if (dataLabel.width >= dataViewWidth) {
            dataLabel.width = dataViewWidth;
            dataLabel.adjustsFontSizeToFitWidth = YES;
        }
        
        [dataView addSubview:dataLabel];
        [dataLabels addObject:dataLabel];
    }
    self.dataLabels = dataLabels;
    
    // 项目进度
    CGFloat lineHeight = 0.5;
    if (_progressView) {
        _progressView = nil;
        [_progressView removeFromSuperview];
    }
    _progressView = [[LTNBarProgressView alloc]initWithFrame:CGRectMake(DimensionBaseIphone6(24), productNameLabel.bottom + dataViewHeight - 5, kProductListCellWidth - kSide*2, lineHeight*8)];
    double raseAmount = self.product.productTotalAmount - self.product.productRemainAmount;
    double progress = raseAmount/self.product.productTotalAmount;
    _progressView.finished=repaymenting;
    _progressView.progress = progress;
    [self.backView addSubview:_progressView];
    DLog(@"%f", _progressView.bottom);
    
    // 底部线条
    UIView * footerLineView = [[UIView alloc] initWithFrame:CGRectMake(0, kBaseProductListCellHeight - 0.5, kProductListCellWidth, 0.5)];
    footerLineView.backgroundColor = HexRGB(0xe2e2e2);
    [self.backView addSubview:footerLineView];
    self.footerLineView = footerLineView;
}

- (void)setProduct:(LTNProduct *)product
{
    _product = product;
    for (UIView * view in self.backView.subviews) {
        [view removeFromSuperview];
    }
    [self addAllSubviews];
}

@end
