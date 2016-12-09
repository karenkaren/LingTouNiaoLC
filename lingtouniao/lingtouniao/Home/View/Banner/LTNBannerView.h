//
//  LTNBannerView.h
//  横幅
//
//  Created by LiuFeifei on 15/11/16.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTNBanner.h"

@class LTNBannerView;
@protocol LTNBannerViewDelegate <NSObject>

@optional
- (void)bannerView:(LTNBannerView *)bannerView banner:(LTNBanner *)banner;

@end

@interface LTNBannerView : UIView

@property (nonatomic, weak) id<LTNBannerViewDelegate> delegate;
@property (nonatomic, strong) NSArray * bannersList;

@end
