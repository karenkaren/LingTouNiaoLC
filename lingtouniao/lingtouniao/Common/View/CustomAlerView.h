//
//  CustomAlerView.h
//  lingtouniao
//
//  Created by 郑程锋 on 16/5/5.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MyWindowClick){
    
    MyWindowClickForOK = 0,//确定按钮
    
    MyWindowClickForCancel//取消按钮
};

typedef void (^callBack)(MyWindowClick buttonIndex);

@interface CustomAlerView : UIWindow

@property (nonatomic, copy) callBack clickBlock ;//按钮点击事件的回调

+ (instancetype)shared;

//创建AlertView
+ (instancetype)showAlertViewWithImage:(NSString *)image title:(NSString *)title detail:(NSString *)detail canleButtonTitle:(NSString *)canle okButtonTitle:(NSString *)ok callBlock:(callBack)callBack;



@end
