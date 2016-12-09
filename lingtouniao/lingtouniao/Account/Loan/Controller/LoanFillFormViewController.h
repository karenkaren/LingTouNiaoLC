//
//  LoanFillFormViewController.h
//  lingtouniao
//
//  Created by zhangtongke on 16/3/31.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LoanFillFormViewController : BaseTableViewController
@property (nonatomic,strong)NSDictionary *loanTypeDic;
+(instancetype)loanFillFormViewController:(NSDictionary *)loanTypeDic;
@end
