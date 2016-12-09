//
//  LTNMyCurrentDepositCell.h
//  lingtouniao
//
//  Created by LiuFeifei on 16/1/20.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTNMyCurrentDepositModel.h"

#define kMyCurrentDepositCellHeight (kScreenHeight - SYSTEM_NAVIGATION_HEIGHT - StatusBarHeight)

@protocol LTNMyCurrentDepositCellDelegate <NSObject>

@optional
- (void)myCurrentDepositCellWillRoolIn;
- (void)myCurrentDepositCellWillRoolOut;
- (void)myCurrentDepositCellWillShowTotalIncome;

@end

@interface LTNMyCurrentDepositCell : UITableViewCell

@property (nonatomic, weak) id<LTNMyCurrentDepositCellDelegate> delegate;
@property (nonatomic, strong) LTNMyCurrentDepositModel * currentDepositInfo;

@end
