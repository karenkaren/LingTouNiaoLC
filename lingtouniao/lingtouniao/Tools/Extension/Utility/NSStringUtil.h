//
//  NSStringUtil.h
//  mmbang
//
//  Created by CuiPanJun on 14-8-27.
//  Copyright (c) 2014年 iyaya. All rights reserved.
//

#import <Foundation/Foundation.h>

#define intStringFromDictValue(a) [NSStringUtil intStringFromDictValue:a]
#define safeEmpty(a) [NSStringUtil safeEmpty:a]

@interface NSStringUtil : NSObject

+ (NSString *)intStringFromDictValue:(id)dictValue;
+ (NSString *)safeEmpty:(NSString *)str;

+ (NSString *)urlWithoutQuery:(NSString *)originURL;

@end
