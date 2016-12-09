//
//  LTNTextField.h
//  lingtouniao
//
//  Created by LiuFeifei on 15/11/27.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTNTextField : UITextField

@property (nonatomic, assign) BOOL drawLeftLine;
@property (nonatomic, assign) BOOL drawRightLine;
@property (nonatomic, assign) BOOL drawTopLine;
@property (nonatomic, assign) BOOL drawBottomLine;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor * lineColor;
@property (nonatomic, assign) NSInteger limitedCount;

/**
   添加文件输入框左边的View，添加图片，距离textfield最左边有指定距离
*/
-(void)addLeftViewWithImageName:(NSString *)imageName leftMargin:(CGFloat)leftMargin leftViewMode:(UITextFieldViewMode)leftViewMode;

/**
 添加文件输入框左边的View，添加文字，距离textfield最左边有指定距离
 */
-(void)addLeftViewWithTitle:(NSString *)title leftMargin:(CGFloat)leftMargin leftWidth:(CGFloat)leftWidth leftViewMode:(UITextFieldViewMode)leftViewMode;

/**
 添加文件输入框右边的View，添加button
 */
-(void)addRightViewWithImageName:(NSString *)imageName selectImageName:(NSString *)selectImageName rightViewMode:(UITextFieldViewMode)rightViewMode target:(id)target action:(SEL)action;

/**
 *  添加清除按钮，当输入框为第一响应者并且输入框内有字符时出现，
 */
- (void)addClearButtonWithRightMargin:(CGFloat)rightMargin imageName:(NSString *)imageName;

@end
