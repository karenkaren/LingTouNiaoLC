//
//  LTNOfflineTitleCell.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/2/22.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNOfflineTitleCell.h"

@implementation LTNOfflineTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.font = [CustomerizedFont heiti:16];
        self.textLabel.textColor = [UIColor colorWithHex:0x3a3a3a alpha:1];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.left = 20;
}

@end
