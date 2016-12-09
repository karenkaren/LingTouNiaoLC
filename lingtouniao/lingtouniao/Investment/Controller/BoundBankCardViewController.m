//
//  BoundBankCardViewController.m
//  lingtouniao
//
//  Created by 徐凯 on 15/12/24.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "BoundBankCardViewController.h"
#import "SecondBoundBandCardViewController.h"

@interface BoundBankCardViewController ()

@property (weak, nonatomic) IBOutlet UILabel *boundBank_Des_Label;
@property (weak, nonatomic) IBOutlet UIButton *addButton;//添加银行卡
@property (weak, nonatomic) IBOutlet UILabel *boundBank_Des2_Label;

@end

@implementation BoundBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _boundBank_Des_Label.text = locationString(@"boundBank_Des");
    _boundBank_Des2_Label.text = locationString(@"boundBank_Des2");
    [_addButton setTitle:locationString(@"add_Button") forState:UIControlStateNormal];
}

-(void)initUIView
{
   self.navigationItem.title = locationString(@"bank_card_setting");
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self dissmissWithBackButton];
        
}


- (void)back
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    if(self.navigationController.finishBlock)
        self.navigationController.finishBlock();
    
    [super back];
}


/**
 *  添加银行卡
 *
 */
- (IBAction)addClick:(id)sender {
    
    SecondBoundBandCardViewController *secondBoundBandCardViewController = [[SecondBoundBandCardViewController alloc]init];
    if(_finishBlock)
        secondBoundBandCardViewController.finishBlock=_finishBlock;
        
    [self.navigationController pushViewController:secondBoundBandCardViewController animated:YES];
    
    
}





@end
