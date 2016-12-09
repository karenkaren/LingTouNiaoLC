//
//  LTNMutualModel.h
//  lingtouniao
//
//  Created by 郑程锋 on 16/9/21.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "BaseModel.h"

@interface LTNMutualModel : BaseModel

@property (nonatomic) NSString *mutualIcon;//图片
@property (nonatomic) NSString *taskDesc;//标题
@property (nonatomic) NSString *taskEndValue;

@property (nonatomic) NSString *mutualStartSalary;//起薪

@end

@interface LTNMutualList : BaseModel

@property (nonatomic) NSArray *taskList;

@end

