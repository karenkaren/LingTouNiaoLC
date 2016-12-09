//
//  FinancialIntroduceViewController.h
//  lingtouniao
//
//  Created by 郑程锋 on 16/11/24.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "BaseViewController.h"

@interface FinancialIntroduceViewController : BaseViewController

@property (nonatomic,copy)void(^viewDetailBlock)(void);

+(void)showFinancialIntroduceViewController:(void (^)(void))viewDetailBlock;

@end
