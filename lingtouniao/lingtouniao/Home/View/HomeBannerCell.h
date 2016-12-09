//
//  HomeBannerCell.h
//  lingtouniao
//
//  Created by LiuFeifei on 16/5/23.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTNBannerView.h"

#define kBannerCellHeight DimensionBaseIphone6(110)

@protocol HomeBannerCellDelegate <NSObject>

- (void)clickBannerView:(LTNBannerView *)bannerView banner:(LTNBanner *)banner;

@end

@interface HomeBannerCell : UITableViewCell

@property (nonatomic, weak) id<HomeBannerCellDelegate> delegate;
@property (nonatomic, strong) id data;

@end
