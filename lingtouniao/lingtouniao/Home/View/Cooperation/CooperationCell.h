//
//  CooperationCell.h
//  lingtouniao
//
//  Created by LiuFeifei on 16/9/21.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CooperationModel.h"

#define kCooperationCellHeight DimensionBaseIphone6(210)

@interface CooperationCell : UITableViewCell

@property (nonatomic, strong) CooperationModel * data;
@property (nonatomic, assign) BOOL hideJoin;

@end
