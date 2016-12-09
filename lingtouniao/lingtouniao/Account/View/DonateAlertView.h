//
//  DonateAlertView.h
//  lingtouniao
//
//  Created by 郑程锋 on 16/11/8.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol copyButtonClickDelegate <NSObject>

-(void)ButtonDidCilcked:(UIButton *)btn;

@end

@interface DonateAlertView : UIView

//创建提示框View
@property (nonatomic) UIView *alertView;

//提示Label
@property (nonatomic) UILabel *operateLabel;

//券码Label
@property (nonatomic) UILabel *messageLabel;

//说明Label
@property (nonatomic) UILabel *detailLabel;

//取消按钮
@property (nonatomic) UIButton *cancelButton;

//复制按钮
@property (nonatomic) UIButton *confirmButton;

//icon
@property (nonatomic) UIImageView *iconView;

//成功label
@property (nonatomic) UILabel *succeessLabel;

@property (nonatomic) id <copyButtonClickDelegate> delegate;

- ( instancetype )initWithFrame:(CGRect)frame;

@end
