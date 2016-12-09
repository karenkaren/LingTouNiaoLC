//
//  GuideShadeView.h
//  lingtouniao
//
//  Created by zhangtongke on 16/6/7.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *LTNTeachTypeNone      = @"LTNTeachTypeNone";       //默认

static NSString *LTNTeachTypeParter      = @"LTNTeachTypeParter";       //合伙人
static NSString *LTNTeachTypeBirdCoin    = @"LTNTeachTypeBirdCoin";             // 鸟币
static NSString *LTNTeachTypeBirdTicket    = @"LTNTeachTypeBirdTicket";             // 理财金券

typedef void(^DismissBlock)(void);
@interface GuideShadeView : UIView
singleton_interface(GuideShadeView)
@property (nonatomic,strong)NSMutableDictionary *teachDic;

@property (nonatomic, copy) DismissBlock closeBlock;

+ (BOOL)shouldShowTeachingViewWithType:(NSString *)type;

/**
 *  添加教程
 *
 *  @param teachType type
 *  @param View      目标视图
 */
+ (void)addTeachType:(NSString *)teachType withView:(id)View;
/**
 *  显示新手教程(will check the right function addTeachType has called)
 *
 *  @param teachType type
 *  @param block     目标视图
 */
+ (void)showTeachType:(NSString *)teachType withCloseBlock:(void (^)(void))block;
/**
 *  在目标视图上显示新手教程(不需要与其他方法配合)
 *
 *  @param type  type
 *  @param view  目标视图
 *  @param block 回调block
 */
+ (void)showWithType:(NSString *)type withView:(id)view withCloseBlock:(void (^)(void))block;
/**
 *  在目标frame范围上显示新手教程(不需要与其他方法配合)
 *
 *  @param teachType    type
 *  @param dstViewFrame 目标范围
 *  @param block        回调block
 */
+ (void)showTeachType:(NSString *)teachType withFrame:(CGRect)dstViewFrame withCloseBlock:(void (^)(void))block;



@end
