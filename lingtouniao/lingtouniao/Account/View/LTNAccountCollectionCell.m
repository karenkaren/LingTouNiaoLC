//
//  LTNAccountCollectionCell.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/5/23.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNAccountCollectionCell.h"

@implementation LTNAccountCollectionCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat pointWidth = 6;
        CGFloat pointHeight = pointWidth;
        UIButton * pointButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, pointWidth, pointHeight)];
        //pointButton.right = self.contentView.width;
        pointButton.centerY = 20.0f;
        pointButton.right=kScreenWidth/2-24.0f;
        pointButton.backgroundColor = [UIColor redColor];
        pointButton.layer.cornerRadius = pointWidth * 0.5;
        [self.contentView addSubview:pointButton];
        self.pointButton = pointButton;
        self.pointButton.hidden=YES;
        
        //图片
        _img = [[UIImageView alloc]initWithFrame:CGRectMake(15, 17.5, 25, 25)];
        [self.contentView addSubview:_img];
        
        //标题
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_img.right + 10, 10, kScreenWidth/2 - _img.right - 10, 20)];
        _titleLabel.font = kFont(15);
        [self.contentView addSubview:_titleLabel];
        
        //详情
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(_img.right + 10, _titleLabel.bottom+5, kScreenWidth/2 - _img.right - 10, 20)];
        _detailLabel.font = kFont(11);
        [self.contentView addSubview:_detailLabel];
        
        
        
        UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2-0.5, 0, 0.5, 60)];
        line3.backgroundColor =[UIColor colorWithHexString:@"#e5e5e5"];
        [self.contentView addSubview:line3];
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
        line1.backgroundColor =[UIColor colorWithHexString:@"#e5e5e5"];
        [self.contentView addSubview:line1];
        self.line1 = line1;
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 59.5, self.frame.size.width, 0.5)];
        line2.backgroundColor =[UIColor colorWithHexString:@"#e5e5e5"];
        [self.contentView addSubview:line2];
        self.line2 = line2;
        
        
        
    }
    return self;
}

@end
