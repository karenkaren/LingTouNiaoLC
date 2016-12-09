//
//  UINavigationController+FinishBlock.m
//  lingtouniao
//
//  Created by zhangtongke on 16/1/7.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "UINavigationController+FinishBlock.h"

@implementation UINavigationController (FinishBlock)

- (VoidBlock)finishBlock {
    return objc_getAssociatedObject(self, @selector(finishBlock));
}

- (void)setFinishBlock:(VoidBlock)aFinishBlock{
    objc_setAssociatedObject(self, @selector(finishBlock), aFinishBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
