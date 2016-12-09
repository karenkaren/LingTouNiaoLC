//
//  SecondBoundBandCardViewController.h
//  lingtouniao
//
//  Created by LiuFeifei on 16/5/3.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "BaseTableViewController.h"

@interface SecondBoundBandCardViewController : BaseTableViewController

@property(nonatomic,assign) BOOL isCompleteAction;//完成绑卡
@property (nonatomic,copy) VoidBlock finishBlock;
@property (strong, nonatomic) UITextField * selectBankField;//请选择银行
@property (strong, nonatomic) UITextField * cardIdTextField;//银行卡号

@end
