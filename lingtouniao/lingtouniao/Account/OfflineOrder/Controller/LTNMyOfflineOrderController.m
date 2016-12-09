//
//  LTNMyOfflineOrderController.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/2/20.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "LTNMyOfflineOrderController.h"
#import "LTNBaseOfflineController.h"

@interface LTNOfflineInvestingViewController : LTNBaseOfflineController

@end

@interface LTNOfflineInvestedViewController : LTNBaseOfflineController

@end

@implementation LTNOfflineInvestingViewController

- (void)viewDidLoad {
    self.status = @"CYZ";
    [super viewDidLoad];
    self.title = locationString(@"anxintou_chiyou");
}

@end

@implementation LTNOfflineInvestedViewController

- (void)viewDidLoad {
    self.status = @"YHK";
    [super viewDidLoad];
    self.title = locationString(@"anxintou_huankuan");
}
@end

@implementation LTNMyOfflineOrderController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = locationString(@"my_anxin");
    self.viewControllers =@[[[LTNOfflineInvestingViewController alloc] init], [[LTNOfflineInvestedViewController alloc] init]];
}

- (void)slideSwitchViewWithSelectTab:(NSUInteger)number
{
    UIViewController *vc = self.viewControllers[number];
    if ([vc respondsToSelector:@selector(refreshIfNeeded)]) {
        [vc performSelector:@selector(refreshIfNeeded)];
    }
}

@end
