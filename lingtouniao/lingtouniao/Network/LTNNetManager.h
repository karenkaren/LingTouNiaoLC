//
//  LTNNetManager.h
//  lingtouniao
//
//  Created by LiuFeifei on 15/12/9.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LTNNetManager : NSObject

singleton_interface(LTNNetManager)

// 网络是否可以用
@property (nonatomic, assign) BOOL isAvailable;

@end
