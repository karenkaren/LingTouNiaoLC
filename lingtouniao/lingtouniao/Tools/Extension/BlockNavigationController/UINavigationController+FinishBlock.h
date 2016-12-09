//
//  UINavigationController+FinishBlock.h
//  lingtouniao
//
//  Created by zhangtongke on 16/1/7.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UINavigationController (FinishBlock)
@property (nonatomic,copy)VoidBlock finishBlock;
@end
