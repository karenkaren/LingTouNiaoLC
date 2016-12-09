//
//  LTNAccountController.h
//  lingtouniao
//
//  Created by LiuFeifei on 15/11/11.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTNLoginController.h"
#import "BaseTableViewController.h"
#import "LTNMyTaskController.h"

@interface LTNAccountController : BaseTableViewController

-(LTNMyTaskController *)showMyTaskWithAnimated:(BOOL)animated;

@end
