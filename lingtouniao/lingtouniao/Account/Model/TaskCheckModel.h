//
//  TaskCheckModel.h
//  lingtouniao
//
//  Created by LiuFeifei on 16/6/29.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "BaseModel.h"
#import "TaskPrizeModel.h"

@interface TaskCheckModel : BaseModel

@property (nonatomic, strong) TaskPrizeModel * taskPrize;

@end
