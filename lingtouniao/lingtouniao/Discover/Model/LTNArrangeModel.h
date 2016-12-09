//
//  LTNArrangeModel.h
//  lingtouniao
//
//  Created by 郑程锋 on 16/9/21.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "BaseModel.h"

@interface LTNArrangeModel : BaseModel

@property (nonatomic) NSString *arrangeIcon;//图片
@property (nonatomic) NSString *taskDesc;//标题

@property (nonatomic) NSString *arrangeIncome;//收益
@property (nonatomic) NSString *arrangeStartSalary;//起薪

@end

@interface LTNArrangeList : BaseModel

@property (nonatomic) NSArray *taskList;

@end


