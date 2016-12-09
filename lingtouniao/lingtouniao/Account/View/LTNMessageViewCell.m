//
//  LTNMessageViewCell.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/3/14.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNMessageViewCell.h"
#import "UIImageView+WebCache.h"

#define kSide 5

@interface LTNMessageViewCell ()



@end

@implementation LTNMessageViewCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self congfiUI];
        self.backgroundColor = [UIColor colorWithHexString:@"#f3f5f7"];
    }
    return self;
}

-(void)congfiUI{
    self.backView = [[UIView alloc]init];
    [self.contentView addSubview:self.backView];
    self.backView.backgroundColor = [UIColor whiteColor];
    self.backView.layer.cornerRadius = 10;
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.borderWidth = 1;
    self.backView.layer.borderColor = [UIColor colorWithHexString:@"#E2E2E2"].CGColor;
    
    self.titleLabel = [Utility createLabel:[CustomerizedFont heiti:16] color:[UIColor colorWithHexString:@"#3A3A3A"]];
    [self.backView addSubview:self.titleLabel];
    self.titleLabel.numberOfLines = 0;
    
    
    self.dateLabel = [Utility createLabel:[CustomerizedFont heiti:12] color:[UIColor colorWithHexString:@"#3A3A3A"]];
    [self.backView addSubview:self.dateLabel];
    self.dateLabel.numberOfLines = 0;
    
    
    self.contentLabel = [Utility createLabel:[CustomerizedFont heiti:14] color:[UIColor colorWithHexString:@"#3A3A3A"]];
    [self.backView addSubview:self.contentLabel];
    self.contentLabel.numberOfLines = 0;

    
   
    
    self.uplineView = [[UIView alloc]init];
    [self.contentView addSubview:self.uplineView];
    self.uplineView.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    
    self.downlineView = [[UIView alloc]init];
    [self.contentView addSubview:self.downlineView];
    self.downlineView.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    
    self.circleView = [[UIView alloc]init];
    [self.contentView addSubview:self.circleView];
    self.circleView.layer.cornerRadius = 4.5;
    self.circleView.layer.masksToBounds = YES;
    
}

- (void)reloadModel:(LTNMessageModel *)messageModel{
    
    if([messageModel.isRead isEqualToString:@"1"]){
       self.circleView.backgroundColor = [UIColor colorWithHexString:@"E2E2E2"];
    }else{
       self.circleView.backgroundColor = [UIColor colorWithHexString:@"EA5504"];
        messageModel.isRead=@"1";
    }
    
    self.titleLabel.text = messageModel.title;
    self.contentLabel.text = messageModel.content;
    [self.contentLabel sizeToFit];
    self.dateLabel.text = messageModel.createDate;
    
    
    self.titleLabel.frame = CGRectMake(10, 10, kScreenWidth - 67, 22);
    self.dateLabel.frame = CGRectMake(10, self.titleLabel.bottom + 4, kScreenWidth -  67, 22);
    
    CGSize maxSize = CGSizeMake(kScreenWidth - 83, MAXFLOAT);
    CGSize fitSize = [self.contentLabel sizeThatFits:maxSize];
    self.contentLabel.frame = CGRectMake(10, self.dateLabel.bottom+6, kScreenWidth- 83, fitSize.height);

    
    self.backView.frame = CGRectMake(51, 15, kScreenWidth-67, CGRectGetMaxY(self.contentLabel.frame)+5);
    self.circleView.frame = CGRectMake(15.5, self.backView.bottom/2, 9, 9);
    self.uplineView.frame = CGRectMake(20, 0, 0.5, self.backView.bottom/2);
    self.downlineView.frame = CGRectMake(20, self.circleView.bottom, 0.5, self.backView.bottom/2);
    self.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(self.backView.frame));

}

- (void)reloadModel:(LTNMessageModel *)messageModel Index:(NSInteger)Index withCount:(NSInteger)count{
    if (Index == count - 1) {
        // 隐藏最下面那根线
        self.downlineView.hidden = YES;
    }else{
        
        self.downlineView.hidden = NO;
    }
    [self reloadModel:messageModel];
}


+ (CGFloat)heightForModel:(LTNMessageModel *)messageModel {
    
    CGFloat height = 15;
    height += 10 + 22 + 4 + 22 + 6 + 10;
    
    static UILabel *label;
    if (!label) {
        label = [Utility createLabel:[CustomerizedFont heiti:14] color:nil];
        label.numberOfLines = 0;
    }
    label.text = messageModel.content;
    CGSize maxSize = CGSizeMake(kScreenWidth - 83, MAXFLOAT);
    CGSize fitSize = [label sizeThatFits:maxSize];
    
    return ceilf(height + fitSize.height);
}

@end
