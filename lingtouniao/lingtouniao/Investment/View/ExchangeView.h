//
//  ExchangeView.h
//  lingtouniao
//
//  Created by 徐凯 on 2016/11/9.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExchangeView : UIView<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *exchangeTextField;
@property (nonatomic,copy)ESHandlerBlock handleBlock;

@end
