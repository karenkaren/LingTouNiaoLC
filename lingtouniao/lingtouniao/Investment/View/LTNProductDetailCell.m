//
//  UITableViewCell.m
//  lingtouniao
//
//  Created by LiuFeifei on 15/12/10.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNProductDetailCell.h"
#import "LTNExplainBirdCoinView.h"
#import "LJBarProgressView.h"

#define kSide 40

@interface LTNProductDetailCell ()
{
    LJBarProgressView * _barProgress;
}

@property (nonatomic, strong) NSDictionary * tagColors;

@end

@implementation LTNProductDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.tagColors = @{locationString(@"product_tag1") : kRGBColor(224, 82, 85), locationString(@"product_tag3") : kRGBColor(89, 221, 201), locationString(@"product_tag4") : kRGBColor(253, 160, 9), locationString(@"product_tag5") : kRGBColor(65, 176, 80)};
    }
    return self;
}

- (void)setProduct:(LTNProduct *)product
{
    _product = product;
    if (!product) {
        return;
    }
    [self addAllSubviews];
}

#pragma mark 添加子控件
- (void)addAllSubviews
{
    BOOL isTYB = [self.product.productType isEqualToString:@"TYB"];
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kProductDetailCellWidth, DimensionBaseIphone6(180))];
    headerView.backgroundColor = isTYB ? kRGBColor(62, 150, 250) : nil;
    [self.contentView addSubview:headerView];
    
    // 0.分隔线
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.height - 0.5, kScreenWidth, 0.5)];
    lineView.backgroundColor = DEVIDE_LINE_COLOR;
    [headerView addSubview:lineView];
    
    // 1.产品名称
    CGSize productNameSize = kStringSize(self.product.productName, 18);
    UIView * productNameView = [[UIView alloc] initWithFrame:CGRectMake(0, DimensionBaseIphone6(18), kProductDetailCellWidth, productNameSize.height)];
    [headerView addSubview:productNameView];
    
    UILabel * productNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, productNameSize.width, CGRectGetHeight(productNameView.frame))];
    productNameLabel.center = CGPointMake(kProductDetailCellWidth * 0.5, productNameSize.height * 0.5);
    productNameLabel.text = self.product.productName;
    productNameLabel.font = kFont(18);
    productNameLabel.textColor = isTYB ? [UIColor whiteColor] : HexRGB(0x3a3a3a);
    [productNameView addSubview:productNameLabel];
    
    for (int i = 0; i < 2; i++) {
        CGFloat x = i ? CGRectGetMaxX(productNameLabel.frame) + DimensionBaseIphone6(16) : CGRectGetMaxX(productNameLabel.frame) - DimensionBaseIphone6(16 + 48) - productNameSize.width;
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(x, 0, 48, 0.5)];
        CGPoint center = lineView.center;
        center.y = productNameLabel.center.y;
        lineView.center = center;
        lineView.backgroundColor = isTYB ? [UIColor whiteColor] : HexRGB(0xcccccc);
        [productNameView addSubview:lineView];
    }
    
    // tags
    if (![self.product.productTag isEqualToString:@""] && ![self.product.productType isEqualToString:@"XSB"]) {
        NSArray * tags = [self.product.productTag componentsSeparatedByString:@";"];
        UIView * tagsView = [[UIView alloc] init];
        tagsView.top = productNameView.bottom + 9;
        [headerView addSubview:tagsView];
        for (int i = 0; i < tags.count; i++) {
            CGSize tagSize = kStringSize(tags[i], 12);
            tagSize.width += 15;
            tagSize.height += 5;
            tagsView.height = tagSize.height;
            UILabel * tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tagSize.width, tagSize.height)];
            UIColor * tagColor = self.tagColors[tags[i]] ? self.tagColors[tags[i]] : HexRGB(0xcccccc);
            tagLabel.font = kFont(12);
            tagLabel.text = tags[i];
            tagLabel.textAlignment = NSTextAlignmentCenter;
            tagLabel.textColor = tagColor;
            tagLabel.layer.borderColor = tagColor.CGColor;
            tagLabel.layer.borderWidth = 1;
            tagLabel.layer.cornerRadius = 10;
            tagLabel.layer.masksToBounds = YES;
            [tagsView addSubview:tagLabel];
        }
        CGFloat tagsViewWidth = 0;
        for (int i = 0; i < tags.count; i++) {
            UILabel * tagLabel = tagsView.subviews[i];
            tagLabel.left = tagsViewWidth;
            if (i != tags.count - 1) {
                tagsViewWidth += 10;
            }
            tagsViewWidth += tagLabel.width;
        }
        tagsView.width = tagsViewWidth;
        tagsView.centerX = kScreenWidth * 0.5;
    }
    /**
     *  
     */
    if ([self.product.productType isEqualToString:@"XSB"]) {
        NSString *string = locationString(@"xs_hint");
        CGSize stringSize = kStringSize(string, 12);
        UIView *view = [[UIView alloc]init];
        view.top = productNameView.bottom+9;
        [headerView addSubview:view];
        UIColor *color = kRGBColor(224, 82, 85);
      
        stringSize.width +=15;
        stringSize.height +=5;
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth-stringSize.width)/2, 0, stringSize.width, stringSize.height)];
        textLabel.textColor = color;
        textLabel.text = string;
        textLabel.font = kFont(12);
        textLabel.textAlignment = NSTextAlignmentCenter;
        
        textLabel.layer.borderColor = color.CGColor;
        textLabel.layer.borderWidth = 1;
        textLabel.layer.cornerRadius = 10;
        textLabel.layer.masksToBounds = YES;
        [view addSubview:textLabel];
    }
    
    // 2.年化收益率
    // 3.投资期限
    // 4.募集总额
    CGFloat dataViewWidth = kProductDetailCellWidth / 3.0;
    NSString * staInvestAmount = [self.product.productType isEqualToString:@"TYB"] ? locationString(@"sta_invest_amount") : locationString(@"product_total_amount");
    NSArray * dataTitles = @[locationString(@"annual_income"), locationString(@"invest_date"), staInvestAmount];
    NSString * deadlineUnit = [self.product.deadlineUnit isEqualToString:@"Y"] ? locationString(@"deadline_unit_year") : ([self.product.deadlineUnit isEqualToString:@"M"] ? locationString(@"deadline_unit_month") : locationString(@"deadline_unit_day"));
