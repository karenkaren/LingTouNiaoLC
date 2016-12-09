//
//  LTNBaseOfflineController.h
//  lingtouniao
//
//  Created by LiuFeifei on 16/2/22.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LTNBaseOfflineController : BaseTableViewController

@property (nonatomic) NSString *status;

- (void)refreshIfNeeded;

@end
