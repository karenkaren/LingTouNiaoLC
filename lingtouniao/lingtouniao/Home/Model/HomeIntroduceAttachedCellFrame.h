//
//  HomeIntroduceAttachedCellFrame.h
//  lingtouniao
//
//  Created by LiuFeifei on 16/6/23.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProductIntroduceModel;

#define kItemFontSize 14
#define kIntroduceFont [CustomerizedFont heiti:14]
#define kItemFont [CustomerizedFont heiti:kItemFontSize]

@interface HomeIntroduceAttachedCellFrame : NSObject

+ (instancetype)attachedCellFrameWithProductIntroduce:(ProductIntroduceModel *)introduce;

@property (nonatomic, strong) ProductIntroduceModel * introduce;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGRect introduceFrame;
@property (nonatomic, strong) NSArray * circleFrames;
@property (nonatomic, strong) NSArray * itemFrames;

@end