//    NSString * staInvesData = [NSString stringWithFormat:@"%ld元", self.product.staInvestAmount];
    NSString * staInvesData = isTYB ? [NSString stringWithFormat:@"%@%@", @(self.product.staInvestAmount), locationString(@"money_unit_yuan")] : [NSString stringWithFormat:@"%.2f%@", self.product.productTotalAmount / 10000.0, locationString(@"money_unit_wan")];
//    NSString * productDeadline = isTYB ? locationString(@"product_tyb_deadline") : [NSString stringWithFormat:@"%@%@", [self.product deadlineString], deadlineUnit];
    
    NSString * productDeadline = [NSString stringWithFormat:@"%@%@", [self.product deadlineString], deadlineUnit];
    
    
    NSArray * datas = @[[NSString stringWithFormat:@"%@", self.product.annualIncomeText], productDeadline, staInvesData];
    CGFloat dataViewTop = DimensionBaseIphone6(74);
    for (int i = 0; i < 3; i++) {
        UIView * dataView = dataView = [[UIView alloc] initWithFrame:CGRectMake(i * dataViewWidth, dataViewTop, dataViewWidth, lineView.top - dataViewTop)];
        [headerView addSubview:dataView];

        UIColor * titleColor = isTYB ? [UIColor whiteColor] : HexRGB(0x8a8a8a);
        UILabel * dataTitleLabel = [Utility createLabel:[CustomerizedFont systemFontOfSize:12] color:titleColor];
        dataTitleLabel.text = dataTitles[i];
        [dataTitleLabel sizeToFit];
        dataTitleLabel.left = i == 1 ? kSide * 1.3 : kSide * 0.8;
        dataTitleLabel.centerY = dataView.height * 0.7;
        [dataView addSubview:dataTitleLabel];

        UIColor * dataColor = isTYB ? [UIColor whiteColor] : HexRGB(0x6a6a6a);
        CGFloat fontSize = i ? 16 : 30;
        UILabel * dataLabel = [Utility createLabel:[CustomerizedFont systemFontOfSize:fontSize] color:dataColor];
        dataLabel.text = datas[i];
        if (i == 0 && !isTYB) {
            dataLabel.textColor = [UIColor colorWithHexString:@"#ea5504"];
        }
        [dataLabel sizeToFit];
        dataLabel.left = dataTitleLabel.left;
        dataLabel.bottom = dataTitleLabel.top;
        NSString * attributeString = i ? (i == 1 ? deadlineUnit : locationString(@"money_unit_yuan")) : @"%";
        [dataLabel addAttributesWithFontSize:16 forString:attributeString];
        [dataView addSubview:dataLabel];
    }
    
    // 5.收益方式
    // 6.起息日期
    NSString * staRateString = isTYB ? self.product.rateCalculateType : [[self.product.staRateDate componentsSeparatedByString:@" "] firstObject];
    NSArray * incomeRelatedDatas = @[self.product.repaymentType, staRateString];
    NSString * repaymentTypeTitle = isTYB ? locationString(@"productt_ty_detail_profit_type") : locationString(@"revenue_type");
    NSArray * incomeRelatedTitles = @[repaymentTypeTitle, locationString(@"revenue_date")];
    CGFloat incomeRelatedWidth = isTYB ? kProductDetailCellWidth * 0.6 : kProductDetailCellWidth * 0.5;
    CGFloat incomeRelatedHeight = isTYB ? 40 : 33;
    for (int i = 0; i < 2; i++) {
        UIView * incomeRelatedView = [[UIView alloc] initWithFrame:CGRectMake(incomeRelatedWidth * i, CGRectGetMaxY(headerView.frame) + DimensionBaseIphone6(incomeRelatedHeight * 0.4), incomeRelatedWidth, incomeRelatedHeight)];
        [self.contentView addSubview:incomeRelatedView];
        UILabel * incomeRelatedDataLabel = [Utility createLabel:[CustomerizedFont systemFontOfSize:14] color:HexRGB(0x6a6a6a)];
        incomeRelatedDataLabel.text = incomeRelatedDatas[i];
        [incomeRelatedDataLabel sizeToFit];
        incomeRelatedDataLabel.left = i ? 0 : 24;
        incomeRelatedDataLabel.top = 0;
        [incomeRelatedView addSubview:incomeRelatedDataLabel];
        
        UILabel * incomeRelatedTitleLabel = [Utility createLabel:[CustomerizedFont systemFontOfSize:12] color:HexRGB(0x8a8a8a)];
        incomeRelatedTitleLabel.text = incomeRelatedTitles[i];
        [incomeRelatedTitleLabel sizeToFit];
        incomeRelatedTitleLabel.left = i ? 0 : 24;
        incomeRelatedTitleLabel.top = incomeRelatedDataLabel.bottom;
        [incomeRelatedView addSubview:incomeRelatedTitleLabel];
        
        // 如果是体验标，则需要弹出鸟币说明框
        if (isTYB && i == 0) {
            CGSize titleSize = kStringSize(incomeRelatedTitles[0], 13);
            UIImage * buttonImage = [UIImage imageNamed:@"icon_help"];
            CGFloat buttonWidth = buttonImage.size.width;
            UIButton * birdCoinButton = [[UIButton alloc] initWithFrame:CGRectMake(titleSize.width + 15, CGRectGetMinY(incomeRelatedTitleLabel.frame), buttonWidth, buttonWidth)];
            [birdCoinButton setEnlargeEdge:20];
            birdCoinButton.center = CGPointMake(birdCoinButton.center.x, incomeRelatedTitleLabel.center.y);
            [birdCoinButton setImage:buttonImage forState:UIControlStateNormal];
            [birdCoinButton addTarget:self action:@selector(explainBirdCoin) forControlEvents:UIControlEventTouchUpInside];
            [incomeRelatedView addSubview:birdCoinButton];
        }
    }

    // 9.横分隔线
    CGFloat lineWidth = isTYB ? kProductDetailCellWidth - 20 : kProductDetailCellWidth;
    CGFloat lineX = isTYB ? 10 : 0;
    UIView * horizontalLineView = [[UIView alloc] initWithFrame:CGRectMake(lineX, CGRectGetMaxY(headerView.frame) + DimensionBaseIphone6(incomeRelatedHeight * 2), lineWidth, 0.5)];
    horizontalLineView.backgroundColor = DEVIDE_LINE_COLOR;
    [self.contentView addSubview:horizontalLineView];
    
    if (isTYB) {
        // 10.项目详情
        UIView * productDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(horizontalLineView.frame), kProductDetailCellWidth, kProductDetailVirtualHeight - CGRectGetMaxY(horizontalLineView.frame))];
        [self.contentView addSubview:productDetailView];
        
        NSString * productDetailTitle = locationString(@"productt_ty_detail_know_tyb");
        CGSize productDetailTitleSize = kStringSize(productDetailTitle, 16);
        UILabel * productDetailTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(DimensionBaseIphone6(20), 16, productDetailTitleSize.width, productDetailTitleSize.height)];
        productDetailTitleLabel.textColor = HexRGB(0x6a6a6a);
        productDetailTitleLabel.font = kFont(16);
        productDetailTitleLabel.text = productDetailTitle;
        [productDetailView addSubview:productDetailTitleLabel];
        
        CGSize productDetailSize = [self.product.productTitle boundingRectWithSize:CGSizeMake(kProductDetailCellWidth - DimensionBaseIphone6(20) * 2, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : kFont(14)} context:nil].size;
        CGFloat productDetailY = CGRectGetMaxY(productDetailTitleLabel.frame) + (CGRectGetHeight(productDetailView.frame) - CGRectGetMaxY(productDetailTitleLabel.frame) - productDetailSize.height) * 0.5;
        UILabel * productDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(DimensionBaseIphone6(20), productDetailY, productDetailSize.width, productDetailSize.height)];
        productDetailLabel.font = kFont(14);
        productDetailLabel.textColor = HexRGB(0x6a6a6a);
        productDetailLabel.numberOfLines = 0;
        productDetailLabel.text = self.product.productTitle;
        [productDetailView addSubview:productDetailLabel];
    } else {
        // 项目进度
        if(_barProgress)
        {
            _barProgress = nil;
            [_barProgress removeFromSuperview];
        }
         _barProgress = [[LJBarProgressView alloc] initWithFrame:CGRectMake(DimensionBaseIphone6(24), horizontalLineView.bottom + kSide * 0.3, kScreenWidth - 2 * 24, 8)];
        double raiseAmount = self.product.productTotalAmount - self.product.productRemainAmount;
        double progress = raiseAmount / self.product.productTotalAmount;
        _barProgress.progress = progress;
        [self.contentView addSubview:_barProgress];
        
        NSArray * productProgressDatas = @[[NSString stringWithFormat:@"%.2f%%", progress * 100], [NSString stringWithFormat:@"%.2f%@", self.product.productRemainAmount, locationString(@"money_unit_yuan")]];
        NSArray * productProgressTitles = @[locationString(@"product_details_progress"), locationString(@"product_details_remain_amount")];
        CGFloat productProgressWidth = kProductDetailCellWidth * 0.5;
        for (int i = 0; i < 2; i++) {
            UIView * productProgressView = [[UIView alloc] initWithFrame:CGRectMake(productProgressWidth * i, _barProgress.bottom, productProgressWidth, kProductDetailCellHeight - _barProgress.bottom)];
            [self.contentView addSubview:productProgressView];
            
            UILabel * productProgressTitleLabel = [Utility createLabel:[CustomerizedFont systemFontOfSize:12] color:HexRGB(0x8a8a8a)];
            productProgressTitleLabel.text = productProgressTitles[i];
            [productProgressTitleLabel sizeToFit];
            productProgressTitleLabel.left = i ? 0 : 24;
            productProgressTitleLabel.centerY = productProgressView.height * 0.5;
            [productProgressView addSubview:productProgressTitleLabel];
            
            UILabel * productProgressDataLabel = [Utility createLabel:[CustomerizedFont systemFontOfSize:14] color:HexRGB(0x6a6a6a)];
            productProgressDataLabel.text = productProgressDatas[i];
            [productProgressDataLabel sizeToFit];
            productProgressDataLabel.left = productProgressTitleLabel.right;
            productProgressDataLabel.centerY = productProgressView.height * 0.5;
            [productProgressView addSubview:productProgressDataLabel];
            
//            [productProgressDataLabels addObject:productProgressDataLabel];
        }
        
        
        if([self.product hasTotalLimitAmount]||[self.product hasSingleLimitAmount]){
            
            UIView * horizontalLineView = [[UIView alloc] initWithFrame:CGRectMake(lineX, kProductDetailCellHeight, lineWidth, 0.5)];
            horizontalLineView.backgroundColor = DEVIDE_LINE_COLOR;
            [self.contentView addSubview:horizontalLineView];
                 
            if([self.product hasTotalLimitAmount]){
                //单人累计限额
                UILabel * totalLimitAmountLabel = [Utility createLabel:[CustomerizedFont systemFontOfSize:12] color:HexRGB(0x8a8a8a)];
                totalLimitAmountLabel.text =[NSString stringWithFormat:locationString(@"total_limit_amount"),transToMill(self.product.totalLimitAmount)];
                [totalLimitAmountLabel sizeToFit];
                totalLimitAmountLabel.left = 24;
                totalLimitAmountLabel.centerY = horizontalLineView.bottom+kGeneralHeight*0.5;
                [self.contentView addSubview:totalLimitAmountLabel];
                
            }
            
            if([self.product hasSingleLimitAmount]){
                //单笔限额
                UILabel * singleLimitAmountLabel = [Utility createLabel:[CustomerizedFont systemFontOfSize:12] color:HexRGB(0x8a8a8a)];
                singleLimitAmountLabel.text = [NSString stringWithFormat:locationString(@"single_limit_amount"),transToMill(self.product.singleLimitAmount)];
                [singleLimitAmountLabel sizeToFit];
                singleLimitAmountLabel.left =[self.product hasTotalLimitAmount] ? productProgressWidth : 24;
                singleLimitAmountLabel.centerY = horizontalLineView.bottom+kGeneralHeight*0.5;
                [self.contentView addSubview:singleLimitAmountLabel];
            }
            
            
        }
//        _dataLabels = productProgressDataLabels;
    }
}

- (void)explainBirdCoin
{
    LTNExplainBirdCoinView * explainView = [[LTNExplainBirdCoinView alloc] init];
    [explainView show];
    DLog(@"鸟币说明");
}

@end
