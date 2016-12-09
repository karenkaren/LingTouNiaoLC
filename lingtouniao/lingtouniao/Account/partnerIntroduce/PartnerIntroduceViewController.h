//
//  PartnerIntroduceViewController.h
//  lingtouniao
//
//  Created by zhangtongke on 16/4/7.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "BaseViewController.h"

@interface PartnerIntroduceViewController : BaseViewController
@property (nonatomic,copy)void(^viewDetailBlock)(void);
+(void)showPartnerIntroduceViewController:(void (^)(void))viewDetailBlock;
@end
