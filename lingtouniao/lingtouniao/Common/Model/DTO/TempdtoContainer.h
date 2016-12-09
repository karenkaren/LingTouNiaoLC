//
//  TempdtoContainer.h
//  lingtouniao
//
//  Created by 徐凯 on 15/12/28.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TempdtoContainer : NSObject

@property (nonatomic) NSInteger resultCode;
@property (nonatomic,copy) NSString *resultMessage;
@property (nonatomic,strong) NSDictionary *data;

@end
