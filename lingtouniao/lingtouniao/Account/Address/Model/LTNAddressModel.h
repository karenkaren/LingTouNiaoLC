//
//  LTNAddressModel.h
//  lingtouniao
//
//  Created by 郑程锋 on 16/11/3.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "BaseModel.h"

@interface LTNAddressModel : BaseModel

@property (nonatomic) NSString *consigneeName;//收货人姓名

@property (nonatomic) NSString *detailAddress;//详细地址

@property (nonatomic) NSString *ID;//地址主键

@property (nonatomic) NSString *location;//所在地

@property (nonatomic) NSString *mobileNo;//收货人手机号


@end
