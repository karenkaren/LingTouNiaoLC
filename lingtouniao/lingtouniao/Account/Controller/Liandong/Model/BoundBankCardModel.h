//
//  BoundBankCardModel.h
//  lingtouniao
//
//  Created by 徐凯 on 15/12/24.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "BaseModel.h"

@interface BoundBankCardModel : BaseModel

@property(nonatomic,strong)BindBankCardModel *bindBankCardModel;

@property(nonatomic,strong) NSArray *bankListArray;



-(void)GET_BindBankCardWithCardId:(NSString *)cardId andBelongBank:(NSString *)belongBank success:(void(^)(BOOL success))onSuccess failure:(void(^)(NSString *error))onFailure;

@end
