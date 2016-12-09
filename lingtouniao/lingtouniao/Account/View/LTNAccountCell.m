//
//  LTNAccountCell.m
//  lingtouniao
//
//  Created by LiuFeifei on 15/12/12.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNAccountCell.h"
#import "LTNExplainBirdCoinView.h"
#import "GuideShadeView.h"

#define kMargin 5
#define kLineHeight 48

@interface LTNAccountCell ()

@property (nonatomic, strong) NSArray * dataLabels;

@property (nonatomic) NSString *usableBalanc,*birdCoin,*totalAsset;

@end

@implementation LTNAccountCell

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        [self setupUI];
//    }
//    return self;
//}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    CGFloat width = kAccountCellWidth / 3.0;
    NSArray * titleArray = @[locationString(@"total_assets_with_unit"),locationString(@"usable_balance_with_unit"), locationString(@"usable_bird_coin")];
    NSString * totalAsset = [CurrentUser mine].accountInfo.totalAsset > 10000000 ? [NSString stringWithFormat:locationString(@"amount_wan_decimal"), [CurrentUser mine].accountInfo.totalAsset / 10000.0] : [NSString stringWithFormat:@"%.2f", [CurrentUser mine].accountInfo.totalAsset];
    NSString * usableBalanc = [CurrentUser mine].accountInfo.usableBalance > 10000000 ? [NSString stringWithFormat:locationString(@"amount_wan_decimal"), [CurrentUser mine].accountInfo.usableBalance / 10000.0] : [NSString stringWithFormat:@"%.2f", [CurrentUser mine].accountInfo.usableBalance];
    NSString * birdCoin = [CurrentUser mine].accountInfo.birdCoin > 10000000 ? [NSString stringWithFormat:locationString(@"amount_wan_decimal"), [CurrentUser mine].accountInfo.birdCoin / 10000.0] : [NSString stringWithFormat:@"%.2f", [CurrentUser mine].accountInfo.birdCoin];
   
    self.usableBalanc = usableBalanc;
    self.birdCoin = birdCoin;
    self.totalAsset = totalAsset;
    NSArray * datas = @[totalAsset,usableBalanc, birdCoin];
    NSArray * selNames = @[@"totalAssetDetail",@"usableBalanceDetail", @"birdCoinDetail"];
    NSMutableArray * dataArray = [NSMutableArray arrayWithCapacity:titleArray.count];
    for (int i = 0; i < titleArray.count; i++) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(width * i, 0, width, kAccountCellHeight)];
        SEL selName = NSSelectorFromString(selNames[i]);
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:selName];
        [view addGestureRecognizer:tap];
//        [self.contentView addSubview:view];
        [self addSubview:view];
        
//        if(i==2&&[GuideShadeView shouldShowTeachingViewWithType:LTNTeachTypeBirdCoin]){
//            [GuideShadeView addTeachType:LTNTeachTypeBirdCoin withView:view];
//        }
        
        if(i==2){
            [GuideShadeView addTeachType:LTNTeachTypeBirdCoin withView:view];
                }
        
        CGFloat dataY = (kAccountCellHeight - kLineHeight) * 0.5;
        UILabel * dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, dataY, width, kLineHeight * 0.5)];
        dataLabel.tag = 200+i;
        dataLabel.text = datas[i];
        dataLabel.font = kFont(13);
//        dataLabel.textColor = HexRGB(0x3a3a3a);
        dataLabel.textColor = [UIColor whiteColor];
        dataLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:dataLabel];
        [dataArray addObject:dataLabel];
        
        CGFloat titleY = CGRectGetMaxY(dataLabel.frame) - 5;
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, titleY, width, kLineHeight * 0.5)];
        titleLabel.text = titleArray[i];
        titleLabel.font = kFont(11);
//        titleLabel.textColor = HexRGB(0x8a8a8a);
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:titleLabel];
        
        // 竖线
        if (i < 3) {
            UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(width * (i + 1), (kAccountCellHeight - kLineHeight + 4) * 0.5, 0.5, kLineHeight  - 10)];
            lineView.backgroundColor = HexRGB(0xcccccc);
