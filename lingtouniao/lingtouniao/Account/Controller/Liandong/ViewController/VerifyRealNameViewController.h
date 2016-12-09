//
//  VerifyRealNameViewController.h
//  lingtouniao
//
//  Created by 徐凯 on 15/12/23.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "BaseViewController.h"

@interface VerifyRealNameViewController : BaseViewController

@property (nonatomic, copy)VoidBlock finishVerifyRealNameBlock;

@property(nonatomic,assign)BOOL isCompleteAction;


+(instancetype)verifyRealNameControllerWithFinishBlock:(VoidBlock)finishVerifyRealNameBlock;



@end
