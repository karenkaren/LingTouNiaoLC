//
//  UserInfoModel.m
//  lingtouniao
//
//  Created by 徐凯 on 15/12/23.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

-(NSString *)sex{
    if([_cardId length]==18){
        NSInteger sexNum=esInteger([_cardId substringWithRange:NSMakeRange(16,1)]);
        if(sexNum%2==0)
            return @"1";
        else
            return @"0";
        
    }
    
    if([_cardId length]==15){
        NSInteger sexNum=esInteger([_cardId substringWithRange:NSMakeRange(14,1)]);
        if(sexNum%2==0)
            return @"1";
        else
            return @"0";
        
    }
    
        return @"";
}

@end
