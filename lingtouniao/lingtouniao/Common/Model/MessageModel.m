//
//  MessageModel.m
//  lingtouniao
//
//  Created by 徐凯 on 15/12/19.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

@end



@implementation FinanciaCouponModel

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end

@implementation CouponsModel

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end

@implementation BankListModel

-(void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.bankId = value;
    }
    else
    {
        [super setValue:value forKey:key];
    }
  
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{

}

+(NSArray *)getBankNameList:(NSArray *)bankListModelList{
    
    NSMutableArray *bankNameList=[NSMutableArray arrayWithCapacity:[bankListModelList count]];
    [bankListModelList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [bankNameList addObject:((BankListModel *)obj).bankName];
    }];
    return bankNameList;

}

+(NSArray *)getBankLimit:(NSArray *)bankListModelList
{
    NSMutableArray *bankNameList=[NSMutableArray arrayWithCapacity:[bankListModelList count]];
    [bankListModelList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [bankNameList addObject:[NSString stringWithFormat:locationString(@"charge_limit"),[((BankListModel *)obj).chargeTimeLimit doubleValue],[((BankListModel *)obj).chargeDateLimit doubleValue]]];
    }];
    return bankNameList;
}


@end


@implementation LimitMountModel

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end





@implementation OrderPrepareModel

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end



@implementation BindBankCardModel

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end

@implementation ProductBuyConfirmModel

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
