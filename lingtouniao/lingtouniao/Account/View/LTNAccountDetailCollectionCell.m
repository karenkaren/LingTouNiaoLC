//
//  LTNAccountDetailCollectionCell.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/5/23.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNAccountDetailCollectionCell.h"

@implementation LTNAccountDetailCollectionCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(5, 10, (kScreenWidth - 20)/2, 60)];
//        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(15, 15, (kScreenWidth - 60)/2, 60)];
        UIView *view1 = [[UIView alloc]init];
        view1.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:view1];
        self.view1 = view1;
        
        view1.layer.cornerRadius = 1;
        view1.layer.masksToBounds = YES;
        view1.layer.borderWidth = 0.5;
        view1.layer.borderColor = [UIColor colorWithHexString:@"#e5e5e5"].CGColor;
        
        //图片
        _img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 30, 30)];
        [view1 addSubview:_img];
        
        //标题
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_img.right+5, 10, 65, 20)];
        _titleLabel.font = kFont(16);
        _titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        [view1 addSubview:_titleLabel];
        
        //我的任务进度
       // _taskSchedul = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.right , 8, (kScreenWidth - 20)/2 - _titleLabel.right - 15, 22)];
        _taskSchedul = [[UILabel alloc]init];
        _taskSchedul.layer.cornerRadius = 8;
        _taskSchedul.layer.masksToBounds = YES;
        _taskSchedul.layer.borderColor = HexRGB(0xea5504).CGColor;
        _taskSchedul.layer.borderWidth = 1;
        _taskSchedul.backgroundColor = HexRGB(0xea5504);
        _taskSchedul.textColor = [UIColor whiteColor];
        _taskSchedul.textAlignment = NSTextAlignmentCenter;
        _taskSchedul.font = [CustomerizedFont heiti:11];
        [view1 addSubview:_taskSchedul];
        
        //详情
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(_img.right + 5, _titleLabel.bottom + 5,(kScreenWidth - 20)/2 - _img.right - 10, 20)];
        _detailLabel.font = kFont(12);
        _detailLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        [view1 addSubview:_detailLabel];
        
//        _lineView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 2, 20)];
//        _lineView.image = [UIImage imageNamed:@"icon_shuxian"];
//        [view1 addSubview:_lineView];
        
        
    }
    return self;
}

@end
