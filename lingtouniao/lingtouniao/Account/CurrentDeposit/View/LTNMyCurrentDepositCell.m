//
//  LTNMyCurrentDepositCell.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/1/20.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNMyCurrentDepositCell.h"
#import "LTNCircleProgressView.h"

#define kTopMargin DimensionBaseIphone6(30)
#define kHeaderHeight DimensionBaseIphone6(45)
#define kRadius DimensionBaseIphone6(140)
#define kCircleCenterY kTopMargin * 2 + kHeaderHeight + kRadius

@interface LTNMyCurrentDepositCell ()

{
    NSArray * _labels;
    NSArray * _buttons;
    UILabel * _applyingAmountLabel;
    UILabel * _fullPromptLabel;
    LTNCircleProgressView * _progressView;
}

@end

@implementation LTNMyCurrentDepositCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = HexRGB(0xf3f5f7);
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    NSMutableArray * labels = [NSMutableArray array];
    NSMutableArray * buttons = [NSMutableArray array];
    
    UIView * headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:headerView];
    
    // n个tag
    NSArray * titles = @[locationString(@"annual_income"), locationString(@"my_current_account_birdcoin")];
    NSArray * datas = @[@"5.5%", locationString(@"interest_day")];
    CGFloat width = (kScreenWidth - 0.5 * (titles.count - 1)) / titles.count;
    for (int i = 0; i < titles.count; i++) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake((width + 0.5) * i, kTopMargin, width, kHeaderHeight)];
        [headerView addSubview:view];
        
        CGFloat dataHeight = kHeaderHeight * 0.5;
        UILabel * dataLabel = [Utility createLabel:kFont(20) color:HexRGB(0xea5504)];
        dataLabel.text = datas[i];
        dataLabel.frame = CGRectMake(0, 0, width, dataHeight);
        dataLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:dataLabel];
        [labels addObject:dataLabel];
        
        CGFloat titleY = dataLabel.bottom;
        UILabel * titleLabel = [Utility createLabel:kFont(16) color:HexRGB(0x6a6a6a)];
        titleLabel.text = titles[i];
        titleLabel.frame = CGRectMake(0, titleY, width, kHeaderHeight * 0.5);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:titleLabel];
        
        // 竖线
        if (i < titles.count - 1) {
            UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(width * (i + 1), 20, 0.5, kHeaderHeight)];
            lineView.backgroundColor = HexRGB(0xe2e2e2);
            [headerView addSubview:lineView];
        }
    }
    
    _progressView= [[LTNCircleProgressView alloc] initWithFrame:CGRectMake(0, kTopMargin * 2 + kHeaderHeight, kScreenWidth, kRadius)];
    _progressView.backgroundColor=[UIColor whiteColor];
    [headerView addSubview:_progressView];
    
    // detail的title
    UILabel * detailTitleLabel = [Utility createLabel:kFont(16) color:HexRGB(0x8a8a8a)];
    detailTitleLabel.text = locationString(@"current_account_total");
    [detailTitleLabel sizeToFit];
    detailTitleLabel.centerX = kScreenWidth * 0.5;
    detailTitleLabel.centerY = kCircleCenterY - kRadius * 0.65;
    [headerView addSubview:detailTitleLabel];
    
    // detail的data
    UILabel * detailDataLabel = [Utility createLabel:kFont(40) color:HexRGB(0xea5504)];
    detailDataLabel.text = @"¥150000.00";
    [detailDataLabel sizeToFit];
    detailDataLabel.width = kScreenWidth;
    detailDataLabel.textAlignment = NSTextAlignmentCenter;
    detailDataLabel.center = CGPointMake(kScreenWidth * 0.5, kCircleCenterY - detailDataLabel.height * 0.6);
    [headerView addSubview:detailDataLabel];
    [labels addObject:detailDataLabel];
    
    // detail的n个tag
    NSArray * detailTitles = @[locationString(@"my_current_account_tzqx"), locationString(@"my_current_account_qtje1")];
    NSArray * detailDatas = @[@"23.00", @"23.00"];
    CGFloat detailWidth = kRadius;
    for (int i = 0; i < detailTitles.count; i++) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, detailWidth, kHeaderHeight)];
        view.top = kCircleCenterY;
        if (i == 0) {
            view.right = kScreenWidth * 0.5;
        } else {
            view.left = kScreenWidth * 0.5;
        }
        [headerView addSubview:view];
        
        CGFloat dataHeight = kHeaderHeight * 0.5;
        UILabel * dataLabel = [Utility createLabel:kFont(20) color:HexRGB(0xea5504)];
        dataLabel.text = detailDatas[i];
        dataLabel.frame = CGRectMake(0, 0, view.width, dataHeight);
        dataLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:dataLabel];
        [labels addObject:dataLabel];
        
        CGFloat titleY = dataLabel.bottom;
        UILabel * titleLabel = [Utility createLabel:kFont(16) color:HexRGB(0x8a8a8a)];
        titleLabel.text = detailTitles[i];
        titleLabel.frame = CGRectMake(0, titleY, view.width, kHeaderHeight * 0.5);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:titleLabel];
        
        if (i == 0) {   // 点按手势
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTotalIncome:)];
            [view addGestureRecognizer:tap];
        } else {    // 竖线
            UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth * 0.5, view.top, 0.5, kHeaderHeight)];
            lineView.backgroundColor = HexRGB(0xe2e2e2);
            [headerView addSubview:lineView];
        }
    }
    _labels = [NSArray arrayWithArray:labels];
    
    // 申请转出金额
    UILabel * applyingAmountLabel = [Utility createLabel:kFont(14) color:HexRGB(0x7c7c7c)];
    applyingAmountLabel.text = locationString(@"apply_out_money");
    [applyingAmountLabel sizeToFit];
    applyingAmountLabel.width = kScreenWidth;
    applyingAmountLabel.textAlignment = NSTextAlignmentCenter;
    applyingAmountLabel.center = CGPointMake(kScreenWidth * 0.5, kCircleCenterY + kHeaderHeight + 20);
    [headerView addSubview:applyingAmountLabel];
    _applyingAmountLabel = applyingAmountLabel;
    
    headerView.frame = CGRectMake(0, 0, kScreenWidth, headerView.subviews.lastObject.bottom + 25);
    
    // 转入、转出
    NSArray * actions = @[@{@"title" : locationString(@"current_account_out_title"),
                            @"selName" : @"rollOut",
                            @"color" : HexRGB(0xffc000)},
                          @{@"title" : locationString(@"current_account_in_title"),
                            @"selName" : @"rollIn",
                             @"color" : HexRGB(0xea5504)}];
    CGFloat actionWidth = (kScreenWidth - 3 * 30) / 2.0;
    for (int i = 0; i < actions.count; i++) {
        UIButton * button = [Utility createButtonWithTitle:[actions[i] objectForKey:@"title"] color:[UIColor whiteColor] font:kFont(18) block:^(UIButton *btn) {
            [self performSelector:NSSelectorFromString([actions[i] objectForKey:@"selName"]) withObject:nil afterDelay:0.0f];
        }];
        button.frame = CGRectMake(30 + (actionWidth + 30) * i, headerView.bottom + 22, actionWidth, 44);
        [button setDisenableBackgroundColor:HexRGB(0xcccccc) enableBackgroundColor:[actions[i] objectForKey:@"color"]];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [self.contentView addSubview:button];
        [buttons addObject:button];
    }
    _buttons = buttons;
    
    // 随心投已满提示,此时“转入按钮为灰”
    UILabel * fullPromptLabel = [Utility createLabel:kFont(12) color:[UIColor whiteColor]];
    fullPromptLabel.text = locationString(@"current_is_over") ;
    [fullPromptLabel sizeToFit];
    fullPromptLabel.height += 10;
    fullPromptLabel.width += 20;
    fullPromptLabel.center = CGPointMake(kScreenWidth * 0.5, kMyCurrentDepositCellHeight - kGeneralHeight * 0.5);
    fullPromptLabel.backgroundColor = [UIColor blackColor];
    fullPromptLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:fullPromptLabel];
    _fullPromptLabel = fullPromptLabel;
}

