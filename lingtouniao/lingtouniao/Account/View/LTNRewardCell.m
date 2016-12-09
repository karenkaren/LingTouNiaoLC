//
//  LTNRewardCell.m
//  lingtouniao
//
//  Created by 郑程锋 on 15/12/28.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//
#define kSide 20
#define kWidth kScreenWidth/3
#import "LTNRewardCell.h"

@interface LTNRewardCell ()

@property (nonatomic) UILabel *inviteLabel;
@property (nonatomic) UILabel *investLabel;
@property (nonatomic) UILabel *rewardlabel;

@end

@implementation LTNRewardCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}
-(void)configUI{
    
    _inviteLabel=[Utility createLabel:[CustomerizedFont heiti:16] color:[UIColor grayColor]];
    _investLabel=[Utility createLabel:[CustomerizedFont heiti:16] color:[UIColor grayColor]];
    _rewardlabel=[Utility createLabel:[CustomerizedFont heiti:16] color:[UIColor grayColor]];
    NSArray *labels =@[_inviteLabel,_investLabel,_rewardlabel];
    for (int i=0; i<labels.count; i++) {
        UILabel *label=labels[i];
        label.frame=CGRectMake(kSide+i*kWidth, 0, kWidth, kGeneralHeight);
        [self.contentView addSubview:label];
    }
}
-(void)setModel:(LTNRewardModel *)model{
    _model = model;
    
    NSString *mobile = model.mobileNo;
    if (mobile.length == 11) {
        mobile = [mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    self.inviteLabel.text = mobile;
    self.investLabel.text = [NSString stringWithFormat:@"%.2f",model.reward.floatValue];
    self.rewardlabel.text = [NSString stringWithFormat:@"%.2f",model.orderReward.floatValue];
}
@end