//            [self.contentView addSubview:lineView];
              [self addSubview:lineView];

        }
        
        // 鸟币说明
        if (i == 2) {
            CGSize titleSize = kStringSize(titleArray[i], 12);
            UIImage * buttonImage = [UIImage imageNamed:@"icon_help"];
            CGFloat buttonWidth = buttonImage.size.width;
            UIButton * birdCoinButton = [[UIButton alloc] initWithFrame:CGRectMake(titleLabel.center.x + titleSize.width * 0.5 + 6, CGRectGetMinY(titleLabel.frame), buttonWidth, buttonWidth)];
            [birdCoinButton setEnlargeEdge:20];
            birdCoinButton.center = CGPointMake(birdCoinButton.center.x, titleLabel.center.y);
            [birdCoinButton setImage:buttonImage forState:UIControlStateNormal];
            [birdCoinButton addTarget:self action:@selector(explainBirdCoin) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:birdCoinButton];
        }
    }
    self.dataLabels = dataArray;
}
-(void)setIsShow:(BOOL)isShow{
    _isShow = isShow;
    UILabel *usableBalanceLabel = (id)[self viewWithTag:200+1];
    UILabel *birdCoinLabel = (id)[self viewWithTag:200+2];
    UILabel *totalAssetLabel = (id)[self viewWithTag:200+0];
    if (self.isShow) {
        usableBalanceLabel.text = @"****";
        birdCoinLabel.text = @"****";
        totalAssetLabel.text = @"****";
    }else{
        usableBalanceLabel.text = self.usableBalanc;
        birdCoinLabel.text = self.birdCoin;
        totalAssetLabel.text = self.totalAsset;
        
    }
    
    
}


-(void)updateCell{
    
    
    NSString * totalAsset = [CurrentUser mine].accountInfo.totalAsset > 10000000 ? [NSString stringWithFormat:locationString(@"amount_wan_decimal"), [CurrentUser mine].accountInfo.totalAsset / 10000.0] : [NSString stringWithFormat:@"%.2f", [CurrentUser mine].accountInfo.totalAsset];
    NSString * usableBalanc = [CurrentUser mine].accountInfo.usableBalance > 10000000 ? [NSString stringWithFormat:locationString(@"amount_wan_decimal"), [CurrentUser mine].accountInfo.usableBalance / 10000.0] : [NSString stringWithFormat:@"%.2f", [CurrentUser mine].accountInfo.usableBalance];
    NSString * birdCoin = [CurrentUser mine].accountInfo.birdCoin > 10000000 ? [NSString stringWithFormat:locationString(@"amount_wan_decimal"), [CurrentUser mine].accountInfo.birdCoin / 10000.0] : [NSString stringWithFormat:@"%.2f", [CurrentUser mine].accountInfo.birdCoin];
    
    self.usableBalanc = usableBalanc;
    self.birdCoin = birdCoin;
    self.totalAsset = totalAsset;
    
    self.isShow=_isShow;

    
}
#pragma mark - 通知delegate
#pragma mark 可用余额明细
- (void)usableBalanceDetail
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(accountCellWillShowUsableBalanceDetail)]) {
        [self.delegate accountCellWillShowUsableBalanceDetail];
    }
}

#pragma mark 鸟币明细
- (void)birdCoinDetail
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(accountCellWillShowBirdCoinDetail)]) {
        [self.delegate accountCellWillShowBirdCoinDetail];
    }
}

#pragma mark 总资产明细
- (void)totalAssetDetail
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(accountCellWillShowTotalAssetDetail)]) {
        [self.delegate accountCellWillShowTotalAssetDetail];
    }
}

#pragma mark 鸟币解释
- (void)explainBirdCoin
{
    LTNExplainBirdCoinView * explainView = [[LTNExplainBirdCoinView alloc] init];
    [explainView show];
    DLog(@"鸟币说明");
}

@end
