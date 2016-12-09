//
//  LTNResetTradePasswordViewController.m
//  lingtouniao
//
//  Created by peijingwu on 12/30/15.
//  Copyright © 2015 lingtouniao. All rights reserved.
//

#import "LTNResetTradePasswordViewController.h"
#import "ObjectManager.h"
#import "NSStringUtil.h"

@interface LTNResetTradePasswordViewController ()

@end

@implementation LTNResetTradePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 141)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];

    self.title = locationString(@"reset_trade_password");
    NSArray *data = @[
                      @{
                          @"image":@"icon_code1",
                          @"text":locationString(@"step_1"),
                          },
                      @{
                          @"image":@"arrow",
                          @"text":@"",
                          },
                      @{
                          @"image":@"icon_code2",
                          @"text":locationString(@"step_2"),
                          },
                      @{
                          @"image":@"arrow",
                          @"text":@"",
                          },
                      @{
                          @"image":@"icon_code3",
                          @"text":locationString(@"step_3"),
                          }
                      ];
    CGFloat yImg = 50;
    CGFloat yText = 80;
    CGFloat stepText = (kScreenWidth - 2 * kHorizontalMargin) / ((data.count + 1) / 2);
    CGFloat centerText = kHorizontalMargin + stepText / 2;
    
    int i = 0;
    int kBase = 1000;
    for (id item in data) {
        NSString *imgName = [item valueForKey:@"image"];
        NSString *text = [item valueForKey:@"text"];
        UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
        imgV.tag = kBase + i;
        UILabel *label = [Utility createLabel:[CustomerizedFont heiti:10] color:[UIColor blackColor]];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.text = text;
        label.width = stepText;
        [label sizeToFit];
        
        imgV.centerY = yImg;
        label.top = yText;
        imgV.centerX = label.centerX = centerText + (i / 2) * stepText;
        [backView addSubview:imgV];
        [backView addSubview:label];
        i++;
    }
    
    UIImageView *v1 = [self.view viewWithTag:1000];
    UIImageView *v2 = [self.view viewWithTag:1001];
    UIImageView *v3 = [self.view viewWithTag:1002];
    UIImageView *v4 = [self.view viewWithTag:1003];
    UIImageView *v5 = [self.view viewWithTag:1004];
    v2.centerX = (v1.centerX + v3.centerX) / 2;
    v4.centerX = (v3.centerX + v5.centerX) / 2;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15, backView.bottom + 20, kScreenWidth - 30, kGeneralHeight)];
    [btn setTitle:self.title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 4;
    btn.clipsToBounds = YES;
    [btn setBackgroundImage:[UIImage imageWithColor:COLOR_MAIN size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    btn.tappedBlock = ^(UIButton *btn) {
        [self resetPasswd];
    };
    [self.view addSubview:btn];
}

- (void)resetPasswd {
    NSArray *recipients = @[@"10690569687"];
    NSString *identifier = [CurrentUser mine].userInfo.cardId;
    NSInteger len = [identifier length];
    if (len >= 4) {
        identifier = [identifier substringWithRange:NSMakeRange(len - 4, 4)];
    }
    [[ObjectManager sharedInstance] sendSMSMsg:[NSString stringWithFormat:@"%@%@", @"CSMM#", safeEmpty(identifier)] recipients:recipients onVC:self];
}

@end
