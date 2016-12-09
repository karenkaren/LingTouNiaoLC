//
//  SGSheetViewCell.h
//  lingtouniao
//
//  Created by 徐凯 on 16/1/9.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGSheetViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

-(void)setTitleLabel:(NSString *)title withDescLabel:(NSString *)desc withDateLabel:(NSString *)date;

@end
