//
//  CustomAlertViews.h
//  lingtouniao
//
//  Created by 郑程锋 on 16/6/1.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MyWindowClicks){
    
    MyWindowClickForSures = 0, //领奖按钮
    
    MyWindowClickForCloses //关闭按钮
    
    
};

typedef void (^callBacks)(MyWindowClicks buttonIndexs);

@interface CustomAlertViews : UIView

@property (nonatomic, copy) callBacks clickBlocks ;//按钮点击事件的回调

//+ (instancetype)shareds;


+ (instancetype)showAlertViewWithImage:(NSString *)image title:(NSString *)title detail:(NSString *)detail closeButtonImage:(NSString *)close sureButtonTitle:(NSString *)sure onViewController:(UIViewController *)viewController callBlock:(callBacks)callBack;



@end
