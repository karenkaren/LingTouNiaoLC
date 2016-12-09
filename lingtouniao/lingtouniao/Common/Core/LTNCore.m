//
//  LTNCore.m
//  lingtouniao
//
//  Created by  mathe on 15/12/15.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "LTNCore.h"
#import "AppDelegate.h"
#import "LTNTabBarController.h"


#define kConfigKey @"ltn_config"
static LTNCore *_sharedCore = nil;

@implementation LTNCore

//why I have to use synthsize here
@synthesize configData = _configData;


+ (LTNCore *)globleCore
{
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        _sharedCore = [[self alloc] init];
        
    });
    return _sharedCore;
}


//not use now.
//- (LTNConfigModel *)configData {
//    if (!_configData) {
//        id data = [Utility getDataWithKey:kConfigKey];
//        if (data) {
//            _configData = (LTNConfigModel *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
//        }
//    }
//    return _configData;
//}
//
//- (void)setConfigData:(LTNConfigModel *)configData {
//    if (_configData != configData) {
//        _configData = configData;
//        id data = [NSKeyedArchiver archivedDataWithRootObject:_configData];
//        [Utility saveDataWithKey:kConfigKey ofValue:data];
//    }
//}

- (id)init
{
    self = [super init];
    if (self) {
        [self initializeGlobleApprence];
        [self initIQKeyboardManager];
        [self synRescource];
        
    }
    return self;
}


+ (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

+(UIWindow *)mainWindow
{
    return [[self appDelegate] window];
}

+ (UIViewController *)appRootViewController
{
    return [[self mainWindow] rootViewController];
}

+ (UIViewController *)frontController{
    UIView *frontView = [[[LTNCore mainWindow] subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    return nextResponder;
}

- (void)initializeGlobleApprence{
    [[UITabBar appearance] setTintColor:HexRGB(0xea5504)];
    //TODO:字体颜色
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:20],NSFontAttributeName,[UIColor blackColor],NSForegroundColorAttributeName, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    //[[UINavigationBar appearance] setBackgroundColor:HexRGB(0xfafafa)];
    //[[UINavigationBar appearance] setBarTintColor:[UIColor redColor]];
    
}



-(NSMutableArray *)changeableImageViews{
    if(!_changeableImageViews){
        _changeableImageViews=[NSMutableArray array];
    }
    return _changeableImageViews;
}


@end
