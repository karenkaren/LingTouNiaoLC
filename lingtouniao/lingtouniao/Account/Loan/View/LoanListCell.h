//
//  LoanListCell.h
//  lingtouniao
//
//  Created by zhangtongke on 16/3/29.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoanListCell : UITableViewCell
@property (nonatomic,strong)NSDictionary *loanDic;
@property (nonatomic,copy)void(^loanBlock)(NSDictionary *loanDic);
@end
