//
//  HomeBannerCell.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/5/23.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "HomeBannerCell.h"

@interface HomeBannerCell ()<LTNBannerViewDelegate>

@property (nonatomic, strong) LTNBannerView * bannerView;

@end

@implementation HomeBannerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.bannerView = [[LTNBannerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kBannerCellHeight)];
        [self addSubview:self.bannerView];
    }
    return self;
}

- (void)setData:(id)data
{
    _data = data;
    if (data && isArray(data)) {
        self.bannerView.bannersList = (NSArray *)data;
        self.bannerView.delegate = self;
    }
}

- (void)bannerView:(LTNBannerView *)bannerView banner:(LTNBanner *)banner
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickBannerView:banner:)]) {
        [self.delegate clickBannerView:bannerView banner:banner];
    }
}

@end
