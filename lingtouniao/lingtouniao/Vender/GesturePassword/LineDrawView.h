//
//  LineDrawView.h
//  lingtouniao
//
//  Created by zhangtongke on 16/5/6.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineDrawView : UIView

@property (nonatomic) BOOL success;
@property (nonatomic) CGPoint lineStartPoint;
@property (nonatomic)CGPoint lineEndPoint;

@property (nonatomic,strong)NSMutableArray * touchesArray;
@property (nonatomic,strong)NSMutableArray * touchedArray;

@end
