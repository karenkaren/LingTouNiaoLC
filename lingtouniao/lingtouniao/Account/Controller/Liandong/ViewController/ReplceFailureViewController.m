//
//  ReplceFailureViewController.m
//  lingtouniao
//
//  Created by 徐凯 on 16/4/1.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "ReplceFailureViewController.h"
#import "ReplaceView.h"
#import "ChangeCardViewControoler.h"

@interface ReplceFailureViewController ()<UIAlertViewDelegate>
{
    ReplaceView *_replaceView;
}
@property (weak, nonatomic) IBOutlet UILabel *failureLabel;
@end

@implementation ReplceFailureViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    //_failureLabel.text = locationString(@"change_bank_fail");
    // Do any additional setup after loading the view from its nib.
}
- (void)initUIView
{
    self.title = locationString(@"change_bank_fail");
    _replaceView = [[ReplaceView alloc]init];
    _failureLabel.text = _reasonString;
    [_replaceView.replaceButton setTitle:_buttonTitle forState:UIControlStateNormal];
    [_replaceView.replaceButton addTarget:self action:@selector(backForward:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_replaceView];
    [_replaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(_failureLabel.mas_bottom);
        make.height.mas_equalTo(110);
    }];
    
    self.view.backgroundColor=_replaceView.backgroundColor;
    
}

- (void)backForward:(UIButton *)sender
{
    if(_type == 5)
    {
    ChangeCardViewControoler *changeCardViewControoler = [[ChangeCardViewControoler alloc]init];
    [self.navigationController pushViewController:changeCardViewControoler animated:YES];
    }else if (_type == 8)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"400-999-9980" message:nil delegate:self cancelButtonTitle:locationString(@"btn_cancel") otherButtonTitles:locationString(@"call"), nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"4009999980"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
