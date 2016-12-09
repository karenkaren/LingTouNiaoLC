//
//  UITextField+LJ.h
//  lingtouniao
//
//  Created by LiuFeifei on 15/11/20.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (LJ)

/**
 添加文件输入框左边的View,添加图片
 */
-(void)addLeftViewWithImage:(NSString *)image;

/**
 * 判断是否为手机号码
 */
-(BOOL)isTelphoneNum;
/**
 *  正则判断是否为18位身份证号
 */
- (BOOL)checkUserIdCard;
/**
 *  18位身份证号码校验
 */
- (BOOL)isValidateIDCardNumber;
/**
 *  正则判断密码是否为6-18位数字和字母组合
 */
- (BOOL)checkPassword;
/**
 *  判断是否为2位小数
 */
- (BOOL)validDecimal;
/**
 *  判断是否为整数
 */
- (BOOL)isInterger;
/**
 *  判断是否为整数
 */
- (BOOL)isPureInt;
/**
 *  判断是否为float型
 */
- (BOOL)isPureFloat;
/**
 *  判断是否为double型
 */
- (BOOL)isPureDouble;
/**
 *  判断是否为纯数字
 */
- (BOOL)isPureNumandCharacters;

@end
