//
//  EditAddressInfoView.h
//  lingtouniao
//
//  Created by 郑程锋 on 16/11/3.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTNAddressModel.h"
#import "LTNUtilsHelper.h"
#import "LTNTextField.h"

@interface EditAddressInfoView : UIView

@property (nonatomic) LTNAddressModel *model;

@property (nonatomic) UILabel *nameLab;
@property (nonatomic) UITextField *nameTextField;//收货人姓名

@property (nonatomic) UILabel *phoneLab;
@property (nonatomic) LTNTextField *phoneTextField;//收货人手机号

@property (nonatomic) UILabel *addressLab;
@property (nonatomic) UITextField *selectAddress;//所在地区

@property (nonatomic) UITextField *detailAddressText;//详细地址



@end
