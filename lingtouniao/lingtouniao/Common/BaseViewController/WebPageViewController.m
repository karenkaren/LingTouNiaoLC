//
//  WebPageViewController.m
//  mmbang
//
//  Created by yijin on 13-10-23.
//  Copyright (c) 2013年 iyaya. All rights reserved.
//

#import "WebPageViewController.h"
#import "UIBarButtonItem+ClearBackground.h"

//#import "ShareSnsUtil.h"

#define BOTTOM_BAR_HEIGHT 44

@implementation WebPageViewController

- (id)initWithURL:(NSString *)urlString
{
    self = [super initWithURL:urlString];
    
    if (self) {
        self.hasNav = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}






@end
