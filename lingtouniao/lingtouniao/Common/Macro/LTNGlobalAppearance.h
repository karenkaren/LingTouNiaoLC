//
//  LTNGlobalAppearance.h
//  lingtouniao
//
//  Created by  mathe on 15/12/16.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#ifndef LTNGlobalAppearance_h
#define LTNGlobalAppearance_h

//TODO: code review   HexRGB : kHexColor   颜色格式统一
#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kRGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define kRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]
#define kHexColor(hexValue) [UIColor colorWithHexString:hexValue]
#define kHexAColor(hexValue, alpha) [UIColor colorWithHexString:hexValue alpha:alpha]
#define HEX_COLOR(h,a) [UIColor colorWithHex:h alpha:a]

#define kMainColor 0xea5504
//#define MainTintColor HexRGB(kMainColor)
#define COLOR_MAIN HEX_COLOR(kMainColor, 1)
#define kDisabledColor         [UIColor colorWithHex:0xcccccc alpha:1]
#define kNavigationTintColor COLOR_MAIN

#define COLORWITHRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define DARK_THEME_COLOR [UIColor colorWithRed:143/255.0 green:83/255.0 blue:39/255.0 alpha:1]
#define THEME_COLOR [UIColor hexStringToColor:@"#E54142"]
#define BACKGROUND_COLOR [UIColor colorWithHexString:@"#f9f9f9"]
#define DEVIDE_LINE_COLOR [UIColor colorWithHex:0xe2e2e2 alpha:1]
#define CUSTOM_RED_COLOR [UIColor colorWithRed:207/255.0 green:92/255.0 blue:95/255.0 alpha:1]
#define CUSTOM_BLUE_COLOR [UIColor colorWithRed:129 / 255.0 green:210 / 255.0 blue:253 / 255.0 alpha:1]
#define CUSTOM_ORANGE_COLOR [UIColor colorWithRed:239/255.0 green:159/255.0 blue:85/255.0 alpha:1]
#define CUSTOM_YELLOW_COLOR [UIColor colorWithRed:240/255.0 green:213/255.0 blue:109/255.0 alpha:1]


//字体大小
#define kFont(size) [CustomerizedFont heiti:size]
#define kFontBold(size) [CustomerizedFont boldHeiti:size]
#define kStringSize(string, fontSize) [string sizeWithAttributes:@{NSFontAttributeName : kFont(fontSize)}]

#endif /* LTNGlobalAppearance_h */
