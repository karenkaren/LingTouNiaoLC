//
//  TextfieldCell.h
//  lingtouniao
//
//  Created by zhangtongke on 16/3/31.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextfieldCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic,strong)NSDictionary *cellDic;
@property (nonatomic,strong)UITextField *textField;
@property (nonatomic,copy)void(^textFieldTextChangeBlock)(NSString *text);
@end
