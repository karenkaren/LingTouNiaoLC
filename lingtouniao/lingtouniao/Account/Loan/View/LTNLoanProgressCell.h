//
//  LTNLoanProgressCell.h
//  lingtouniao
//
//  Created by LiuFeifei on 16/3/25.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLoanProgressCellHeight 82

@interface LTNLoanProgressCell : UITableViewCell

@property (nonatomic, assign) BOOL hiddenBottomLine;
@property (nonatomic, strong) id data;

@end
