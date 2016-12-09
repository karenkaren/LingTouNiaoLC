//
//  UILabel+LJ.m
//  lingtouniao
//
//  Created by LiuFeifei on 15/12/16.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "UILabel+LJ.h"

@implementation UILabel (LJ)

- (void)addAttributes:(NSDictionary *)attributes forString:(NSString *)string
{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSString * temp = nil;
    for(int i = 0; i < self.text.length; i++)
    {
        if (i + string.length > self.text.length) {
            break;
        }
        temp = [self.text substringWithRange:NSMakeRange(i, string.length)];
        if ([temp isEqualToString:string]) {
            [attributedString addAttributes:attributes range:NSMakeRange(i, string.length)];
        }
    }
    self.attributedText = attributedString;
}

- (void)addAttributesWithFontSize:(NSInteger)fontSize forString:(NSString *)string
{
    NSDictionary * attributes = @{NSFontAttributeName : kFont(fontSize)};
    [self addAttributes:attributes forString:string];
}

- (void)addAttributes:(NSDictionary *)attributes forStringArray:(NSArray *)stringArray
{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    for (int i = 0; i < stringArray.count; i++) {
        NSString * string = stringArray[i];
        NSString * temp = nil;
        for(int j = 0; j < self.text.length; j++)
        {
            if (j + string.length > self.text.length) {
                break;
            }
            temp = [self.text substringWithRange:NSMakeRange(j, string.length)];
            if ([temp isEqualToString:string]) {
                [attributedString addAttributes:attributes range:NSMakeRange(j, string.length)];
            }
        }
        //        [attributedString addAttributes:attributes range:[self.text rangeOfString:string]];
    }
    self.attributedText = attributedString;
}

- (void)addAttributesWithFontSize:(NSInteger)fontSize forStringArray:(NSArray *)stringArray
{
    NSDictionary * attributes = @{NSFontAttributeName : kFont(fontSize)};
    [self addAttributes:attributes forStringArray:stringArray];
}

- (void)addAttributesArray:(NSArray *)attributesArray forStringArray:(NSArray *)stringArray
{
    if (attributesArray.count != stringArray.count) {
        return;
    }

    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    for (int i = 0; i < stringArray.count; i++) {
        NSString * string = stringArray[i];
        NSDictionary * attributes = attributesArray[i];
        NSString * temp = nil;
        for(int j = 0; j < self.text.length; j++)
        {
            if (j + string.length > self.text.length) {
                break;
            }
            temp = [self.text substringWithRange:NSMakeRange(j, string.length)];
            if ([temp isEqualToString:string]) {
                [attributedString addAttributes:attributes range:NSMakeRange(j, string.length)];
            }
        }
    }
    self.attributedText = attributedString;
}

@end
