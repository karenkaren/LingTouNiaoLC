//
//  CooperationHeaderCell.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/9/24.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "CooperationHeaderCell.h"

@interface CooperationHeaderCell ()

@property (nonatomic, strong) CooperationHeaderView * cooperationHeaderView;

@end

@implementation CooperationHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CooperationHeaderView * view = [[CooperationHeaderView alloc] init];
        [self.contentView addSubview:view];
        self.cooperationHeaderView = view;
    }
    return self;
}

- (void)setData:(id)data
{
    _data = data;
    self.cooperationHeaderView.data = data;
}

@end
