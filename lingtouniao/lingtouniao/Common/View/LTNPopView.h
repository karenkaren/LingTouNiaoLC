//
//  LTNPopView.h
//  lingtouniao
//
//  Created by 郑程锋 on 16/11/2.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTNPopView : UIView

-(id)initWithTouchView:(id)view popWidth:(CGFloat)width;
-(void)show;
-(void)dismiss;

@property (nonatomic, copy) UIColor *borderColor;
@property (nonatomic, copy) void (^selectRowAtIndex)(NSInteger index);

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;

@end
