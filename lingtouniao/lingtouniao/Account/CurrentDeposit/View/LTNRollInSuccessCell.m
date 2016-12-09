//
//  LTNRollInSuccessCell.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/4/5.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNRollInSuccessCell.h"

@interface LTNRollInSuccessCell ()

@property (nonatomic, strong) NSDictionary * weekdayDic;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, assign) CGFloat titleLeft;
@property (nonatomic, assign) CGFloat titleCenterY;

@end

@implementation LTNRollInSuccessCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.weekdayDic = @{@"1" : locationString(@"sunday"), @"2" : locationString(@"monday"), @"3" : locationString(@"tuesday"), @"4" : locationString(@"wednesday"), @"5" : locationString(@"thursday"), @"6" : locationString(@"friday"), @"7" : locationString(@"saturday")};
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    NSArray * images = @[[UIImage imageNamed:@"ic_success_green"], [UIImage imageNamed:@"ic_success_gray"], [UIImage imageNamed:@"ic_success_gray"]];
    NSString * title1 = [NSString stringWithFormat:locationString(@"current_buy_success"), self.rollInAmount];
    
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents * comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit;
    NSDate * todayDate = [NSDate date];
    comps = [calendar components:unitFlags fromDate:todayDate];
    NSString * todayWeekday = self.weekdayDic[[NSString stringWithFormat:@"%ld", [comps weekday]]];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * today = [formatter stringFromDate:todayDate];

    NSString * title2 = [NSString stringWithFormat:locationString(@"today_date_and_week"), today, todayWeekday];
    
    comps.day++;
    comps.weekday++;
    NSDate * tomorrowDate = [calendar dateFromComponents:comps];
    NSString * tomorrowWeekday = self.weekdayDic[[NSString stringWithFormat:@"%ld", [comps weekday]]];
    NSString * tomorrow = [formatter stringFromDate:tomorrowDate];
    NSString * title3 = [NSString stringWithFormat:@"%@ %@", tomorrow, tomorrowWeekday];
    NSArray * titles = @[title1, title2, title3];
    
    NSArray * details = @[locationString(@"today"), locationString(@"calculate_revenue"), locationString(@"get_revenue")];
    
    CGFloat margin = 22;
    CGFloat height = (kRollInSuccessCellHeight - margin) / 3.0;
    for (int i = 0; i < 3; i++) {

        UIImageView * icon = [[UIImageView alloc] initWithImage:images[i]];
        icon.left = 25;
        icon.top = margin + i * height;
        [self.contentView addSubview:icon];
        
        UILabel * titleLabel = [Utility createLabel:[CustomerizedFont heiti:16] color:HexRGB(0x8a8a8a)];
        titleLabel.text = titles[i];
        [titleLabel sizeToFit];
        titleLabel.left = icon.right + 10;
        titleLabel.centerY = icon.centerY;
        [self.contentView addSubview:titleLabel];
        
        UILabel * detailLabel = [Utility createLabel:[CustomerizedFont heiti:16] color:HexRGB(0x8a8a8a)];
        detailLabel.text = details[i];
        [detailLabel sizeToFit];
        detailLabel.left = titleLabel.left;
        detailLabel.top = titleLabel.bottom + 5;
        [self.contentView addSubview:detailLabel];
        
        if (i == 0) {
            self.titleLabel = titleLabel;
            self.titleLeft = titleLabel.left;
            self.titleCenterY = titleLabel.centerY;
        }
        
        if (i == 2) {
            break;
        }
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(icon.centerX - 1, icon.bottom, 2, height - icon.height)];
        lineView.backgroundColor = HexRGB(0xe2e2e2);
        [self.contentView addSubview:lineView];
    }
}

- (void)setRollInAmount:(double)rollInAmount
{
    _rollInAmount = rollInAmount;
    NSString * title = [NSString stringWithFormat:locationString(@"current_buy_success"), rollInAmount];
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
    self.titleLabel.left = self.titleLeft;
    self.titleLabel.centerY = self.titleCenterY;
    if (self.titleLabel.width + self.titleLabel.left + 10 > kScreenWidth) {
        self.titleLabel.width = kScreenWidth - self.titleLabel.left - 10;
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
    }
}

@end
