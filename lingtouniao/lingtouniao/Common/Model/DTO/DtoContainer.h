//
//  DtoContainer.h
//  lingtouniao
//
//  Created by 徐凯 on 15/12/24.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DtoContainer : NSObject

@property (nonatomic) NSInteger resultCode;
@property (nonatomic) NSString *resultMessage;
@property (nonatomic) BaseModel *data;
@property (nonatomic) NSInteger totalCount;

@end
