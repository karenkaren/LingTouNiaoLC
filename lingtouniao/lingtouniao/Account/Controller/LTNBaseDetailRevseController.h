//
//  LTNBaseDetailRevseController.h
//  lingtouniao
//
//  Created by 郑程锋 on 16/3/24.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LTNBaseDetailRevseController : BaseTableViewController

@property (nonatomic, copy) NSString * naviTitle;
@property (nonatomic, copy) NSString * apiPath;
@property (nonatomic, strong) NSDictionary * extraParams;

- (void)refreshIfNeeded;

@end
