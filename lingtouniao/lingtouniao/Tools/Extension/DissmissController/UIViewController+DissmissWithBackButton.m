//
//  UIViewController+DissmissWithBackButton.m
//  lingtouniao
//
//  Created by zhangtongke on 16/1/8.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "UIViewController+DissmissWithBackButton.h"

@implementation UIViewController (DissmissWithBackButton)

-(void)dissmissWithBackButton{
    if(self.navigationController&&[self.navigationController.viewControllers count]==1){
        NSLog(@"===%@",self.navigationController.topViewController);
        UIButton * closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, kGeneralHeight)];
        [closeButton setImage:[UIImage imageNamed:@"nav_close"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    }
    
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}




@end
