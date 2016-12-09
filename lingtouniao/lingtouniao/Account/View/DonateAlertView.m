//
//  DonateAlertView.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/11/8.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "DonateAlertView.h"

@implementation DonateAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _alertView = [[UIView alloc] init];
        [self addSubview:_alertView];
        _alertView.layer.cornerRadius = 10.0;
        _alertView.center = self.center;
        _alertView.frame = CGRectMake((kScreenWidth - 300)/2, (kScreenHeight - 227)/2, 300, 227);
        _alertView.backgroundColor = [UIColor whiteColor];
                
        _operateLabel = [[UILabel alloc] init];
        [_alertView addSubview:_operateLabel];
        _operateLabel.text = @"提示";
        _operateLabel.font = kFont(18);
        _operateLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _operateLabel.textAlignment = NSTextAlignmentCenter;
        _operateLabel.frame = CGRectMake(0, 1, _alertView.bounds.size.width, 50);
        
        _cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(_alertView.bounds.size.width - 40, 10, 30, 30)];
        [_alertView addSubview:_cancelButton];
        [_cancelButton setImage:[UIImage imageNamed:@"layer_close"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.tag = 0;
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _operateLabel.bottom, _alertView.bounds.size.width, 0.5)];
        [_alertView addSubview:lineView];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
        
        _messageLabel = [[UILabel alloc]init];
        _messageLabel.font = [UIFont systemFontOfSize:22];
        [_alertView addSubview:_messageLabel];
        _messageLabel.frame = CGRectMake(30, lineView.bottom+10, _alertView.bounds.size.width - 60, 50);
        _messageLabel.textColor = [UIColor colorWithHexString:@"#ff6600"];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        
        _iconView = [[UIImageView alloc]init];
        [_alertView addSubview:_iconView];
        _iconView.image = [UIImage imageNamed:@"icon_success"];
        _iconView.frame = CGRectMake(30, lineView.bottom + 15, 30, 30);
        
        _succeessLabel = [[UILabel alloc]init];
        [_alertView addSubview:_succeessLabel];
        _succeessLabel.font = kFont(22);
        _succeessLabel.frame = CGRectMake(_iconView.right +10, lineView.bottom + 10, _alertView.bounds.size.width - 20, 40);
        _succeessLabel.textColor = [UIColor colorWithHexString:@"#ff6600"];
        
        _detailLabel = [[UILabel alloc]init];
        [_alertView addSubview:_detailLabel];
        _detailLabel.frame = CGRectMake(30, _messageLabel.bottom, _alertView.bounds.size.width - 60, 50);
        _detailLabel.font = kFont(15);
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        _detailLabel.numberOfLines = 0;
        
        _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake((_alertView.bounds.size.width - 180)/2, _detailLabel.bottom+10 , 180, 40)];
        [_alertView addSubview:_confirmButton];
        _confirmButton.tag = 1;
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton setTitle:@"复制" forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = kFont(16);
        [_confirmButton setBackgroundColor:[UIColor colorWithHexString:@"#ff6600"]];
        [_confirmButton addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.layer.masksToBounds = YES;
        _confirmButton.layer.cornerRadius = 3;
        
    }
    return self;
    
}

- (void)didClickBtn:(UIButton *)btn{
    [self.delegate ButtonDidCilcked:btn];
    [_alertView removeFromSuperview];
    [self removeFromSuperview];
}


@end
