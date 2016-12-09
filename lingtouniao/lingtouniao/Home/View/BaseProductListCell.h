//
//  BaseProductListCell.h
//  lingtouniao
//
//  Created by LiuFeifei on 16/5/26.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTNProduct.h"
#import "LTNBarProgressView.h"

#define kSide DimensionBaseIphone6(24)
#define kMargin DimensionBaseIphone6(15)
#define kBaseProductListCellHeight (225 * 0.5)//+16
#define kProductListCellWidth [UIScreen mainScreen].bounds.size.width

@interface BaseProductListCell : UITableViewCell

@property (nonatomic, strong) LTNProduct * product;
@property (nonatomic,strong)UIView * backView;
@property (nonatomic, strong) LTNBarProgressView *progressView;
@property (nonatomic, strong) UIView * footerLineView;

- (void)addAllSubviews;

@end
