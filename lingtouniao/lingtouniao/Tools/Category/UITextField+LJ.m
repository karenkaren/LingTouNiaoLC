//
//  UITextField+LJ.m
//  lingtouniao
//
//  Created by LiuFeifei on 15/11/20.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "UITextField+LJ.h"

@implementation UITextField (LJ)

-(void)addLeftViewWithImage:(NSString *)image{
    
    
    // 密码输入框左边图片
    UIImageView *lockIv = [[UIImageView alloc] init];
    
    // 设置尺寸
    CGRect imageBound = self.bounds;
    // 宽度高度一样
    imageBound.size.width = imageBound.size.height;
    lockIv.bounds = imageBound;
    
    // 设置图片
    lockIv.image = [UIImage imageNamed:image];
    
    // 设置图片居中显示
    lockIv.contentMode = UIViewContentModeCenter;
    
    // 添加TextFiled的左边视图
    self.leftView = lockIv;
    
    // 设置TextField左边的总是显示
    self.leftViewMode = UITextFieldViewModeAlways;
}

#pragma mark 正则匹配手机号
-(BOOL)isTelphoneNum{
    return [StringUtil  isTelphoneNum:self.text];
//    NSString * telRegex = @"^1[34578]\\d{9}$";
//    NSPredicate * prediate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", telRegex];
//    return [prediate evaluateWithObject:self.text];
}

#pragma mark 正则匹配用户身份证号18位
- (BOOL)checkUserIdCard
{
    // 正则匹配用户身份证号15或18位
//    NSString * idCard = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    // 正则匹配用户身份证号18位
    NSString * idCard = @"[0-9]{17}([0-9]|X|x)$";
    NSPredicate * prediate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", idCard];
    return [prediate evaluateWithObject:self.text];
}

#pragma mark 18位身份证号码校验
- (BOOL)isValidateIDCardNumber {
    NSString * cardNo = self.text;
    if (cardNo.length != 18) {
        return  NO;
    }
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    NSScanner* scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i < 17; i++) {
        sumValue += [[cardNo substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue % 11]];
    
    if ([strlast isEqualToString: [[cardNo substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
}

#pragma mark 正则匹配用户密码6-18位数字和字母组合
- (BOOL)checkPassword
{
    NSString * password = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,18}$";
    NSPredicate * prediate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", password];
    return [prediate evaluateWithObject:self.text];
}

#pragma mark 判断是否为两位小数
- (BOOL)validDecimal
{
    NSRange rang = [self.text rangeOfString:@"."];
    if (rang.length > 0) {
        NSArray * digitArray = [self.text componentsSeparatedByString:@"."];
        NSString * decimalPart = digitArray.lastObject;
        return decimalPart.length > 2 ? NO : YES;
    }
    return YES;
}

#pragma mark 判断是否为整数
- (BOOL)isInterger
{
    NSRange rang = [self.text rangeOfString:@"."];
    NSInteger decimalPart = [[self.text componentsSeparatedByString:@"."].lastObject integerValue];
    return rang.length > 0 && decimalPart ? NO : YES;
}
#pragma mark 判断是否为整数
- (BOOL)isPureInt{
    NSScanner* scan = [NSScanner scannerWithString:self.text];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
#pragma mark 判断是否为float型
- (BOOL)isPureFloat{
    NSScanner* scan = [NSScanner scannerWithString:self.text];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
#pragma mark 判断是否为double型
- (BOOL)isPureDouble{
    NSScanner * scan = [NSScanner scannerWithString:self.text];
    double val;
    return[scan scanDouble:&val] && [scan isAtEnd];
}

#pragma mark 判断是否为纯数字
- (BOOL)isPureNumandCharacters
{
    NSString * string = [self.text stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}

@end
