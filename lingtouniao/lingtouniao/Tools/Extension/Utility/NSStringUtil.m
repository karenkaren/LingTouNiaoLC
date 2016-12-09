//
//  NSStringUtil.m
//  mmbang
//
//  Created by CuiPanJun on 14-8-27.
//  Copyright (c) 2014年 iyaya. All rights reserved.
//

#import "NSStringUtil.h"

@implementation NSStringUtil

+ (NSString *)intStringFromDictValue:(id)dictValue{
    if ([dictValue isKindOfClass:[NSString class]] || [dictValue isKindOfClass:[NSMutableString class]]) {
        return dictValue;
    }
    if ([dictValue respondsToSelector:@selector(integerValue)]) {
        return [NSString stringWithFormat:@"%@",@([dictValue integerValue])];
    }
    return @"";
}

+ (NSString *)safeEmpty:(NSString *)str{
    if(str == nil) {
        return @"";
    }
    return str;
}

+ (NSString *)urlWithoutQuery:(NSString *)originURL
{
    NSArray *components = [originURL componentsSeparatedByString:@"?"];
    if ([components count] < 2) {
        return originURL;
    }else{
        return [components objectAtIndex:0];
    }
//    NSURL *url = [NSURL URLWithString:originURL];
//    NSString *query = [url query];
//    NSString *urlWithOutQuery = originURL;
//    if (query.length > 0) {
//        urlWithOutQuery = [originURL stringByReplacingOccurrencesOfString:query withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, originURL.length)];
//    }
//    return urlWithOutQuery;
}

@end