#pragma mark 转入
- (void)rollIn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(myCurrentDepositCellWillRoolIn)]) {
        [self.delegate myCurrentDepositCellWillRoolIn];
    }
}

#pragma mark 转出
- (void)rollOut
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(myCurrentDepositCellWillRoolOut)]) {
        [self.delegate myCurrentDepositCellWillRoolOut];
    }
}

#pragma mark 活期明细
- (void)showTotalIncome:(UIGestureRecognizer *)recognizer
{
//    if (!self.currentDepositInfo.total_income) {
//        [LTNUtilsHelper boxShowWithMessage:@"您目前没有活期收益"];
//        return;
//    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(myCurrentDepositCellWillShowTotalIncome)]) {
        [self.delegate myCurrentDepositCellWillShowTotalIncome];
    }
}

#pragma mark setter
- (void)setCurrentDepositInfo:(LTNMyCurrentDepositModel *)currentDepositInfo
{
    _currentDepositInfo = currentDepositInfo;
    if (!currentDepositInfo) {
        return;
    }
    
    // 年化、万元收益、个人持有、累积收益、昨日收益label
    NSArray * datas = @[currentDepositInfo.annual_income_rate,
                        currentDepositInfo.per_million_income,
                        [NSString stringWithFormat:@"¥%.2f", currentDepositInfo.current_hold_amount],
                        [NSString stringWithFormat:@"¥%.2f", currentDepositInfo.total_income],
                        [NSString stringWithFormat:@"¥%.2f", currentDepositInfo.lastday_income]];
    for (int i = 0; i < _labels.count; i++) {
        UILabel * label = _labels[i];
        label.text = datas[i];
    }
    
    // 转出中label
//    if (currentDepositInfo.applying_extract_amount > 0) {
//        _applyingAmountLabel.hidden = NO;
        NSString * applyingAmount = [NSString stringWithFormat:@"%.2f", currentDepositInfo.applying_extract_amount];
        _applyingAmountLabel.text = [NSString stringWithFormat:locationString(@"out_money"), applyingAmount];
        [_applyingAmountLabel addAttributes:@{NSForegroundColorAttributeName : HexRGB(0xea5504)} forString:applyingAmount];
//    } else {
//        _applyingAmountLabel.hidden = YES;
//    }

    // 转入按钮、转入提示
    BOOL rollInEnable = self.currentDepositInfo.current_remain_amount > 0 ? YES : NO;
    _fullPromptLabel.hidden = rollInEnable;
    [_buttons[1] setEnabled:rollInEnable];

    // 转出按钮
    [_buttons[0] setEnabled:currentDepositInfo.current_hold_amount > 0 ? YES : NO];
    
    // 购买进度
    _progressView.progress = self.currentDepositInfo.current_total_amount > 0 ? (self.currentDepositInfo.current_total_amount - self.currentDepositInfo.current_remain_amount) / self.currentDepositInfo.current_total_amount : 0.75;
    [_progressView setNeedsDisplay];
}

@end
