//
//  FinancialIntroduceViewController.m
//  lingtouniao
//
//  Created by 郑程锋 on 16/11/24.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "FinancialIntroduceViewController.h"

@interface FinancialIntroduceViewController ()

@end

@implementation FinancialIntroduceViewController

+(void)showFinancialIntroduceViewController:(void (^)(void))viewDetailBlock{
    FinancialIntroduceViewController *controller=[[FinancialIntroduceViewController alloc] init];
    controller.viewDetailBlock=viewDetailBlock;
    [[LTNAlertWindow sharedWindow] showRootViewController:controller];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kRGBAColor(0, 0, 0, 0.8);
       
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 64+10+DimensionBaseIphone6(49), kScreenWidth, DimensionBaseIphone6(220))];
    imageView.image = [UIImage imageNamed:@"icon_FincianItro"];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];

    
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeController)];
    [imageView addGestureRecognizer:tap];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(closeController)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [imageView addGestureRecognizer:swipe];
    
}

-(void)closeController{
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
