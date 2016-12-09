//
//  StringUtil.m
//  lingtouniao
//
//  Created by 徐凯 on 15/12/19.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "StringUtil.h"

@implementation StringUtil

// 数字字符串格式化，每3位一个逗号
+ (NSString *)stringFormatFromNumber:(double)num isDecimal:(BOOL)isDecimal;
{
    int count = 0;
    NSString * numString = isDecimal ? [NSString stringWithFormat:@"%.2f", num] : [NSString stringWithFormat:@"%ld", (NSUInteger)num];
    ;
    NSArray * nums = [numString componentsSeparatedByString:@"."];
    NSString * decimalPart = nil;
    if (nums.count > 1) {
        decimalPart = nums.lastObject;
    }
    NSString * intgerPart = nums.firstObject;
    long long int a = intgerPart.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:intgerPart];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    
    if (decimalPart) {
        [newstring appendFormat:@".%@", decimalPart];
    }
    return newstring;
}


/**
 *  NSDate转字符串
 *
 */
+ (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
    
}
/**
 *  获取银行卡后四位
 *
 *  @param string <#string description#>
 *
 */
+(NSString *)subStringFromString:(NSString *)string
{
    if (string.length >= 4) {
         return  [string substringFromIndex:string.length-4];
    }
    return nil;
}

+ (NSString* )starsReplacedOfString:(NSString *)str withinRange:(NSRange)range
{
    if (str == nil || [str length]< range.location + range.length)
    {
        return str;
    }
    
    
    NSMutableString* mStr = [[NSMutableString alloc]initWithString:str];
    
    [mStr replaceCharactersInRange:range withString:[[NSString string] stringByPaddingToLength:range.length withString: @"*" startingAtIndex:0]];
    
    return mStr;
}


+(BOOL)validateName:(NSString *)string
{
    NSString *nickNameRegex = @"^([\u4e00-\u9fa5]{0,10})$";
    NSPredicate *nickNameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nickNameRegex];
    return [nickNameTest evaluateWithObject:[self trimSpacesOfString:string]];
}
//去掉空格
+ (NSString *)trimSpacesOfString:(NSString *)str
{
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}

#pragma mark 正则匹配手机号
+(BOOL)isTelphoneNum:(NSString *)phone{
    
    NSString * telRegex = @"^1[34578]\\d{9}$";
    NSPredicate * prediate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telRegex];
    return [prediate evaluateWithObject:phone];
}


+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return html;
}

@end
