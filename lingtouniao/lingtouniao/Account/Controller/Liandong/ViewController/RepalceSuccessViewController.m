//
//  RepalceSuccessViewController.m
//  lingtouniao
//
//  Created by 徐凯 on 16/4/1.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "RepalceSuccessViewController.h"
#import "ReplaceView.h"

@interface RepalceSuccessViewController ()
{
    ReplaceView *_replaceView;

}

@end

@implementation RepalceSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        _desLabel.text = locationString(@"apply_ok_tag");
        _statusLabel.text = locationString(@"change_bank_ok");
    }
    return  self;
}




- (void)initUIView
{
   self.title = _titleString;
    _statusLabel.text = _statusString;
    _desLabel.text = _desString;
    _replaceView = [[ReplaceView alloc]init];
    [_replaceView.replaceButton setTitle:locationString(@"know") forState:UIControlStateNormal];
    [_replaceView.replaceButton addTarget:self action:@selector(backForward:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_replaceView];
    [_replaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(_desLabel.mas_bottom);
        make.height.mas_equalTo(110);
    }];
    
    self.view.backgroundColor=_replaceView.backgroundColor;
    
}

- (void)backForward:(UIButton *)sender
{
    [super back];
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
