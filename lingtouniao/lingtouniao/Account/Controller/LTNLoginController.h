//
//  LTNLoginController.h
//  lingtouniao
//
//  Created by LiuFeifei on 15/11/11.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "BaseViewController.h"


@interface LTNLoginController : BaseViewController


///nontomic

@property (nonatomic,copy)VoidBlock finishLoginBlock;

// 通过手势密码认证跳转有问题，临时变量 ，bug 注册后手势密码的跳转
@property (nonatomic)BOOL ShouldSetGesturePassword;

+(instancetype)loginControllerWithFinishBlock:(VoidBlock)finishLoginBlock;

@end
