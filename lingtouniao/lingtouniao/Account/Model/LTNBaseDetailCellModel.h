//
//  LTNBaseDetailCellModel.h
//  lingtouniao
//
//  Created by LiuFeifei on 15/12/28.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTNBaseDetailCellModel : NSObject

@property (nonatomic, strong) NSString * total;
@property (nonatomic, strong) NSArray * datas;

- (instancetype)initWithData:(id)data;

@end
