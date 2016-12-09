//
//  SGSheetMenu.h
//  lingtouniao
//
//  Created by 徐凯 on 15/12/29.
//  Copyright © 2015年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SGSheetMenuDelegate <NSObject>

-(void)refreshCopoun:(NSInteger)index;

@end

@interface SGSheetMenu : UIView


- (id)initWithTitle:(NSString *)title itemTitles:(NSArray *)itemTitles;

- (id)initWithTitle:(NSString *)title itemTitles:(NSArray *)itemTitles subTitles:(NSArray *)subTitles  descTitles:(NSArray *)descTitles isShowExchangeView:(BOOL)show;

@property (nonatomic,assign) NSUInteger selectedItemIndex;

- (void)triggerSelectedAction:(void(^)(NSInteger))actionHandle;

@property(nonatomic,assign) id <SGSheetMenuDelegate> delegate;


@end
