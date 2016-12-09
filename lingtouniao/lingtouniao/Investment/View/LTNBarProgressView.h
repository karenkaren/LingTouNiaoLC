//
//  LTNBarProgressView.h
//  lingtouniao
//
//  Created by 郑程锋 on 16/3/23.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTNBarProgressView : UIView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic)BOOL finished;
@property (nonatomic, copy) NSString * lineColorString;

@end
