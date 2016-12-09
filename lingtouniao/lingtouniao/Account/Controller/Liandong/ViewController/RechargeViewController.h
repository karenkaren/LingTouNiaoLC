//
//  RechargeViewController.h
//  lingtouniao
//
//  Created by 徐凯 on 15/12/24.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "BaseViewController.h"

@interface RechargeViewController : BaseViewController

@property(nonatomic,assign)BOOL isCompleteAction;

@property(nonatomic,copy)NSString *resultAmount;

-(id)initWithRechargeMoney:(double)rechargeMoney;

@end
