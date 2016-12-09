//
//  LTNSupplyPartnerControllerViewController.m
//  lingtouniao
//
//  Created by  mathe on 15/12/24.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNSupplyPartnerControllerViewController.h"

@interface LTNSupplyPartnerControllerViewController ()

@end

@implementation LTNSupplyPartnerControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=BACKGROUND_COLOR;
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[PiwikTracker sharedInstance] sendViews:NSStringFromClass([self class]), self.title, nil];
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
