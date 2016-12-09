//
//  CustomerizedFont.m
//  mmbang
//
//  Created by lihuaming on 15/1/21.
//  Copyright (c) 2015年 iyaya. All rights reserved.
//

#import "CustomerizedFont.h"

#define DeviceiPhone6plusWidth 375

@implementation CustomerizedFont

+ (UIFont *)systemFontOfSize:(CGFloat)fontSize
{
    return [CustomerizedFont heiti:fontSize];
}

+ (UIFont *)boldSystemFontOfSize:(CGFloat)fontSize
{
    return [CustomerizedFont boldHeiti:fontSize];
}

- (UIFont *)fontWithSize:(CGFloat)fontSize
{
    if (kScreenWidth > DeviceiPhone6plusWidth) {
        return [super fontWithSize:fontSize + 2];
    }else {
        return [super fontWithSize:fontSize];
    }
}

+ (UIFont *)resetSystemFontOfSize:(float)fontSize
{
    return [CustomerizedFont heiti:fontSize];
}

+ (UIFont *)resetBoldSystemFontOfSize:(float)fontSize
{
    return [CustomerizedFont boldHeiti:fontSize];
}

//ios9系统字体为平方PingFangSC，ios9以下的字体为STHeitiSC 类似系统
+ (UIFont *)heiti:(CGFloat)fontSize {
    if (kIsIOS9)
    {
        return [CustomerizedFont fontWithName:@"PingFangSC-Light" size:fontSize];
    } else {
        return [CustomerizedFont fontWithName:@"STHeitiSC-Light" size:fontSize];
    }
}

+ (UIFont *)boldHeiti:(CGFloat)fontSize {
    if (kIsIOS9)
    {
        return [CustomerizedFont fontWithName:@"PingFangSC-Medium" size:fontSize];
    } else {
        return [CustomerizedFont fontWithName:@"STHeitiSC-Medium" size:fontSize];
    }
}

+ (UIFont *)heitiLightWithSize:(float)fontSize {
    return [self heiti:fontSize];
}

+ (UIFont *)boldHeitiWithSize:(CGFloat)fontSize {
    return [self boldHeiti:fontSize];
}


@end
