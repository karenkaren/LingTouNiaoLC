//
//  RepalceSuccessViewController.h
//  lingtouniao
//
//  Created by 徐凯 on 16/4/1.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "BaseViewController.h"

@interface RepalceSuccessViewController : BaseViewController
@property (nonatomic,copy) NSString *titleString;//题目
@property (nonatomic,copy) NSString *statusString;////成功还是失败的描述
@property (nonatomic,copy) NSString *desString;//说明的描述


@property (weak, nonatomic) IBOutlet UILabel *statusLabel;//成功还是失败的描述
@property (weak, nonatomic) IBOutlet UILabel *desLabel;//说明的描述


@end
