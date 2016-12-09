//
//  SGActionView.h
//  lingtouniao
//
//  Created by 徐凯 on 15/12/29.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGSheetMenu.h"

typedef void(^SGMenuActionHandler)(NSInteger index);

@interface SGActionView : UIView

 /**
 *  获取单例
 */
+ (SGActionView *)sharedActionView;
/**
 *	选择列表弹出层
 *
 *	@param 	title           标题
 *	@param 	itemTitles      行标题
 *	@param 	itemSubTitles 	行子标题
 *	@param 	handler         回调，index从 0 开始
 */
+ (void)showSheetWithTitle:(NSString *)title
                itemTitles:(NSArray *)itemTitles
             selectedIndex:(NSInteger)selectedIndex
            selectedHandle:(SGMenuActionHandler)handler;


/**
 *	选择列表弹出层（指定选中行）
 *
 *	@param 	title           标题
 *	@param 	itemTitles      行标题
 *	@param 	itemSubTitles 	行子标题
 *	@param 	selectedIndex 	选中行index
 *	@param 	handler         回调，index从 0 开始
 */
+ (void)showSheetWithTitle:(NSString *)title
                itemTitles:(NSArray *)itemTitles
                descTitles:(NSArray *)descTitles
             itemSubTitles:(NSArray *)itemSubTitles
             selectedIndex:(NSInteger)selectedIndex
        isShowExchangeView:(BOOL)show
            selectedHandle:(SGMenuActionHandler)handler;


- (void)dismissMenu:(SGSheetMenu *)menu Animated:(BOOL)animated;


@end
