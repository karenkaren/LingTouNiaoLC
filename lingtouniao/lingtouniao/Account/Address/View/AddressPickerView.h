//
//  AddressPickerView.h
//  lingtouniao
//
//  Created by 郑程锋 on 16/11/3.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void(^AdressBlock)(NSString *province, NSString *city, NSString *district);

@interface AddressPickerView : UIView


@property (nonatomic,copy) AdressBlock block;

+ (id)shareInstance;
- (void)showBottomView;

@end


