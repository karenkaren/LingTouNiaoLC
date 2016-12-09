//
//  EditAddressInfoView.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/11/3.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "EditAddressInfoView.h"
#import "AddressPickerView.h"

@interface EditAddressInfoView ()<UITextFieldDelegate>

@property (nonatomic) AddressPickerView *addressPickerView;

@end

@implementation EditAddressInfoView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self configUi];
    }
    return self;
}

-(void)configUi{
    
    self.nameLab = [[UILabel alloc]init];
    self.nameLab.font = kFont(16);
    self.nameLab.text = locationString(@"getGoodsPerson");
    self.nameLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [self addSubview:self.nameLab];
    
    self.nameTextField = [[UITextField alloc]init];
    self.nameTextField.placeholder = locationString(@"writeGoodsName");
    self.nameTextField.text = [CurrentUser mine].userInfo.userName;
    self.nameTextField.font = kFont(16);
    self.nameTextField.textColor = [UIColor colorWithHexString:@"#999999"];
    [self addSubview:self.nameTextField];
    
    UIView *lineOne = [[UIView alloc]init];
    lineOne.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [self addSubview:lineOne];
    
    self.phoneLab = [[UILabel alloc]init];
    self.phoneLab.font = kFont(16);
    self.phoneLab.text = locationString(@"phoneNumber");
    self.phoneLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [self addSubview:self.phoneLab];
    
    self.phoneTextField = [[LTNTextField alloc]init];
    self.phoneTextField.delegate = self;
    [self.phoneTextField addClearButtonWithRightMargin:0 imageName:nil];
    self.phoneTextField.placeholder = locationString(@"writeGoodsPhoneNum");
    self.phoneTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUserNameKey];
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTextField.limitedCount = 11;
    self.phoneTextField.font = kFont(16);
    self.phoneTextField.textColor = [UIColor colorWithHexString:@"999999"];
    [self addSubview:self.phoneTextField];
    
    UIView *lineTwo = [[UIView alloc]init];
    lineTwo.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [self addSubview:lineTwo];
    
    UIView *selectAddressView = [[UIView alloc]init];
    [self addSubview:selectAddressView];
    
    self.addressLab = [[UILabel alloc]init];
    self.addressLab.font = kFont(16);
    self.addressLab.text = locationString(@"ownAreas");
    self.addressLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [selectAddressView addSubview:self.addressLab];
    [self.addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectAddressView.mas_left).offset(15);
        make.top.equalTo(selectAddressView).offset(15);
        make.width.equalTo(@90);
        make.height.equalTo(@20);
    }];
    
    self.selectAddress = [[UITextField alloc]init];
    self.selectAddress.textAlignment = NSTextAlignmentLeft;
    self.selectAddress.textColor = [UIColor colorWithHexString:@"#999999"];
    self.selectAddress.placeholder = locationString(@"plsSelect");
    self.selectAddress.font = kFont(16);
    self.selectAddress.userInteractionEnabled = NO;
    [selectAddressView addSubview:self.selectAddress];
    [self.selectAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressLab.mas_right);
        make.top.equalTo(selectAddressView).offset(15);
        make.width.equalTo(@(kScreenWidth - 120));
        make.height.equalTo(@20);
    }];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 30, 15, 20, 20)];
    imageView.image = [UIImage imageNamed:@"icon_enter"];
    [selectAddressView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(kScreenWidth - 30));
        make.top.equalTo(selectAddressView.mas_top).offset(15);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseAddress:)];
    [selectAddressView addGestureRecognizer:tap];
    
    
    UIView *lineThree = [[UIView alloc]init];
    lineThree.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [self addSubview:lineThree];
    
    
    self.detailAddressText = [[UITextField alloc]init];
    self.detailAddressText.placeholder = locationString(@"plsWriteDetailAddressNotLes");
    self.detailAddressText.font = kFont(16);
    self.detailAddressText.textColor = [UIColor colorWithHexString:@"#999999"];
    [self addSubview:self.detailAddressText];
    
    UIView *lineFour = [[UIView alloc]init];
    lineFour.backgroundColor = [UIColor colorWithHexString:@"#e2e2e2"];
    [self addSubview:lineFour];
   
    
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@15);
        make.width.equalTo(@(90));
        make.height.equalTo(@20);
    }];
    
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLab.mas_right);
        make.top.equalTo(@15);
         make.width.equalTo(@(kScreenWidth - 120));
        make.height.equalTo(@20);
    }];
    
    [lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(self.nameLab.mas_bottom).offset(15);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@0.5);
    }];
    
    [self.phoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(lineOne.mas_bottom).offset(15);
        make.width.equalTo(@(90));
        make.height.equalTo(@20);
    }];
    
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneLab.mas_right);
        make.top.equalTo(lineOne.mas_bottom).offset(15);
        make.width.equalTo(@(kScreenWidth - 120));
        make.height.equalTo(@20);
    }];
    
    [lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(self.phoneLab.mas_bottom).offset(15);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@0.5);
    }];
    
    [selectAddressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(lineTwo.mas_bottom);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@50);
    }];
    
    [lineThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(selectAddressView.mas_bottom);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@0.5);
    }];
    
    [self.detailAddressText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(lineThree.mas_bottom);
        make.width.equalTo(@(kScreenWidth - 30));
        make.height.equalTo(@80);
    }];
    
    [lineFour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(self.detailAddressText.mas_bottom);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@0.5);
    }];

    
    
}

- (void)chooseAddress:(UITapGestureRecognizer *)sender {
    [self endEditing:YES];
    
    _addressPickerView = [AddressPickerView shareInstance];
    [_addressPickerView showBottomView];
    [self addSubview:_addressPickerView];
    

    __weak UITextField *selectedTextField = self.selectAddress;
    _addressPickerView.block = ^(NSString *province,NSString *city,NSString *district)
    {
        NSString *provStr = [NSString stringWithFormat:@"%@ %@ %@",province,city,district];
        
        selectedTextField.text =provStr;
    };

}

-(void)setModel:(LTNAddressModel *)model{
    _model = model;
    self.nameTextField.text = _model.consigneeName;
    self.phoneTextField.text = _model.mobileNo;
    self.selectAddress.text = [NSString stringWithFormat:@"%@",_model.location];
    self.detailAddressText.text =[NSString stringWithFormat:@"%@",_model.detailAddress];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}
@end
