//
//  LTNRegisterController.h
//  lingtouniao
//
//  Created by LiuFeifei on 15/11/11.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "AppDelegate.h"

@interface LTNRegisterController : UIViewController
@property (nonatomic,copy)VoidBlock finishRegisterBlock;

+(instancetype)registerControllerWithFinishBlock:(VoidBlock)finishRegisterBlock;

@end