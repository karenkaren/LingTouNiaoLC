//
//  EditAddressViewController.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/11/3.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "EditAddressViewController.h"
#import "EditAddressInfoView.h"
#import "LTNUtilsHelper.h"
#import "LTNTextField.h"

@interface EditAddressViewController ()

@property (nonatomic) UIButton *storeButton;

@property (nonatomic) EditAddressInfoView *editInfoView;

@end

@implementation EditAddressViewController

- (void)viewDidLoad {
    self.hideRefreshHeader = YES;
    self.isTableViewStyleGrouped = YES;
    [super viewDidLoad];
    //self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    if (self.isEditAddress == YES) {
        self.title = locationString(@"editAddress");
    }else{
        self.title = locationString(@"addAddress");
    }
    
    [self setUpUI];
    
    
    self.storeButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, kGeneralHeight, kGeneralHeight)];
    [self.storeButton setTitle:locationString(@"store") forState:UIControlStateNormal];
    [self.storeButton setTitleColor:[UIColor colorWithHexString:@"#3A3A3A"] forState:UIControlStateNormal];
    [self.storeButton addTarget:self action:@selector(storeAddress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:self.self.storeButton];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    item.width = -10;
    
    self.navigationItem.rightBarButtonItems = @[item,rightBtn];

}

-(void)setUpUI{
   
    self.editInfoView = [[EditAddressInfoView alloc]init];
    
    self.editInfoView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    if (self.isEditAddress == YES) {
        self.editInfoView.model = self.addressModel;
    }
    [self.tableView addSubview:self.editInfoView];
   
}

-(void)storeAddress{
    [self.view endEditing:YES];
    
    if ([self.editInfoView.nameTextField.text isEqualToString:@""] || [self.editInfoView.phoneTextField.text isEqualToString:@""] || [self.editInfoView.selectAddress.text isEqualToString:@""] || [self.editInfoView.detailAddressText.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:locationString(@"inPutIsNotPull") message:nil delegate:nil cancelButtonTitle:locationString(@"btn_confirm") otherButtonTitles:nil];
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            
        }];
        
    }else if (![self.editInfoView.phoneTextField isTelphoneNum] ){
        [self.editInfoView.phoneTextField becomeFirstResponder];
        [LTNUtilsHelper boxShowWithMessage:locationString(@"mobile_corrected")];
    }else if (self.editInfoView.detailAddressText.text.length < 5){
        [LTNUtilsHelper boxShowWithMessage:locationString(@"detailAddressNotLess")];
    }else{
        
        if (_isEditAddress == YES) {
            //编辑地址时保存
            kWeakSelf
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:@{@"consigneeName" : self.editInfoView.nameTextField.text,
                                                                                        @"detailAddress" : self.editInfoView.detailAddressText.text,
                                                                                        @"location" : self.editInfoView.selectAddress.text,
                                                                                        @"mobileNo" : self.editInfoView.phoneTextField.text,
                                                                                        @"id" : self.addressModel.ID
                                                                                        }];
            [BaseDataEngine apiForPath:kUpdateAddressUrl method:kPostMethod parameter:dic responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
                if (!error) {
                    [LTNUtilsHelper boxShowWithMessage:locationString(@"updateSuccess")];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
                
            }];

        }else{
            //添加地址时保存
            kWeakSelf
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:@{@"consigneeName" : self.editInfoView.nameTextField.text,
                                                                                        @"detailAddress" : self.editInfoView.detailAddressText.text,
                                                                                        @"location" : self.editInfoView.selectAddress.text,
                                                                                        @"mobileNo" : self.editInfoView.phoneTextField.text
                                                                                        }];
            [BaseDataEngine apiForPath:kCreateAddressUrl method:kPostMethod parameter:dic responseModelClass:nil onComplete:^(id response, id data, NSError *error) {
                if (!error) {
                    [LTNUtilsHelper boxShowWithMessage:locationString(@"save_success")];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
               
            }];
        }

        
    }
    

    
    
}
-(void)back{
//    if (_isEditAddress == YES){
//        [self.navigationController popViewControllerAnimated:YES];
//        return;
//    }
    
    if (![self.editInfoView.nameTextField.text isEqualToString:@""] || ![self.editInfoView.phoneTextField.text isEqualToString:@""] || ![self.editInfoView.selectAddress.text isEqualToString:@""] || ![self.editInfoView.detailAddressText.text isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您本次的编辑尚未保存，是否退出编辑？" delegate:nil cancelButtonTitle:@"退出" otherButtonTitles:@"保存", nil];
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self storeAddress];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
