//
//  CustomAlertView2.h
//  lingtouniao
//
//  Created by 郑程锋 on 16/6/28.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MyWindowClick2){
    
    MyWindowClickForOK = 0,//确定按钮
    
    MyWindowClickForCancel//取消按钮
};

typedef void (^callBack2)(MyWindowClick2 buttonIndex);

@interface CustomAlertView2 : UIView

@property (nonatomic, copy) callBack2 clickBlock ;//按钮点击事件的回调

//+ (instancetype)shared2;

//创建AlertView
+ (instancetype)showAlertViewWithImage:(NSString *)image  detail:(NSString *)detail canleButtonTitle:(NSString *)canle okButtonTitle:(NSString *)ok onViewController:(UIViewController *)viewController callBlock:(callBack2)callBack;



@end
