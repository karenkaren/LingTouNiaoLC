//
//  UITableViewCell.h
//  lingtouniao
//
//  Created by LiuFeifei on 15/12/10.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTNProduct.h"

#define kProductDetailCellHeight DimensionBaseIphone6(300)
#define kProductDetailVirtualHeight DimensionBaseIphone6(400)
#define kProductDetailCellWidth [UIScreen mainScreen].bounds.size.width

@interface LTNProductDetailCell : UITableViewCell

@property (nonatomic, strong) LTNProduct * product;

@end
