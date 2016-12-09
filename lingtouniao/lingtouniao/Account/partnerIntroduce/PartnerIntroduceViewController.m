//
//  PartnerIntroduceViewController.m
//  lingtouniao
//
//  Created by zhangtongke on 16/4/7.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "PartnerIntroduceViewController.h"
#import "UIImage+Tint.h"

@interface PartnerIntroduceViewController ()

@end

@implementation PartnerIntroduceViewController

+(void)showPartnerIntroduceViewController:(void (^)(void))viewDetailBlock{
    PartnerIntroduceViewController *controller=[[PartnerIntroduceViewController alloc] init];
    controller.viewDetailBlock=viewDetailBlock;
    [[LTNAlertWindow sharedWindow] showRootViewController:controller];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *imageName;
    if(kScreenHeight==480){
        imageName=@"parterIntroduce(640x960)";
        
    }else if(kScreenHeight==568){
        imageName=@"parterIntroduce(640x1136)";
    }else if(kScreenHeight==667){
        imageName=@"parterIntroduce(750x1334)";
    }else if(kScreenHeight==736){
        imageName=@"parterIntroduce(750x1334)";
    }

    UIImageView *imageView=[[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:imageName];
    [self.view addSubview:imageView];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame =CGRectMake(0, 15, 24, 24);
    closeBtn.right=kScreenWidth-15;
    [closeBtn setImage:[[UIImage imageNamed:@"layer_close"] imageWithTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [closeBtn setEnlargeEdge:20];
    [closeBtn addTarget:self action:@selector(closeController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    detailBtn.size=CGSizeMake(120, 44);
    detailBtn.center=CGPointMake(kScreenWidth/2, 60);
    
    
    [detailBtn addTarget:self action:@selector(viewDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:detailBtn];
    detailBtn.backgroundColor=[UIColor clearColor];
    
       // Do any additional setup after loading the view.
}

-(void)closeController{
    [[LTNAlertWindow sharedWindow] dismissRootController];
}

-(void)viewDetail{
    if(_viewDetailBlock)
        _viewDetailBlock();
    [[LTNAlertWindow sharedWindow] dismissRootController];
    
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
