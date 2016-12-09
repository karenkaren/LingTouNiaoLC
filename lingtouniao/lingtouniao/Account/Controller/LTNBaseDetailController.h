//
//  LTNBaseDetailController.h
//  lingtouniao
//
//  Created by LiuFeifei on 15/12/25.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LTNBaseDetailController : BaseTableViewController

@property (nonatomic, copy) NSString * naviTitle;
@property (nonatomic, copy) NSString * apiPath;
@property (nonatomic, strong) NSDictionary * extraParams;
@property (nonatomic) BOOL isHaveBiedCoinHelp;
- (void)refreshIfNeeded;

@end
