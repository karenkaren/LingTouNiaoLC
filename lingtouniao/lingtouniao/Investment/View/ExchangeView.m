//
//  ExchangeView.m
//  lingtouniao
//
//  Created by 徐凯 on 2016/11/9.
//  Copyright © 2016年 lingtouniao. All rights reserved.
//

#import "ExchangeView.h"

@implementation ExchangeView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.exchangeTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.exchangeTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.exchangeTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.exchangeTextField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.exchangeTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.exchangeTextField.layer.borderWidth= 1.0f;
    self.exchangeTextField.delegate = self;
    if (kScreenWidth == 320) {
        [_exchangeTextField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    }else if (kScreenWidth == 375 || kScreenWidth == 414)
    {
        [_exchangeTextField setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    }else
    {
     [_exchangeTextField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"ExchangeView" owner:self options:nil] objectAtIndex:0];
        self.frame = CGRectMake(0, 0, kScreenWidth,74.0);
    }
    return self;
}

- (IBAction)btnClick:(id)sender {
    
    
    if([esString(_exchangeTextField.text) length]==0){
        [LTNUtilsHelper boxShowWithMessage:locationString(@"no_coupon_code") duration:2.0f];
        return;
    }
    NSMutableDictionary *parameter=[NSMutableDictionary dictionaryWithDictionary:@{@"presentCode":esString(_exchangeTextField.text)}];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Exchange_copoun
                                                        object:nil userInfo:parameter];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
