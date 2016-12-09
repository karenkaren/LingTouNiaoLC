//
//  ProductIntroduceModel.m
//  lingtouniao
//
//  Created by LiuFeifei on 16/6/13.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "ProductIntroduceModel.h"

@implementation ProductIntroduceModel

+ (instancetype)productIntroduceWithType:(ProductType)productType
{
    ProductIntroduceModel * produceIntroduceModel = [[ProductIntroduceModel alloc] initWithProductType:productType];
    return produceIntroduceModel;
}

- (instancetype)initWithProductType:(ProductType)productType
{
    self = [super init];
    if (self) {
        switch (productType) {
            case ProductTypeOfLCT:
                [self configLCT];
                break;
            case ProductTypeOfLCTXL:
                [self configLCTXL];
                break;
            default:
                break;
        }
    }
    return self;
}

- (void)configLCT
{
    self.productIntroduce = locationString(@"lct_detail");
    self.items = @[locationString(@"tab_home_item2"), locationString(@"tab_home_item3"), locationString(@"tab_home_item4")];
}

- (void)configLCTXL
{
    self.productIntroduce = locationString(@"lctxl_detail");
    self.items = @[locationString(@"tab_home_item7"), locationString(@"tab_home_item8"), locationString(@"tab_home_item9")];
}

@end
