//
//  PayButton.m
//  lingtouniao
//
//  Created by 徐凯 on 15/12/18.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "PayButtonView.h"
#import "Masonry.h"

@implementation PayButtonView

-(id)init
{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth * 49 / 320.0);
        self.backgroundColor = BACKGROUND_COLOR;
        
        _payLabel = [[UILabel alloc]init];
        _payLabel.backgroundColor = [UIColor whiteColor];
        _payLabel.text = locationString(@"actually_pay");
        _payLabel.font = [UIFont systemFontOfSize:18];
        [self addSubview:_payLabel];
        
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _payButton.backgroundColor = [UIColor colorWithHexString:@"#ea5504"];
        [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_payButton setTitle:locationString(@"btn_confirm_yes") forState:UIControlStateNormal];
        // _payButton..titleLabel.font = [UIFont systemFontOfSize:18];
        [self addSubview:_payButton];

        [_payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.equalTo(self);
            make.width.mas_equalTo(kScreenWidth/3*2);
        }];
        
        [_payButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self);
            make.width.mas_equalTo(kScreenWidth/3);
        }];
                
    }
    return  self;
}

@end
