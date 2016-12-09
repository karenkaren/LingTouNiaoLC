//
//  LTNBaseStatisticsModel.h
//  lingtouniao
//
//  Created by LiuFeifei on 16/3/17.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTNBaseStatisticsModel : NSObject

@property (nonatomic, strong) NSString * total;
@property (nonatomic, strong) NSArray * datas;

- (instancetype)initWithData:(id)data withColors:(NSArray *)colors;

@end
