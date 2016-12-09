//
//  TableViewDevider.h
//  lingtouniao
//
//  Created by 徐凯 on 15/12/18.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableViewDevider : NSObject


+(UIView*)getNoTopLineView;

+(UIView*)getHeaderView:(BOOL)isLine;

+(UIView*)getHighHeaderWithString:(NSString*)str hasTopLine:(BOOL)tpLine;

+(UIView*)getHighHeaderRightLabelWithString:(NSString*)str hasTopLine:(BOOL)tpLine;

+(UIView*)getFooterView;
+(UIView*)getHeaderView;

+(UIView*)getHeaderViewWithHeight:(CGFloat)height showTopLine:(BOOL)showTopLine showBottomLine:(BOOL)showBottomLine;
+(UIView*)singleLine;

@end
