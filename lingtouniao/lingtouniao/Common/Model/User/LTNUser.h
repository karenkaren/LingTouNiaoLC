//
//  LTNUser.h
//  lingtouniao
//
//  Created by  mathe on 15/12/17.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import "BaseModel.h"

#import "UserInfoModel.h"
#import "AccountInfoModel.h"


@interface LTNUser : BaseModel

@property (nonatomic, strong) UserInfoModel *userInfo;//用户基本信息
@property (nonatomic, strong) AccountInfoModel *accountInfo;//标底信息




@end
