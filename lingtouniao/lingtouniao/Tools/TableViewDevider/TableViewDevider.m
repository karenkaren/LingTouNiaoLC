//
//  TableViewDevider.m
//  lingtouniao
//
//  Created by 徐凯 on 15/12/18.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "TableViewDevider.h"
#import "LTNHeader.h"
#import "LTNDefines.h"

@implementation TableViewDevider

+(UIView*)getNoTopLineView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,20)];
    view.backgroundColor = BACKGROUND_COLOR;
    
    UIView *btLine = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 1.0/[UIScreen mainScreen].scale, kScreenWidth, 1.0/[UIScreen mainScreen].scale)];
    btLine.backgroundColor = DEVIDE_LINE_COLOR;
    [view addSubview:btLine];
    
    return view;
}
+(UIView*)getHeaderView:(BOOL)isLine
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,20)];
    view.backgroundColor = BACKGROUND_COLOR;
    UIView *tpLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1.0/[UIScreen mainScreen].scale)];
    tpLine.backgroundColor = DEVIDE_LINE_COLOR;
    [view addSubview:tpLine];
    if(!isLine)
    {   UIView *btLine = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 1.0/[UIScreen mainScreen].scale, kScreenWidth, 1.0/[UIScreen mainScreen].scale)];
        btLine.backgroundColor = DEVIDE_LINE_COLOR;
        [view addSubview:btLine];
    }
    return view;
}

+(UIView*)getHeaderViewWithHeight:(CGFloat)height showTopLine:(BOOL)showTopLine showBottomLine:(BOOL)showBottomLine
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,height)];
    view.backgroundColor = BACKGROUND_COLOR;
    if (showTopLine) {
        UIView *tpLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1.0/[UIScreen mainScreen].scale)];
        tpLine.backgroundColor = DEVIDE_LINE_COLOR;
        [view addSubview:tpLine];
    }
    if(showBottomLine)
    {
        UIView *btLine = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 1.0/[UIScreen mainScreen].scale, kScreenWidth, 1.0/[UIScreen mainScreen].scale)];
        btLine.backgroundColor = DEVIDE_LINE_COLOR;
        [view addSubview:btLine];
    }
    return view;
}

+(UIView*)getHighHeaderWithString:(NSString*)str hasTopLine:(BOOL)tpLine
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,20)];
    view.backgroundColor = BACKGROUND_COLOR;
    if (tpLine)
    {
        UIView *tpLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1.0/[UIScreen mainScreen].scale)];
        tpLine.backgroundColor = DEVIDE_LINE_COLOR;
        [view addSubview:tpLine];
    }
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth - 20,20)];
    label.text = str;
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:12.0f];
    [view addSubview:label];
    UIView *btLine = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 1.0/[UIScreen mainScreen].scale, kScreenWidth, 1.0/[UIScreen mainScreen].scale)];
    btLine.backgroundColor = DEVIDE_LINE_COLOR;
    [view addSubview:btLine];
    
    return view;
}
+(UIView*)getHighHeaderRightLabelWithString:(NSString*)str hasTopLine:(BOOL)tpLine
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,32)];
    view.backgroundColor = BACKGROUND_COLOR;
    if (tpLine)
    {
        UIView *tpLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1.0/[UIScreen mainScreen].scale)];
        tpLine.backgroundColor = DEVIDE_LINE_COLOR;
        [view addSubview:tpLine];
    }
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 20,32)];
    label.text = str;
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentRight;
    label.font = [UIFont systemFontOfSize:12.0f];
    [view addSubview:label];
    UIView *btLine = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 1.0/[UIScreen mainScreen].scale, kScreenWidth, 1.0/[UIScreen mainScreen].scale)];
    btLine.backgroundColor = DEVIDE_LINE_COLOR;
    [view addSubview:btLine];
    
    return view;
}

+(UIView*)singleLine
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,1.0/[UIScreen mainScreen].scale)];
    view.backgroundColor = BACKGROUND_COLOR;
    
    return view;
}

+(UIView*)getFooterView
{
    return [self getLineView];
}

+(UIView*)getHeaderView
{
    return [self getLineView];
}

+ (UIView *)getLineView
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1.0/[UIScreen mainScreen].scale)];
    lineView.backgroundColor = BACKGROUND_COLOR;
    UIView *tpLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1.0/[UIScreen mainScreen].scale)];
    tpLine.backgroundColor = DEVIDE_LINE_COLOR;
    [lineView addSubview:tpLine];
    
    return lineView;
}

@end
