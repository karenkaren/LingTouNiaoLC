//
//  ReplceFailureViewController.h
//  lingtouniao
//
//  Created by 徐凯 on 16/4/1.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "BaseViewController.h"

@interface ReplceFailureViewController : BaseViewController

@property (nonatomic) NSString *reasonString;//失败的原因
@property (nonatomic) NSString *buttonTitle;//
@property (nonatomic,assign) NSInteger type;//哪一种失败
@property (weak, nonatomic) IBOutlet UILabel *failureDesLabel;

@end
