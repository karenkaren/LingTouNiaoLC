//
//  UILabel+LJ.h
//  lingtouniao
//
//  Created by LiuFeifei on 15/12/16.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (LJ)

- (void)addAttributes:(NSDictionary *)attributes forString:(NSString *)string;
- (void)addAttributesWithFontSize:(NSInteger)fontSize forString:(NSString *)string;
- (void)addAttributes:(NSDictionary *)attributes forStringArray:(NSArray *)stringArray;
- (void)addAttributesWithFontSize:(NSInteger)fontSize forStringArray:(NSArray *)stringArray;
- (void)addAttributesArray:(NSArray *)attributesArray forStringArray:(NSArray *)stringArray;

@end
