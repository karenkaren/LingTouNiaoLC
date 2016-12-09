//
//  LTNBaseStatisticsController.h
//  lingtouniao
//
//  Created by LiuFeifei on 16/3/17.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LTNBaseStatisticsController : BaseTableViewController

@property (nonatomic, copy) NSString * naviTitle;
@property (nonatomic, copy) NSString * apiPath;
@property (nonatomic, strong) NSDictionary * extraParams;

@property (nonatomic, strong) NSArray * colors;
@property (nonatomic, copy) NSString * centerText;

- (void)refreshIfNeeded;

@end
