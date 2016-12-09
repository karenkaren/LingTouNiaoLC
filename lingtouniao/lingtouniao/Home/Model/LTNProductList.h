//
//  LTNProductList.h
//  lingtouniao
//
//  Created by LiuFeifei on 16/6/15.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "BaseModel.h"
#import "LTNProduct.h"

@interface LTNProductList : BaseModel

@property (nonatomic) NSArray * productList;
+ (NSArray *)sortArray:(NSArray *)array;

@end
