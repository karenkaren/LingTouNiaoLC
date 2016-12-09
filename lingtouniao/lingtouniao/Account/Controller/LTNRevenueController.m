//
//  LTNRevenueController.m
//  lingtouniao
//
//  Created by LiuFeifei on 15/12/24.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNRevenueController.h"
#import "LTNBaseDetailController.h"
#import "LTNServerConstant.h"
#import "LTNBaseStatisticsController.h"
#import "LTNBaseDetailRevseController.h"

@interface LTNCollectedRevenueViewController : LTNBaseStatisticsController

@end

@interface LTNCollectingRevenueViewController : LTNBaseDetailRevseController

@end

@implementation LTNCollectedRevenueViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = locationString(@"recived_balance");
    self.apiPath = kUncRevenueUrl;
    self.extraParams = @{@"type" : @1};
    self.centerText = locationString(@"total_balance");
    self.colors = @[HexRGB(0xea5504), HexRGB(0xffc000), HexRGB(0xFF4966), HexRGB(0xd5a0d8), HexRGB(0xff967d)];
}

@end

@implementation LTNCollectingRevenueViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = locationString(@"toreceive_balance");
    self.apiPath = kUncRevenueUrl;
    self.extraParams = @{@"type" : @0};
}

@end

@implementation LTNRevenueController

- (void)back{
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = locationString(@"revenue_record");
    self.viewControllers = @[[[LTNCollectingRevenueViewController alloc] init], [[LTNCollectedRevenueViewController alloc] init]];
}

- (void)slideSwitchViewWithSelectTab:(NSUInteger)number
{
    UIViewController *vc = self.viewControllers[number];
    if ([vc respondsToSelector:@selector(refreshIfNeeded)]) {
        [vc performSelector:@selector(refreshIfNeeded)];
    }
}

@end
