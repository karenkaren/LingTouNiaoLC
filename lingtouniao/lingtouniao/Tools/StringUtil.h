//
//  StringUtil.h
//  lingtouniao
//
//  Created by 徐凯 on 15/12/19.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringUtil : NSObject

/**
 *  数字字符串格式化，每3位一个逗号
 *
 *  @param num       需要格式化的数字
 *  @param isDecimal 是否需要转化为2位小数，yes:返回2位小数，no:返回整数
 *
 *  @return 返回格式化后的字符串
 */
+ (NSString *)stringFormatFromNumber:(double)num isDecimal:(BOOL)isDecimal;

+ (NSString *)stringFromDate:(NSDate *)date;

+ (NSString *)subStringFromString:(NSString *)string;

+ (NSString* )starsReplacedOfString:(NSString *)str withinRange:(NSRange)range;

//验证姓名长度
+(BOOL)validateName:(NSString *)string;
#pragma mark 正则匹配手机号
+(BOOL)isTelphoneNum:(NSString *)phone;
+ (BOOL)validateEmail:(NSString *)email;
// 过滤html标签
+ (NSString *)filterHTML:(NSString *)html;
@end
