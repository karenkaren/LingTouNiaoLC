//
//  BoundBankCell.h
//  lingtouniao
//
//  Created by LiuFeifei on 16/5/4.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBoundBankCellHeight 50

@interface BoundBankCell : UITableViewCell

@property (nonatomic,strong) NSDictionary * cellDic;
@property (nonatomic,strong) UITextField * textField;

@end
