//
//  ProductIntroduceModel.h
//  lingtouniao
//
//  Created by LiuFeifei on 16/6/13.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class HomeIntroduceAttachedCellFrame;

typedef NS_ENUM(NSUInteger, ProductType) {
    ProductTypeOfLCT,
    ProductTypeOfLCTXL
};

@interface ProductIntroduceModel : NSObject

@property (nonatomic, copy) NSString * productIntroduce;;
@property (nonatomic, strong) NSArray * items;
//@property (nonatomic, strong) HomeIntroduceAttachedCellFrame * cellFrame;

+ (instancetype)productIntroduceWithType:(ProductType)productType;

@end
