//
//  LTNTransferViewController.h
//  lingtouniao
//
//  Created by 郑程锋 on 16/11/15.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LTNTransferViewController : BaseTableViewController

@property (nonatomic) NSInteger productId;
@property(nonatomic,copy) NSString *transferTitle;
@property(nonatomic,assign) double transferoOrderAmount;

@end
