//
//  LTNMessageModel.h
//  lingtouniao
//
//  Created by 郑程锋 on 16/3/14.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "BaseModel.h"


/**
 *  .......
 */
@interface LTNMessageList : BaseModel

@property (nonatomic) NSArray *messages;

@end



@interface LTNMessageModel : BaseModel

@property (nonatomic) NSString *title;//标题
@property (nonatomic) NSString *content;//内容
@property (nonatomic) NSString *createDate;//时间
@property (nonatomic) NSString *isRead;// 0 未读 1 已读
@property (nonatomic) NSString *ID;



@end
