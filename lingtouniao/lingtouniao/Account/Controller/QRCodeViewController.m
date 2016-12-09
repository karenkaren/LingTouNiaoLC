//
//  QRCodeViewController.m
//  lingtouniao
//
//  Created by 徐凯 on 16/1/21.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "QRCodeViewController.h"
#import "KMQRCode.h"
#import "UIImage+RoundedRectImage.h"

@interface QRCodeViewController ()
{
    UILabel *nameTitleLabel;
    UIImageView *_imgVQRCode;//二维码
    UIImage *imgAdaptiveQRCode;//图片
}

@end

@implementation QRCodeViewController

- (void)back{
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)initUIView
{
   self.navigationItem.title = locationString(@"my_qrcode");
    UILabel *phoneLabel = [self customLabelWithTitle:nil titleFont:16];
    nameTitleLabel = [self customLabelWithTitle:nil titleFont:16];
    UILabel *descLabel = [self customLabelWithTitle:locationString(@"qrcode") titleFont:14];
    phoneLabel.frame = CGRectMake(0, 10, kScreenWidth, 20);
    nameTitleLabel.frame = CGRectMake(0, 30, kScreenWidth, 20);
    
    [self generateQRCode];//生成二维码
    
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenWidth);
        make.top.equalTo(_imgVQRCode.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
    }];
    
    
    UIButton *clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clickButton setTitle:locationString(@"save_qrcode") forState:UIControlStateNormal];
    [clickButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [clickButton setBackgroundImage:[UIImage imageNamed:@"confirmButton"] forState:UIControlStateNormal];
    [clickButton addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clickButton];
    [clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(descLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(@40);
    }];
}

-(UILabel *)customLabelWithTitle:(NSString *)nameTitle titleFont:(CGFloat)font
{
    UILabel *label = [Utility createLabel:[UIFont systemFontOfSize:font] color:[UIColor colorWithHexString:@"#999999"]];
    label.text = nameTitle;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    return label;
}

/**
 *  生成二维码
 */
-(void)generateQRCode
{
    _imgVQRCode = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-160, kScreenWidth-160)];
    [self.view addSubview:_imgVQRCode];
    [_imgVQRCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(80);
        make.right.equalTo(self.view).offset(-80);
        make.top.equalTo(nameTitleLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-160, kScreenWidth-160));
    }];
    
    NSString *source = [CurrentUser urlForShare];
    CIImage *imgQRCode = [KMQRCode createQRCodeImage:source];
    imgAdaptiveQRCode = [KMQRCode resizeQRCodeImage:imgQRCode withSize:320];
    imgAdaptiveQRCode = [KMQRCode specialColorImage:imgAdaptiveQRCode
                                withRed:0
                                green:0
                                blue:0];

    UIImage *imgIcon = [UIImage createRoundedRectImage:[UIImage imageNamed:@"code_icon"] withSize:CGSizeMake(80.0/375*kScreenWidth, 80.0/375*kScreenWidth) withRadius:10];
    imgAdaptiveQRCode = [KMQRCode addIconToQRCodeImage:imgAdaptiveQRCode withIcon:imgIcon withIconSize:imgIcon.size];

     _imgVQRCode.image = imgAdaptiveQRCode;
     //设置图片视图的圆角边框效果
     _imgVQRCode.layer.masksToBounds = YES;
     _imgVQRCode.layer.cornerRadius = 10.0;
     _imgVQRCode.layer.borderColor = [UIColor lightGrayColor].CGColor;
     _imgVQRCode.layer.borderWidth = 2.0;

}

-(void)saveClick:(UIButton *)button
{
    UIImageWriteToSavedPhotosAlbum(imgAdaptiveQRCode, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
}


// 指定回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(!error){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:locationString(@"save_success")
                                                       message:nil
                                                      delegate:nil
                                             cancelButtonTitle:locationString(@"btn_confirm")
                                             otherButtonTitles:nil, nil];
        [alert show];

    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:locationString(@"save_failure")
                                                       message:locationString(@"qrcode_setting")
                                                      delegate:nil
                                             cancelButtonTitle:locationString(@"btn_confirm")
                                             otherButtonTitles:nil, nil];
        [alert show];

    }
}


@end
