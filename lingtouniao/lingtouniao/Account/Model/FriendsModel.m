//
//  FriendsModel.m
//  lingtouniao
//
//  Created by 郑程锋 on 15/12/25.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "FriendsModel.h"

@implementation FriendsModel
-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    if (self=[super init]) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
