//
//  LTNAddPartnerViewController.h
//  lingtouniao
//
//  Created by 郑程锋 on 15/12/29.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "BaseViewController.h"

@interface LTNAddPartnerViewController : BaseViewController

@property (nonatomic,copy)VoidBlock finishBlock;

+(instancetype)addPartnerViewController:(VoidBlock)finishBlock;

@end
