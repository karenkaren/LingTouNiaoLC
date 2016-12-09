//
//  FriendsModel.h
//  lingtouniao
//
//  Created by 郑程锋 on 15/12/25.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendsModel : NSObject


@property(nonatomic)NSString *title;

//注册人数
@property(nonatomic)NSInteger registeredNum;

//实名人数
@property(nonatomic)NSInteger realNameNum;

//绑卡人数
@property(nonatomic)NSInteger bkPersonNum;

//已投资人数
@property(nonatomic)NSInteger investNum;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
