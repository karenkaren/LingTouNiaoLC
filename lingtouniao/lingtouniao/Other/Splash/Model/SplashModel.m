//
//  SplashModel.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/8/17.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "SplashModel.h"

@implementation Splash

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}

@end

static SplashModel * _sharedSplash = nil;
@implementation SplashModel


+ (NSDictionary *)mj_objectClassInArray
{
    return @{ @"startPageList" : [Splash class]};
}

+ (SplashModel *)sharedSplash
{
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        _sharedSplash = [[self alloc] init];
        
    });
    if (!_sharedSplash.version || !_sharedSplash.startPageList) {
        DLog(@"%@", kSplashModelPath);
        _sharedSplash = [NSKeyedUnarchiver unarchiveObjectWithFile:kSplashModelPath];
    }
    return _sharedSplash;
}

- (Splash *)splash{
    if (!_splash) {
        if (_startPageList.count > 0) {
            _splash = _startPageList.firstObject;
        }
    }
    return _splash;
}

@end