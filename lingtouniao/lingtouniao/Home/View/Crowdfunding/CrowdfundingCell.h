//
//  CrowdfundingCell.h
//  lingtouniao
//
//  Created by LiuFeifei on 16/9/21.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CrowdfundingModel.h"

#define kCrowdfundingCellHeight DimensionBaseIphone6(155)

@interface CrowdfundingCell : UITableViewCell

@property (nonatomic, strong) id data;
@property (nonatomic, assign) BOOL hideTopLine;

@end
