//
//  LTNMyCurrentDepositController.h
//  lingtouniao
//
//  Created by LiuFeifei on 16/1/20.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "BaseTableViewController.h"

@protocol LTNMyCurrentDepositControllerDelegate <NSObject>

- (void)refreshMyCurrentDepositWithRemainAmount:(double)remainAmount;

@end

@interface LTNMyCurrentDepositController : BaseTableViewController

@property (nonatomic, weak) id<LTNMyCurrentDepositControllerDelegate> delegate;

@end
